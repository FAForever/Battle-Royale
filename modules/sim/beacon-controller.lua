local ACUInfo = import('/mods/Battle-Royale-by-Dark-Horse/modules/sim/ACUInfo.lua')
local TransferUnitsOwnership = import('/lua/SimUtils.lua').TransferUnitsOwnership
local EffectTemplates = import("/lua/EffectTemplates.lua")
local EffectUtils = import("/lua/EffectUtilities.lua")
local ShowDeathInfo = import("/mods/Battle-Royale-by-Dark-Horse/modules/ui/beacon-info.lua").ShowDeathInfo
local CarePackageTeleportIn = EffectTemplates.UnitTeleport01
local CarePackageDestroyed = table.concatenate(EffectTemplates.CommanderQuantumGateInEnergy, EffectTemplates.AGravitonBolterHit01)

--if multiplier = 0.75
local T2Stage = 20000
local T3Stage = 80000
local Multiplier = ScenarioInfo.Options.BeaconTechLevel

--- Determines the cost of the units of the killed commander in the mass,
--- which is necessary to increase the tech level of the commander's beacon.
--- Depends on the BeaconTechLevel parameter defined in the lobby.
function InitStageCost()
    if Multiplier == 1.0 then
        T2Stage = 30000
        T3Stage = 100000
    end

    if Multiplier == 1.25 then
        T2Stage = 42000
        T3Stage = 120000
    end

    if Multiplier == 1.5 then
        T2Stage = 60000
        T3Stage = 150000
    end
end

InitStageCost()

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

--- Depending on the amount of mass defined in the lobby, it will return the id t1, t2 or t3 of the command beacon.
--- @param massCost - total cost of units in mass
function DefineBeaconId(massCost)
    local result = 'uac1301'

    if massCost > T2Stage and massCost < T3Stage then
        result = 'xsc1501'
    end

    if massCost > T3Stage then
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

    local beaconId = DefineBeaconId(unitsData.totalMassCost)
    local beacon = CreateUnitHPR(beaconId, "NEUTRAL_CIVILIAN", xPos, yPos, zPos, 0, 0, 0)
    local nickname = unpack(ACUInfo.PlayersNicknames:GetNickname(selfIndex))

    beacon:SetCustomName(GenerateBeaconName(nickname, unitsData))

    CreateVisibleSpots(selfIndex, xPos, zPos)

    ShowDeathInfo(nickname, unitsData)


    local DrawCircleThread = import("/mods/Battle-Royale-by-Dark-Horse/modules/ui/beacon-info.lua").DrawCircleThread


    -- threads that draw a circle around the place of death of the commander
    local circleThread = ForkThread(DrawCircleThread, ACUInfo.ACUDeathCoordinates:GetCoords(selfIndex))

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
        beacon = nil
    end


    -- when captured, everything is given
    local function OnCaptured(old, new)

        local effects = EffectUtils.CreateEffects(beacon, 1, CarePackageDestroyed)
        beacon:Destroy()
        TransferUnitsOwnership(units, new.Army)

        KillThread(circleThread)
        beacon = nil
    end

    beacon:AddUnitCallback(OnReclaimed, "OnReclaimed")
    beacon:AddUnitCallback(OnKilled, "OnKilled")
    beacon:AddOnCapturedCallback(OnCaptured)
end