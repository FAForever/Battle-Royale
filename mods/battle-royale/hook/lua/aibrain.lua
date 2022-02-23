local oldAIBrain = AIBrain

local TransferUnitsOwnership = import('/lua/SimUtils.lua').TransferUnitsOwnership
local ACUDeathCoordinates = import('/mods/battle-royale/modules/sim/ACUInfo.lua').ACUDeathCoordinates
local EffectTemplates = import("/lua/EffectTemplates.lua")
local EffectUtils = import("/lua/EffectUtilities.lua")
local CarePackageTeleportIn = EffectTemplates.UnitTeleport01
local CarePackageDestroyed = table.concatenate(EffectTemplates.CommanderQuantumGateInEnergy,EffectTemplates.AGravitonBolterHit01)
local TargetArmy = ScenarioInfo.Options.TargetArmy

--if multiplier = 0.75
local T2StageTime = 1020 -- 17 minute
local T3StageTime = 1920 -- 32 minute
local Multiplier = ScenarioInfo.Options.CarePackagesCurve

--- Initializes the time at which the commander's beacon will enter the t2 and t3 stages and sync ui.
--- Depends on the CarePackagesCurve parameter defined in the lobby.
function InitStageTimeAndSyncUI()
    if Multiplier == 1.0 then
        T2StageTime = 900 -- 15 minute
        T3StageTime = 1620 -- 27 minute
    end

    if Multiplier == 1.25 then
        T2StageTime = 720 --12 minute
        T3StageTime = 1320 -- 22 minute
    end

    if Multiplier == 1.5 then
        T2StageTime = 540 -- 9 minute
        T3StageTime = 1020 -- 17 minute
    end

    Sync.BattleRoyale = Sync.BattleRoyale or { }
    Sync.BattleRoyale.Beacon = { }
    Sync.BattleRoyale.Beacon.T2StageTime = T2StageTime
    Sync.BattleRoyale.Beacon.T3StageTime = T3StageTime
end

InitStageTimeAndSyncUI()

--- Depending on the time elapsed in the game, returns the id t1, t2 or t3 of the commander's beacon.
function DefineBeaconId()
    local result = 'uac1301'
    local inGameTime = GetGameTimeSeconds()

    if inGameTime > T2StageTime and inGameTime < T3StageTime then
        result = 'xsc1501'
    end

    if inGameTime > T3StageTime then
        result = 'xsc1301'
    end

    return result
end

function ResetUnitOrders(units)
    if units and not table.empty(units) then
        for _, unit in units do
            if not unit.Dead then
                IssueStop({unit})
                IssueClearCommands({unit})
            end
        end
    end
end

--- Iterates through the list of units, and destroys unfinished units.
--- @param units - list of player units
function DestroyUnfinishedUnits(units)
    for _, unit in units do
        if not unit.Dead and unit:GetFractionComplete() ~= 1 then
            unit:Destroy()
        end
    end
end

--- Creates a beacon at the location of the death of the ACU.
--- The beacon contains a list of the killed player's units.
--- The player who captures the beacon will receive all the units of the killed player.
--- @param units - list of killed player's units
--- @param xPos, yPos, zPos - coordinates of the destroyed ACU
function CreateCommanderBeacon(units, xPos, yPos, zPos)
    local beaconId = DefineBeaconId()
    local beacon = CreateUnitHPR(beaconId, "NEUTRAL_CIVILIAN", xPos, yPos, zPos, 0, 0, 0)

    -- makes beacon invulnerable for 4 seconds.
    beacon:SetCanTakeDamage(false)
    ForkThread(function(unit)
        if not unit then
            return
        end
        WaitSeconds(4)
        unit:SetCanTakeDamage(true) end,beacon)

    -- spawn effect
    local effects = EffectUtils.CreateEffects(beacon, 1, CarePackageTeleportIn)

    -- when reclaimed, everything dies
    local function OnReclaimed(self)
        for k, unit in units do
            if not unit.Dead then
                unit:Kill()
            end
        end

        beacon = nil
    end

    -- when killed, everything dies
    local function OnKilled(self)
        for k, unit in units do
            if not unit.Dead then
                unit:Kill()
            end
        end

        beacon = nil
    end


    -- when captured, everything is given
    local function OnCaptured(old, new)

        local effects = EffectUtils.CreateEffects(beacon, 1, CarePackageDestroyed)
        beacon:Destroy()
        TransferUnitsOwnership(units, new.Army)

        beacon = nil
    end

    beacon:AddUnitCallback(OnReclaimed, "OnReclaimed")
    beacon:AddUnitCallback(OnKilled, "OnKilled")
    beacon:AddOnCapturedCallback(OnCaptured)
end

--- This code is taken from the game engine.
--- Only a small part of it has been changed.
--- For the convenience of finding changes, they are marked as "change".

