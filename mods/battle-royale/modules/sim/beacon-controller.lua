local ACUInfo = import('/mods/battle-royale/modules/sim/ACUInfo.lua')
local TransferUnitsOwnership = import('/lua/SimUtils.lua').TransferUnitsOwnership
local EffectTemplates = import("/lua/EffectTemplates.lua")
local EffectUtils = import("/lua/EffectUtilities.lua")
local ShowDeathInfo = import("/mods/battle-royale/modules/ui/beacon-info.lua").ShowDeathInfo
local CarePackageTeleportIn = EffectTemplates.UnitTeleport01
local CarePackageDestroyed = table.concatenate(EffectTemplates.CommanderQuantumGateInEnergy, EffectTemplates.AGravitonBolterHit01)

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

--- Returns the number of units and the total cost in mass
function GetUnitsData(units)
    local totalMassCost = 0;
    local unitAmount = 0;

    if not table.empty(units) then
        for _, unit in units do
            unitAmount = unitAmount + 1
            local massCost = unit:GetBlueprint().Economy.BuildCostMass or 0
            totalMassCost = totalMassCost + massCost
        end
    end

    return { totalMassCost = totalMassCost, unitAmount = unitAmount }
end

function GenerateBeaconName(nickname, unitsData)
    local result = LOC("<LOC br_beacon_custom_name> Capture to get %s units worth %s mass")
    result = result:format(unitsData.unitAmount, unitsData.totalMassCost)
    return (nickname .. result)
end

--- Creates a visible spot where the commander died.
--- @param selfIndex - index of the army for which the visible spot is being created
--- @param x, y - death coords
function CreateVisibleSpots(selfIndex, x, z)
    local VizMarker = import('/lua/sim/VizMarker.lua').VizMarker
    local spec = {
        X = x,
        Z = z,
        Radius = 8,
        LifeTime = 60,
        Omni = false,
    }

    for index, brain in ArmyBrains do
        if not brain:IsDefeated() and selfIndex ~= index then
            spec.Army = index
            local vizEntity = VizMarker(spec)
        end
    end

end

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

--- If the total cost of the units of the killed commander in the mass exceeds 1.5k сreates a beacon at the location of the death of the ACU.
--- The beacon contains a list of the killed player's units.
--- The player who captures the beacon will receive all the units of the killed player.
--- @param units - list of killed player's units
--- @param xPos, yPos, zPos - coordinates of the destroyed ACU
function CreateCommanderBeacon(selfIndex, units, xPos, yPos, zPos)
    local unitsData = GetUnitsData(units)

    -- If the total cost of the units of the killed commander in the mass less than 1.5k just kill the units
    if unitsData.totalMassCost < 1500 then
        for _, unit in units do
            if not unit.Dead then
                unit:Kill()
            end
        end

        return
    end

    local beaconId = DefineBeaconId()
    local beacon = CreateUnitHPR(beaconId, "NEUTRAL_CIVILIAN", xPos, yPos, zPos, 0, 0, 0)
    local nickname = unpack(ACUInfo.PlayersNicknames:GetNickname(selfIndex))

    beacon:SetCustomName(GenerateBeaconName(nickname, unitsData))

    CreateVisibleSpots(selfIndex, xPos, zPos)

    ShowDeathInfo(nickname, unitsData)


    local DrawCircleThread = import("/mods/battle-royale/modules/ui/beacon-info.lua").DrawCircleThread
    local DiameterChangeThread = import("/mods/battle-royale/modules/ui/beacon-info.lua").DiameterChangeThread


    -- threads that draw a circle around the place of death of the commander
    local circleThread = ForkThread(DrawCircleThread, ACUInfo.ACUDeathCoordinates:GetCoords(selfIndex))
    local diameterThread = ForkThread(DiameterChangeThread)

    -- makes beacon invulnerable for 4 seconds.
    beacon:SetCanTakeDamage(false)
    ForkThread(function(unit)
        if not unit then
            return
        end
        WaitSeconds(4)
        unit:SetCanTakeDamage(true)
    end, beacon)

    -- spawn effect
    local effects = EffectUtils.CreateEffects(beacon, 1, CarePackageTeleportIn)

    -- when reclaimed, everything dies
    local function OnReclaimed(self)
        for k, unit in units do
            if not unit.Dead then
                unit:Kill()
            end
        end

        KillThread(circleThread)
        KillThread(diameterThread)
        beacon = nil
    end

    -- when killed, everything dies
    local function OnKilled(self)
        for k, unit in units do
            if not unit.Dead then
                unit:Kill()
            end
        end

        KillThread(circleThread)
        KillThread(diameterThread)
        beacon = nil
    end


    -- when captured, everything is given
    local function OnCaptured(old, new)

        local effects = EffectUtils.CreateEffects(beacon, 1, CarePackageDestroyed)
        beacon:Destroy()
        TransferUnitsOwnership(units, new.Army)

        KillThread(circleThread)
        KillThread(diameterThread)
        beacon = nil
    end

    beacon:AddUnitCallback(OnReclaimed, "OnReclaimed")
    beacon:AddUnitCallback(OnKilled, "OnKilled")
    beacon:AddOnCapturedCallback(OnCaptured)
end