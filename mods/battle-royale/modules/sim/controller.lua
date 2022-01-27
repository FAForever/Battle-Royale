
-- local Ping = import(ScenarioInfo.path .. 'Functionality/Ping.lua');

-- localize commonly used global functions for performance
local import = import

local EffectTemplates = import("/lua/EffectTemplates.lua")
local EffectUtils = import("/lua/EffectUtilities.lua")

local CarePackageTeleportIn = EffectTemplates.UnitTeleport01
local CarePackageDestroyed = table.concatenate(EffectTemplates.CommanderQuantumGateInEnergy,EffectTemplates.AGravitonBolterHit01)
local CarePackageOnWater = EffectTemplates.DefaultSeaUnitBackWake01

--- Removes nodes that became invalid because they dropped out of the map
function UpdateNodes(nodeCount, nodes)

    local model = import("/mods/battle-royale/modules/sim/model.lua")

    -- we adjust the count, leaving the nodes in-place
    local count = 0

    -- playable area
    local area = ScenarioInfo.MapData.PlayableRect

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
            
            local model = import("/mods/battle-royale/modules/sim/model.lua")

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
        local radius = 3 
        local l = k 
        if k > count then 
            radius = 6
            l = k - count + 0.5
        end

        -- compute spawn location
        local coords = ComputePoint( center, radius, l / count * twoPi + offset)

        -- compute heading
        local rad = math.atan2(cx - coords[1], cz - coords[3])
        local degrees = rad * (180 / math.pi)

        if node.InWater then
            radius = radius * 1.25
            rad = rad + 1.57
        end

        -- spawn unit
        table.insert(units, CreateUnitHPR(bp, "NEUTRAL_CIVILIAN", coords[1], coords[2], coords[3], 0, rad, 0 ))
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
    local model = import("/mods/battle-royale/modules/sim/model.lua")
    local k = math.floor(Random() * model.NodeCount) + 1
    return model.Nodes[k]
end

--- Retrieves random blueprints from the entries table.
function GetRandomBlueprints(entries, count)

    local rngs = { }
    for k = 1, count do 
        local bp = entries[math.floor(Random() * table.getn(entries)) + 1]
        table.insert(rngs, bp)
    end

    return rngs
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
        local config = import("/mods/battle-royale/modules/config.lua")
        if node.InWater then 
            entries = config.GetValidEntries(config.Navy, minutes)
        else 
            entries = config.GetValidEntries(config.Land, minutes)
        end

        -- see if there are any entries
        if table.getn(entries) > 0 then 
            -- choose a random entry
            local entry = entries[math.floor(Random() * table.getn(entries)) + 1]

            -- retrieve random blueprints from that entry
            local model = import("/mods/battle-royale/modules/sim/model.lua")
            local bps = GetRandomBlueprints(model.CarePackages[entry.Type], amount * entry.Count)

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

function DestroyStrandedUnits()

    local model = import("/mods/battle-royale/modules/sim/model.lua")

    local function InsideRectangle(rect, coords)
        local xBool = rect[1] < coords[1] and coords[1] < rect[3]
        local yBool = rect[2] < coords[3] and coords[3] < rect[4]
        return xBool and yBool
    end

    -- retrieve the brains
    local brains = ArmyBrains

    -- go over each undefeated brain
    for k, brain in brains do 
        if not brain:IsDefeated() then 
            local units = brain:GetListOfUnits(categories.ALLUNITS, false, false)

            -- go over each non-dead unit
            for k, unit in units do 
                if not unit.Dead then 

                    -- take 'em out if they're outside the playable area
                    local coords = unit:GetPosition()
                    if not InsideRectangle(model.PlayableArea, coords) then 
                        unit:Kill()
                    end
                end
            end
        end
    end
end

--- Shrink distance in percentage (%)
local ShrinkDistance = 0.05

--- Causes the map to shrink over time.
function Shrinking(type, rate, delay)
    ForkThread(ShrinkingThread, type, rate, delay)
end

