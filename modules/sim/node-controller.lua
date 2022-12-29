-- local Ping = import(ScenarioInfo.path .. 'Functionality/Ping.lua');

-- localize commonly used global functions for performance
local import = import

local EffectTemplates = import("/lua/EffectTemplates.lua")
local EffectUtils = import("/lua/EffectUtilities.lua")

local CarePackageTeleportIn = EffectTemplates.UnitTeleport01
local CarePackageDestroyed = table.concatenate(EffectTemplates.CommanderQuantumGateInEnergy, EffectTemplates.AGravitonBolterHit01)
local CarePackageOnWater = EffectTemplates.DefaultSeaUnitBackWake01
local ProblematicUnits = import("/mods/Battle-Royale-by-Dark-Horse/modules/packer/units-problematic.lua").UnitTable
local SACUWithExperimental = ScenarioInfo.Options.SacuSpawn
local NavalExps = ScenarioInfo.Options.NavalExps
local ExpsCounter = 0

function InitExpsCounter()
    if NavalExps == "only_naval" then
        return
    end

    if NavalExps == "fifty_fifty" then
        ExpsCounter = 1
    else
        ExpsCounter = 2
    end
end

InitExpsCounter()

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

--- Draws out all the nodes. Used for debugging purposes.
function DebugNodes()

    local function DebugNodesThread()
        while true do

            WaitSeconds(0.1)

            local model = import("/mods/Battle-Royale-by-Dark-Horse/modules/sim/model.lua")

            for k = 1, model.NodeCount do

                local node = model.Nodes[k]

                -- determine color
                local color = "ffff00"
                if node.InWater then
                    color = "aaaaff"
                end

                -- draw it out
                DrawCircle(node.Coordinates, 5, color)
            end
        end
    end

    ForkThread(DebugNodesThread)
end

--- Spawn a 'care package' at one of the remaining nodes.
function SpawnCarePackage(node, bps)

    -- make coordinates in case of terrain deformation
    local cx = node.Coordinates[1]
    local cz = node.Coordinates[3]
    local cy = GetTerrainHeight(cx, cz)

    -- computes a single point on the circle.
    function ComputePoint(center, radius, radians)
        return {
            center[1] + radius * math.cos(radians),
            center[2] + 0,
            center[3] + radius * math.sin(radians),
        };
    end

    -- computes the radius and makes adjustments if the unit is problematic
    function ComputeRadius(bp)
        --default radius
        local radius = 3

        for _, unit in ProblematicUnits do
            if unit.id:lower() == bp:lower() then
                radius = radius + unit.radiusIncrease
            end
        end

        return radius
    end

    local twoPi = 6.28

    -- determine total number of blueprints
    local center = { cx, cy, cz }
    local count = table.getn(bps)
    local offset = Random() * twoPi

    if count > 5 then
        count = 0.5 * count
    end

    -- for each blueprint...
    local units = { }
    for k, bp in bps do

        -- determine radius
        local radius = ComputeRadius(bp)

        local l = k
        if k > count then
            radius = radius * 2
            l = k - count + 0.5
        end

        -- compute spawn location
        local coords = ComputePoint(center, radius, l / count * twoPi + offset)

        -- compute heading
        local rad = math.atan2(cx - coords[1], cz - coords[3])
        local degrees = rad * (180 / math.pi)

        if node.InWater then
            radius = radius * 1.25
            rad = rad + 1.57
        end

        -- spawn unit
        table.insert(units, CreateUnitHPR(bp, "NEUTRAL_CIVILIAN", coords[1], coords[2], coords[3], 0, rad, 0))
    end

    -- construct the beacon
    local beacon = CreateUnitHPR('UEB5103', "NEUTRAL_CIVILIAN", cx, cy, cz, 0, offset, 0)
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

    beacon:AddUnitCallback(OnKilled, "OnKilled")
    beacon:AddUnitCallback(OnReclaimed, "OnReclaimed")

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

    beacon:AddOnCapturedCallback(OnCaptured)
end

--- Retrieves a random node.
function GetRandomNode()
    -- retrieve a random node
    local model = import("/mods/Battle-Royale-by-Dark-Horse/modules/sim/model.lua")
    local k = math.floor(Random() * model.NodeCount) + 1
    return model.Nodes[k]
