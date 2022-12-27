-- localize commonly used global functions for performance
local import = import

local EffectUtils = import("/lua/EffectUtilities.lua")
local EffectTemplates = import("/lua/EffectTemplates.lua")

local CarePackageTeleportIn = EffectTemplates.UnitTeleport01
local CarePackageDestroyed = table.concatenate(EffectTemplates.CommanderQuantumGateInEnergy, EffectTemplates.AGravitonBolterHit01)

local Units = import("/mods/Battle-Royale-by-Dark-Horse/modules/packer/units-economic.lua").UnitTable
local BuildingPatterns = import("/mods/Battle-Royale-by-Dark-Horse/modules/packer/building-patterns.lua").Patterns

local FactionPrefixes = {}

local function DefineFactionPrefixes()
    FactionPrefixes = { "UE", "UR", "UA", "XS" }

    if (__blueprints['xnl0001']) then
        table.insert(FactionPrefixes, "XN")
    end
end

DefineFactionPrefixes()

function GetRandomFP()
    -- FP - faction prefix
    return FactionPrefixes[math.floor(Random() * table.getn(FactionPrefixes)) + 1]
end

function GetPowerGenId(prefix, stage)
    local PGens = Units["PGEN"]
    return (prefix:upper() .. PGens[stage:upper()])
end

function GetMexId(prefix, stage)
    local Mexes = Units["MEX"]
    return (prefix:upper() .. Mexes[stage:upper()])
end

function GetEngId(prefix, stage)
    local Engineers = Units["ENG"]
    return (prefix:upper() .. Engineers[stage:upper()])
end

function GetRandomSACUId()
    local sacuList = { 'UEL0301_ras', 'UAL0301_ras', 'URL0301_ras', 'XSL0301_engineer', }
    return sacuList[math.floor(Random() * table.getn(sacuList)) + 1]
end

function GetTransportId(prefix, stage)
    local Transports = Units["TRANSPORT"]

    local function GetT2orT3transport(chance)
        local prn = math.random(chance)
        return prn == 2 and "XEA0306" or (prefix:upper() .. Transports["T2"])--XEA0306 - T3 UEF Transport
    end

    if stage == "T3" then
        return GetT2orT3transport(5) -- ~20%
    elseif stage == "T4" then
        return GetT2orT3transport(3) -- ~33%
    else
        return (prefix:upper() .. Transports[stage:upper()])
    end
end

function GetPowerStorageId(prefix)
    return (prefix:upper() .. Units["PSTORAGE"])
end

function GetMassStorageId(prefix)
    return (prefix:upper() .. Units["MSTORAGE"])
end

function GetUnitList(surface, stage, x, z)
    local result = {}

    local Patterns = BuildingPatterns[surface .. " " .. stage]
    local Pattern = Patterns[math.floor(Random() * table.getn(Patterns)) + 1]

    local faction = GetRandomFP()

    local function FillUnitList(callback, element, stage)

        if not (Pattern[element]) then
            return
        end

        for _, e in Pattern[element] do
            local cx = x + e[1]
            local cz = z + e[2]
            local cy = GetTerrainHeight(cx, cz)

            local id = stage and callback(faction, stage) or callback(faction)

            local coords = { cx, cy, cz }

            table.insert(result, { id = id, coords = coords })
        end
    end

    FillUnitList(GetPowerGenId, "pgen", stage)
    FillUnitList(GetPowerStorageId, "pStorage")
    FillUnitList(GetMexId, "mex", stage)
    FillUnitList(GetMassStorageId, "mStorage")
    FillUnitList(GetEngId, "eng", stage)
    FillUnitList(GetTransportId, "trans", stage)
    FillUnitList(GetRandomSACUId, "sacu")

    return result
end

function GetGameStage (curve)
    local minutes = curve * (GetGameTimeSeconds() / 60)
    local stages = {
        { stage = "T1", min = 0, max = 10 },
        { stage = "T2", min = 8, max = 35 },
        { stage = "T3", min = 25, max = 50 },
        { stage = "T4", min = 40, max = 600 },
    }

    local validStages = {}

    for _, e in stages do
        if e.min < minutes and minutes < e.max then
            table.insert(validStages, e)
        end
    end
    return validStages[math.floor(Random() * table.getn(validStages)) + 1].stage

end