AIBrain = Class(oldAIBrain) {
    OnDefeat = function(self)
        self:SetResult("defeat")

        SetArmyOutOfGame(self:GetArmyIndex())

        import('/lua/SimUtils.lua').UpdateUnitCap(self:GetArmyIndex())
        import('/lua/SimPing.lua').OnArmyDefeat(self:GetArmyIndex())

        local function KillArmy()
            local shareOption = ScenarioInfo.Options.Share

            local function KillWalls()
                -- Kill all walls while the ACU is blowing up
                local tokill = self:GetListOfUnits(categories.WALL, false)
                if tokill and not table.empty(tokill) then
                    for index, unit in tokill do
                        unit:Kill()
                    end
                end
            end

            if shareOption == 'ShareUntilDeath' then
                ForkThread(KillWalls)
            end

            WaitSeconds(10) -- Wait for commander explosion, then transfer units.
            local selfIndex = self:GetArmyIndex()
            local shareOption = ScenarioInfo.Options.Share
            local victoryOption = ScenarioInfo.Options.Victory
            local BrainCategories = {Enemies = {}, Civilians = {}, Allies = {}}

            -- Used to have units which were transferred to allies noted permanently as belonging to the new player
            local function TransferOwnershipOfBorrowedUnits(brains)
                for index, brain in brains do
                    local units = brain:GetListOfUnits(categories.ALLUNITS, false)
                    if units and not table.empty(units) then
                        for _, unit in units do
                            if unit.oldowner == selfIndex then
                                unit.oldowner = nil
                            end
                        end
                    end
                end
            end

            -- Transfer our units to other brains. Wait in between stops transfer of the same units to multiple armies.
            local function TransferUnitsToBrain(brains)
                if not table.empty(brains) then
                    if shareOption == 'FullShare' then
                        local indexes = {}
                        for _, brain in brains do
                            table.insert(indexes, brain.index)
                        end
                        local units = self:GetListOfUnits(categories.ALLUNITS - categories.WALL - categories.COMMAND, false)
                        TransferUnfinishedUnitsAfterDeath(units, indexes)
                    end

                    for k, brain in brains do
                        local units = self:GetListOfUnits(categories.ALLUNITS - categories.WALL - categories.COMMAND, false)
                        if units and not table.empty(units) then
                            TransferUnitsOwnership(units, brain.index)
                            WaitSeconds(1)
                        end
                    end
                end
            end

            --- change (1)
            local function TransferUnitsToNeutralArmyAndReturnNewList(units)
                local newList = {}
                for k, unit in units do
                    if not unit.Dead then
                        local transferredUnit = ChangeUnitArmy(unit, "NEUTRAL_CIVILIAN")
                        table.insert(newList, transferredUnit)
                    end
                end
                return newList
            end
            --- end (1)

            -- Sort the destiniation armies by score
            local function TransferUnitsToHighestBrain(brains)
                if not table.empty(brains) then
                    table.sort(brains, function(a, b) return a.score > b.score end)
                    TransferUnitsToBrain(brains)
                end
            end

            -- Transfer units to the player who killed me
            local function TransferUnitsToKiller()
                local KillerIndex = 0
                local units = self:GetListOfUnits(categories.ALLUNITS - categories.WALL - categories.COMMAND, false)
                if units and not table.empty(units) then
                    if victoryOption == 'demoralization' then
                        KillerIndex = ArmyBrains[selfIndex].CommanderKilledBy or selfIndex
                        TransferUnitsOwnership(units, KillerIndex)
                    else
                        KillerIndex = ArmyBrains[selfIndex].LastUnitKilledBy or selfIndex
                        TransferUnitsOwnership(units, KillerIndex)
                    end
                end
                WaitSeconds(1)
            end

            -- Return units transferred during the game to me
            local function ReturnBorrowedUnits()
                local units = self:GetListOfUnits(categories.ALLUNITS - categories.WALL, false)
                local borrowed = {}
                for index, unit in units do
                    local oldowner = unit.oldowner
                    if oldowner and oldowner ~= self:GetArmyIndex() and not GetArmyBrain(oldowner):IsDefeated() then
                        if not borrowed[oldowner] then
                            borrowed[oldowner] = {}
                        end
                        table.insert(borrowed[oldowner], unit)
                    end
                end

                for owner, units in borrowed do
                    TransferUnitsOwnership(units, owner)
                end

                WaitSeconds(1)
            end

            -- Return units I gave away to my control. Mainly needed to stop EcoManager mods bypassing all this stuff with auto-give
            local function GetBackUnits(brains)
                local given = {}
                for index, brain in brains do
                    local units = brain:GetListOfUnits(categories.ALLUNITS - categories.WALL, false)
                    if units and not table.empty(units) then
                        for _, unit in units do
                            if unit.oldowner == selfIndex then -- The unit was built by me
                                table.insert(given, unit)
                                unit.oldowner = nil
                            end
                        end
                    end
                end

                TransferUnitsOwnership(given, selfIndex)
            end

            -- Sort brains out into mutually exclusive categories
            for index, brain in ArmyBrains do
                brain.index = index
                brain.score = CalculateBrainScore(brain)

                if not brain:IsDefeated() and selfIndex ~= index then
                    if ArmyIsCivilian(index) then
                        table.insert(BrainCategories.Civilians, brain)
                    elseif IsEnemy(selfIndex, brain:GetArmyIndex()) then
                        table.insert(BrainCategories.Enemies, brain)
                    else
                        table.insert(BrainCategories.Allies, brain)
                    end
                end
            end

            local KillSharedUnits = import('/lua/SimUtils.lua').KillSharedUnits

            --- change (2)
            local units = self:GetListOfUnits(categories.ALLUNITS - categories.WALL - categories.COMMAND, false)

            -- This part determines the share condition
            if TargetArmy then
                ReturnBorrowedUnits()
                GetBackUnits(BrainCategories.Allies)
                DestroyUnfinishedUnits(units)

                -- updating the list of units after we returned our own and other player's units
                units = self:GetListOfUnits(categories.ALLUNITS - categories.WALL - categories.COMMAND, false)

                if TargetArmy == "players_army" then
                    -- leave the units with the player and reset the orders
                    ResetUnitOrders(units)
                else
                    -- or transfer units to neutral army
                    units = TransferUnitsToNeutralArmyAndReturnNewList(units)
                end
            elseif shareOption == 'ShareUntilDeath' then
                --- end (2)
                KillSharedUnits(self:GetArmyIndex()) -- Kill things I gave away
                ReturnBorrowedUnits() -- Give back things I was given by others
            elseif shareOption == 'FullShare' then
                TransferUnitsToHighestBrain(BrainCategories.Allies) -- Transfer things to allies, highest score first
                TransferOwnershipOfBorrowedUnits(BrainCategories.Allies) -- Give stuff away permanently
            else
                GetBackUnits(BrainCategories.Allies) -- Get back units I gave away
                if shareOption == 'CivilianDeserter' then
                    TransferUnitsToBrain(BrainCategories.Civilians)
                elseif shareOption == 'TransferToKiller' then
                    TransferUnitsToKiller()
                elseif shareOption == 'Defectors' then
                    TransferUnitsToHighestBrain(BrainCategories.Enemies)
                else -- Something went wrong in settings. Act like share until death to avoid abuse
                    WARN('Invalid share condition was used for this game. Defaulting to killing all units')
                    KillSharedUnits(self:GetArmyIndex()) -- Kill things I gave away
                    ReturnBorrowedUnits() -- Give back things I was given by other
                end
            end

            --- change (3)
            if TargetArmy then
                CreateCommanderBeacon(units, unpack(ACUDeathCoordinates:GetCoords(selfIndex)))
            else
                local tokill = self:GetListOfUnits(categories.ALLUNITS - categories.WALL, false)
                if tokill and not table.empty(tokill) then
                    for index, unit in tokill do
                        unit:Kill()
                    end
                end

            end
            --- end (3)
        end

        -- AI
        if self.BrainType == 'AI' then
            -- print AI "ilost" text to chat
            SUtils.AISendChat('enemies', ArmyBrains[self:GetArmyIndex()].Nickname, 'ilost')
            -- remove PlatoonHandle from all AI units before we kill / transfer the army
            local units = self:GetListOfUnits(categories.ALLUNITS - categories.WALL, false)
            if units and not table.empty(units) then
                for _, unit in units do
                    if not unit.Dead then
                        if unit.PlatoonHandle and self:PlatoonExists(unit.PlatoonHandle) then
                            unit.PlatoonHandle:Stop()
                            unit.PlatoonHandle:PlatoonDisbandNoAssign()
                        end
                        IssueStop({unit})
                        IssueClearCommands({unit})
                    end
                end
            end
            -- Stop the AI from executing AI plans
            self.RepeatExecution = false
            -- removing AI BrainConditionsMonitor
            if self.ConditionsMonitor then
                self.ConditionsMonitor:Destroy()
            end
            -- removing AI BuilderManagers
            if self.BuilderManagers then
                for k, v in self.BuilderManagers do
                    v.EngineerManager:SetEnabled(false)
                    v.FactoryManager:SetEnabled(false)
                    v.PlatoonFormManager:SetEnabled(false)
                    v.EngineerManager:Destroy()
                    v.FactoryManager:Destroy()
                    v.PlatoonFormManager:Destroy()
                    if v.StrategyManager then
                        v.StrategyManager:SetEnabled(false)
                        v.StrategyManager:Destroy()
                    end
                    self.BuilderManagers[k].EngineerManager = nil
                    self.BuilderManagers[k].FactoryManager = nil
                    self.BuilderManagers[k].PlatoonFormManager = nil
                    self.BuilderManagers[k].BaseSettings = nil
                    self.BuilderManagers[k].BuilderHandles = nil
                    self.BuilderManagers[k].Position = nil
                end
            end
            -- delete the AI pathcache
            self.PathCache = nil
        end

        ForkThread(KillArmy)

        if self.Trash then
            self.Trash:Destroy()
        end
    end
}