end

--- Retrieves random blueprints from the entries table.
function GetRandomBlueprints(entries, count)

    local rngs = { }
    for k = 1, count do
        local bpId = entries[math.floor(Random() * table.getn(entries)) + 1]

        --if sacu spawning is enabled in the lobby, add the id of a random sacu to the list
        if SACUWithExperimental == 1 then
            local bp = __blueprints[bpId:lower()]
            local isExperimental = bp.General.Category == 'Experimental' or bp.General.TechLevel == 'RULEUTL_Experimental'

            if isExperimental then
                local sacuList = { 'UEL0301_ras', 'UAL0301_ras', 'URL0301_ras', 'XSL0301_engineer', }
                local sacuId = sacuList[math.floor(Random() * table.getn(sacuList)) + 1]
                table.insert(rngs, sacuId)
            end
        end

        table.insert(rngs, bpId)

    end

    return rngs
end

--- Based on the option for spawning naval experimental units defined in the lobby,
--- returns the currently required type of experimental unit (naval or land / air)
function GetCertainEntryType()

    local function GetAirOrLand()
        local prn = math.random(2)
        return prn == 2 and "Air T4" or "Land T4"
    end

    if NavalExps == "fifty_fifty" then
        if ExpsCounter == 1 then
            ExpsCounter = 0
            return "Navy T4"
        else
            ExpsCounter = 1
            return GetAirOrLand()
        end
    end

    if NavalExps == "more_naval" then
        if ExpsCounter == 2 or ExpsCounter == 1 then
            ExpsCounter = ExpsCounter - 1
            return "Navy T4"
        else
            ExpsCounter = 2
            return GetAirOrLand()
        end
    end

    if NavalExps == "more_other" then
        if ExpsCounter == 2 or ExpsCounter == 1 then
            ExpsCounter = ExpsCounter - 1
            return GetAirOrLand()
        else
            ExpsCounter = 2
            return "Navy T4"
        end
    end
end

function CarePackages(rate, amount, curve)
    ForkThread(CarePackageThread, rate, amount, curve)
end

--- The thread that spawns the care packages throughout the game.
function CarePackageThread(rate, amount, curve)

    while true do

        -- wait till we spawn another one
        WaitSeconds(rate)

        -- get a random node that has no beacon
        local attempts = 3
        local node = GetRandomNode()
        while node.Beacon and (attempts > 0) do
            node = GetRandomNode()
            attempts = attempts - 1
        end

        -- skip this iteration
        if node.Beacon then
            continue
        end

        -- determine number of minutes
        local minutes = curve * (GetGameTimeSeconds() / 60)

        -- retrieve valid entries from configuration
        local entries = false
        local config = import("/mods/Battle-Royale-by-Dark-Horse/modules/config.lua")
        if node.InWater then
            entries = config.GetValidEntries(config.Navy, minutes)
        else
            entries = config.GetValidEntries(config.Land, minutes)
        end

        -- see if there are any entries
        if table.getn(entries) > 0 then
            -- choose a random entry
            local entry = entries[math.floor(Random() * table.getn(entries)) + 1]
            local oldEntryType = entry.Type

            if not (NavalExps == "only_naval") and entry.Type == "Navy T4" then
                entry.Type = GetCertainEntryType()
            end

            -- retrieve random blueprints from that entry
            local model = import("/mods/Battle-Royale-by-Dark-Horse/modules/sim/model.lua")
            local bps = GetRandomBlueprints(model.CarePackages[entry.Type], amount * entry.Count)
            entry.Type = oldEntryType


            -- create the care package
            SpawnCarePackage(node, bps)

            -- tell the UI
            Sync.BattleRoyale = Sync.BattleRoyale or { }
            Sync.BattleRoyale.CarePackage = { }
            Sync.BattleRoyale.CarePackage.Coordinates = node.Coordinates
            Sync.BattleRoyale.CarePackage.InWater = node.InWater
            Sync.BattleRoyale.CarePackage.Blueprints = bps
            Sync.BattleRoyale.CarePackage.Interval = rate
        end
    end
end