local TransferUnitsOwnership = import('/lua/SimUtils.lua').TransferUnitsOwnership
local EffectTemplates = import("/lua/EffectTemplates.lua")
local EffectUtils = import("/lua/EffectUtilities.lua")
local CarePackageTeleportIn = EffectTemplates.UnitTeleport01
local CarePackageDestroyed = table.concatenate(EffectTemplates.CommanderQuantumGateInEnergy,EffectTemplates.AGravitonBolterHit01)

--if multiplier = 0.75
local T2StageTime = 1020 -- 17 minute
local T3StageTime = 1920 -- 32 minute

--- Initializes the time at which the commander's beacon will enter the t2 and t3 stages and sync ui.
--- @param multiplier - CarePackagesCurve parameter defined in the lobby.
function InitStageTimeAndSyncUI(multiplier)
    if multiplier == 1.0 then
        T2StageTime = 900 -- 15 minute
        T3StageTime = 1620 -- 27 minute
    end

    if multiplier == 1.25 then
        T2StageTime = 720 --12 minute
        T3StageTime = 1320 -- 22 minute
    end

    if multiplier == 1.5 then
        T2StageTime = 540 -- 9 minute
        T3StageTime = 1020 -- 17 minute
    end

    Sync.BattleRoyale = Sync.BattleRoyale or { }
    Sync.BattleRoyale.Beacon = { }
    Sync.BattleRoyale.Beacon.T2StageTime = T2StageTime
    Sync.BattleRoyale.Beacon.T3StageTime = T3StageTime
end

local BeaconMatrix = {
    T1 = {
        UEF = 'ueb5105',
        AEON = 'uab5105',
        CYBR = 'urb5105',
        SERA = 'xsb5105',
    },
    T2 = {
        UEF = 'ueb5205',
        AEON = 'uab5205',
        CYBR = 'urb5205',
        SERA = 'xsb5205',
    },
    T3 = {
        UEF = 'ueb5305',
        AEON = 'uab5305',
        CYBR = 'urb5305',
        SERA = 'xsb5305',
    },
}

--- Determines the stage depending on the time spent in the game.
--- @return - depending on CarePackagesCurve parameter defined in the lobby.
local function DefineStage()
    local stage = 'T1'
    local inGameTime = GetGameTimeSeconds()

    if inGameTime > T2StageTime and inGameTime < T3StageTime then
        stage = 'T2'
    end

    if inGameTime > T3StageTime then
        stage = 'T3'
    end

    return stage
end

--- Specifies the faction name based on the index
--- @param factionIndex - faction index
local function DefineFaction(factionIndex)
    local faction

    if factionIndex == 1 then
        faction = 'UEF'
    end
    if factionIndex == 2 then
        faction = 'AEON'
    end
    if factionIndex == 3 then
        faction = 'CYBR'
    end
    if factionIndex == 4 then
        faction = 'SERA'
    end

    return faction
end

--- Depending on the time elapsed in the game, returns the id t1, t2 or t3 of the command beacon
--- Depending on the player's faction.
--- @param factionIndex - faction index of the killed player
local function DefineBeaconId(factionIndex)
    local stage = DefineStage()
    local faction = DefineFaction(factionIndex)

    if not faction then
        return stage == 'T3' and 'xsc1301' or stage == 'T2' and 'xsc1501' or 'uac1301'
    end

    local beaconIdsList = BeaconMatrix[stage]
    return beaconIdsList[faction]
end
--- Sets the callback functions for the beacon
--- @param beacon - beacon  for which you need to set a callback
--- @param units - list of units that are attached to the beacon
--- @param nodeBeacon - beacon data stored in node
local function SetCallbacks(beacon, units, nodeBeacon)

    -- when reclaimed, everything dies
    local function OnReclaimed(self)
        for k, unit in units do
            if not unit.Dead then
                unit:Kill()
            end
        end

        if nodeBeacon then
            nodeBeacon = nil
        end
    end

    -- when killed, everything dies
    local function OnKilled(self)
        for k, unit in units do
            if not unit.Dead then
                unit:Kill()
            end
        end

        if nodeBeacon then
            nodeBeacon = nil
        end
    end


    -- when captured, everything is given
    local function OnCaptured(old, new)

        local effects = EffectUtils.CreateEffects(beacon, 1, CarePackageDestroyed)
        beacon:Destroy()
        TransferUnitsOwnership(units, new.Army)

        if nodeBeacon then
            nodeBeacon = nil
        end
    end

    beacon:AddUnitCallback(OnReclaimed, "OnReclaimed")
    beacon:AddUnitCallback(OnKilled, "OnKilled")
    beacon:AddOnCapturedCallback(OnCaptured)
end

--- Creates a beacon at the location of the death of the ACU.
--- The beacon contains a list of the killed player's units.
--- The player who captures the beacon will receive all the units of the killed player.
--- @param factionIndex - faction index of the killed player is needed to determine the beacons id
--- @param units - list of killed player's units
--- @param xPos, yPos, zPos - coordinates of the destroyed ACU
function CreateCommanderBeacon(factionIndex, units, xPos, yPos, zPos)
    local beaconId = DefineBeaconId(factionIndex)
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

    SetCallbacks(beacon, units)
end

--- Creates a beacon based on the passed parameters.
--- A list of units is "attached" to the beacon. When capturing, destroying or reclaiming a beacon,
--- the same thing happens with attached units.
--- @param node - object containing data about the care package
--- @param units - list of units that will be attached to the beacon
--- @param xPos, yPos, zPos, offset  - coordinates to create beacon
function CreateBeacon(node, units, xPos, yPos, zPos, offset)
    local beacon = CreateUnitHPR('UEB5103', "NEUTRAL_CIVILIAN", xPos, yPos, zPos, 0, offset, 0)
    node.Beacon = beacon

    -- spawn effect
    local effects = EffectUtils.CreateEffects(beacon, 1, CarePackageTeleportIn)

    SetCallbacks(beacon, units, node.Beacon)
end