function SpawnEconomicCarePackage(node, stage)
    local cx = node.Coordinates[1]
    local cz = node.Coordinates[3]
    local cy = GetTerrainHeight(cx, cz)

    local surface = node.InWater and "Navy" or "Land"

    --local unitList = GetUnitList("Land", "T2", cx, cz)
    --local unitList = GetUnitList(surface, "T4", cx, cz)
    local unitList = GetUnitList(surface, stage, cx, cz)

    local units = {}

    for k, unit in unitList do

        if unit.coords then
            table.insert(units, CreateUnitHPR(unit.id, "NEUTRAL_CIVILIAN", unit.coords[1], unit.coords[2], unit.coords[3], 0, 0, 0))
        else
            table.insert(units, CreateUnitHPR(unit.id, "NEUTRAL_CIVILIAN", cx, cy, cz + 2, 0, 0, 0))
        end

    end

    -- construct the beacon
    local beacon = CreateUnitHPR('UEB5103', "NEUTRAL_CIVILIAN", cx, cy, cz, 0, 0, 0)
    node.Beacon = beacon

    -- spawn effect
    local effects = EffectUtils.CreateEffects(beacon, 1, CarePackageTeleportIn)

    -- when reclaimed, everything dies
    local function OnReclaimed(self)
        for k, unit in units do
            if not unit.Dead then
                unit:Kill()
            end
        end

        node.Beacon = nil
    end

    -- when killed, everything dies
    local function OnKilled(self)
        for k, unit in units do
            if not unit.Dead then
                unit:Kill()
            end
        end

        node.Beacon = nil
    end


    -- when captured, everything is given
    local function OnCaptured(old, new)

        local effects = EffectUtils.CreateEffects(beacon, 1, CarePackageDestroyed)
        beacon:Destroy()

        for k, unit in units do
            if not unit.Dead then
                ChangeUnitArmy(unit, new.Army)
            end
        end

        node.Beacon = nil
    end

    beacon:AddUnitCallback(OnReclaimed, "OnReclaimed")
    beacon:AddUnitCallback(OnKilled, "OnKilled")
    beacon:AddOnCapturedCallback(OnCaptured)
end

--- Removes nodes that became invalid because they dropped out of the map
function UpdateNodes(nodeCount, nodes)

    local model = import("/mods/Battle-Royale-by-Dark-Horse/modules/sim/model.lua")

    -- we adjust the count, leaving the nodes in-place
    local count = 0

    -- playable area
    local area = model.PlayableArea

    -- find nodes that are outside
    for k = 1, model.NodeCount do

        -- retrieve coords
        local node = model.Nodes[k]
        local x = node.Coordinates[1]
        local z = node.Coordinates[3]

        -- check if it is inside
        if area[1] < x and x < area[3] then
            if area[2] < z and z < area[4] then
                count = count + 1
                model.Nodes[count] = model.Nodes[k]
            end
        end
    end

    -- update model
    model.NodeCount = count
end

function GetRandomNode()
    -- retrieve a random node
    local model = import("/mods/Battle-Royale-by-Dark-Horse/modules/sim/model.lua")
    local k = math.floor(Random() * model.NodeCount) + 1
    return model.Nodes[k]
end

function CanSpawnNode(node, stage)
    if node.Beacon then
        return false
    end

    local brain = ArmyBrains[1]
    local buildingBP = "ueb0304"

    if node.InWater then
        buildingBP = "uab0103"
    end

    local function Check(coordList)
        local result = true

        for _, coords in coordList do
            if not brain:CanBuildStructureAt(buildingBP, coords) then
                result = false
                break
            end
        end

        return result
    end

    if stage == "T1" or stage == "T2" or stage == "T4" then
        local cx = node.Coordinates[1]
        local cz = node.Coordinates[3]
        local cy = GetTerrainHeight(cx, cz)

        local coordList = {
            { cx - 4, cy, cz },
            { cx + 4, cy, cz },
        }

        return Check(coordList)
    end

    if stage == "T3" then
        local cx = node.Coordinates[1]
        local cz = node.Coordinates[3]
        local cy = GetTerrainHeight(cx, cz)

        local coordList = {
            { cx - 4, cy, cz - 4 },
            { cx - 4, cy, cz + 4 },
            { cx + 4, cy, cz + 4 },
            { cx + 4, cy, cz - 4 },
        }

        return Check(coordList)
    else
        return true
    end
end

function DetermineRate (rate, stage)
    if stage == "T1" then
        return rate
    end

    if stage == "T2" or stage == "T4" then
        return rate * 1.5
    end

    if stage == "T3" then
        return rate * 2
    end

end

function EconomicCarePackages(rate, curve)
    ForkThread(EconomicCarePackageThread, rate, curve)
end

function EconomicCarePackageThread(rate, curve)

    while true do

        local stage = GetGameStage(curve)
        WaitSeconds(DetermineRate(rate, stage))

        -- get a random node that has no beacon
        local attempts = 5
        local node = GetRandomNode()

        while not (CanSpawnNode(node, stage)) and (attempts > 0) do
            node = GetRandomNode()

            attempts = attempts - 1
        end

        -- skip this iteration
        if node.Beacon then
            continue
        end

        SpawnEconomicCarePackage(node, stage)

        -- tell the UI
        Sync.BattleRoyale = Sync.BattleRoyale or { }
        Sync.BattleRoyale.CarePackage = { }
        Sync.BattleRoyale.CarePackage.Coordinates = node.Coordinates
        Sync.BattleRoyale.CarePackage.InWater = node.InWater
        Sync.BattleRoyale.CarePackage.Interval = rate

    end
end