--- Causes the map to shrink over time. Expects to run in its own thread.
function ShrinkingThread(type, rate, delay)

    -- needed for shrinking
    local ScenarioFramework = import("/lua/ScenarioFramework.lua")

    -- interpret lobby options
    local ShrinkInterval = rate 
    local ShrinkEvenly = true
    local ShrinkDelay = delay
    if type == "pseudorandom" then  
        ShrinkEvenly = false 
    end
    -- makes a side shrink less and less to even it out

    local ShrinkDecreaser = 0.92
    local ShrinkMultiplier = { 1.0, 1.0, 1.0, 1.0 }

    -- get map size
    local sx = ScenarioInfo.size[1]
    local sz = ScenarioInfo.size[2]

    -- ensures one side doesn't get shrinken twice in rapid succession
    local shrinkCount = 0
    local prng = import("/mods/battle-royale/modules/utils/PseudoRandom.lua").PseudoRandom:OnCreate({1, 2, 3, 4})
    
    -- delay before shrinking starts
    WaitSeconds(ShrinkDelay)

    while true do 

        local model = import("/mods/battle-royale/modules/sim/model.lua")

        if not ShrinkEvenly then 

            -- keep track to shuffle so that it isn't completely deterministic
            shrinkCount = shrinkCount + 1
            if shrinkCount > 3 then 
                prng:Shuffle()
            end

            -- determine direction to adjust
            local coord = prng:GetValue()

            -- determine axis we shrink on
            local size = sx
            if coord == 2 or coord == 4 then
                size = sz
            end

            -- determine direction we shrink on
            local direction = 1
            if coord > 2 then 
                direction = -1
            end

            -- do the shrinking for the preview
            model.AfterShrink[coord] = model.AfterShrink[coord] + direction * ShrinkMultiplier[coord] * ShrinkDistance * size
            ShrinkMultiplier[coord] = math.max(0.4, ShrinkDecreaser * ShrinkMultiplier[coord])
        else 

            -- prepare for preview
            for coord = 1, 4 do 

                -- determine axis we shrink on
                local size = sx
                if coord == 2 or coord == 4 then
                    size = sz
                end

                -- determine direction we shrink on
                local direction = 1
                if coord > 2 then 
                    direction = -1
                end

                -- do the shrinking for the preview
                model.AfterShrink[coord] = model.AfterShrink[coord] + 0.5 * direction * ShrinkMultiplier[coord] * ShrinkDistance * size
                ShrinkMultiplier[coord] = math.max(0.4, ShrinkDecreaser * ShrinkMultiplier[coord])
            end
        end

        -- tell the UI
        Sync.BattleRoyale = Sync.BattleRoyale or { }
        Sync.BattleRoyale.Shrink = { }
        Sync.BattleRoyale.Shrink.CurrentArea = model.PlayableArea
        Sync.BattleRoyale.Shrink.NextArea = model.AfterShrink
        Sync.BattleRoyale.Shrink.Interval = ShrinkInterval
        
        -- wait up
        WaitSeconds(ShrinkInterval)

        -- and shrink!
        model.PlayableArea = table.deepcopy(model.AfterShrink)
        ScenarioFramework.SetPlayableArea({ x0 = model.PlayableArea[1], y0 = model.PlayableArea[2], x1 = model.PlayableArea[3], y1 = model.PlayableArea[4] }, false)

        -- update!
        UpdateNodes()
        DestroyStrandedUnits()
    end
end

--- Visualizes the playable area after shrinking.
function VisualizeShrinking()
    ForkThread(VisualizeShrinkingThread)
end

--- Visualizes the playable area after shrinking. Expects to run in its own thread.
function VisualizeShrinkingThread()

    local GetTerrainHeight = GetTerrainHeight
    local color = "ff5555"

    local function DrawDetailedLine(p1, p2, color, n)
        local prev = {p1[1], GetTerrainHeight(p1[1], p1[2]), p1[2]}
        for k = 1, n do 
            local factor = (k / n)
            local next = { (1 - factor) * p1[1] + factor * p2[1], 0, (1 - factor) * p1[2] + factor * p2[2] }
            next[2] = GetTerrainHeight(next[1], next[3])
            DrawLine(prev, next, color)
            prev = next
        end
    end

    while true do 
        WaitSeconds(0.1)

        local model = import("/mods/battle-royale/modules/sim/model.lua")
        local afterShrink = model.AfterShrink

        local p1 = { afterShrink[1], afterShrink[2] }
        local p2 = { afterShrink[1], afterShrink[4] }
        local p3 = { afterShrink[3], afterShrink[2] }
        local p4 = { afterShrink[3], afterShrink[4] }

        local n = 64
        DrawDetailedLine(p1, p2, color, n)
        DrawDetailedLine(p1, p3, color, n)
        DrawDetailedLine(p4, p3, color, n)
        DrawDetailedLine(p4, p2, color, n)
    end
end