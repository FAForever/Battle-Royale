--- side / coordination matrix
-- left = { coord = 1 , direction = 1}
-- top = { coord = 2 , direction = 1}
-- right = { coord = 3 , direction = -1}
-- bottom = { coord = 4 , direction = -1}

--- Shrink distance in percentage (%)
local ShrinkDistance = 0.05

--- Makes a side shrink less and less to even it out
local ShrinkDecreaser = 0.92
local ShrinkMultiplier = { 1.0, 1.0, 1.0, 1.0 }

--- Last shrinking side, used in shrink in circle
local LastSide = 0

local import = import

--- Returns the direction to shrink number (1 or -1) depending on what side we're shrinking
--- @param sideNumber - side number, must be from 1 to 4
function getDirectionBySideNumber (sideNumber)
    return sideNumber > 2 and -1 or 1
end


--- Returns the map size depending on what side we're shrinking
--- @param sideNumber - side number, must be from 1 to 4
function getSizeBySideNumber (sideNumber)
    local size = ScenarioInfo.size[1]
    if sideNumber == 2 or sideNumber == 4 then
        size = ScenarioInfo.size[2]
    end
    return size
end


--- At first calling returns random side number.
--- Depending on direction of shrinking (clockwise or counterclockwise) returns
--- next shrinking side.
--- @param clockwise - true if clockwise, false if counterclockwise
function getSideForShrinking (clockwise)
    if LastSide == 0 then
        LastSide = math.random(4)
    end

    if clockwise then
        LastSide = LastSide == 4 and 1 or LastSide + 1
    else
        LastSide = LastSide == 1 and 4 or LastSide - 1
    end
    return LastSide
end

--- The playable area is shrink in a circle clockwise or counterclockwise.
--- The shrinking start side is determined randomly.
--- @param clockwise - true if clockwise, false if counterclockwise
--- @param model - table for record new playable area after shrinking
function ShrinkInCircle(clockwise, model)
    local coord = getSideForShrinking(clockwise)
    local direction = getDirectionBySideNumber(coord)
    local size = getSizeBySideNumber(coord)
    model.AfterShrink[coord] = model.AfterShrink[coord] + direction * ShrinkMultiplier[coord] * ShrinkDistance * size
    ShrinkMultiplier[coord] = math.max(0.4, ShrinkDecreaser * ShrinkMultiplier[coord])
end

--- The playing area shrinking is random.
--- Shrinking twice on one side is excluded.
--- @param prng - util generating random shrinking side
--- @param model - table for record new playable area after shrinking
function ShrinkRandomly(prng, model)
    -- getting random shrinking side
    local coord = prng:GetValue()
    local direction = getDirectionBySideNumber(coord)
    local size = getSizeBySideNumber(coord)
    model.AfterShrink[coord] = model.AfterShrink[coord] + direction * ShrinkMultiplier[coord] * ShrinkDistance * size
    ShrinkMultiplier[coord] = math.max(0.4, ShrinkDecreaser * ShrinkMultiplier[coord])
end

--- Each side is chosen for shrinking, sides shrink slightly slower to compensate.
--- @param model - table for record new playable area after shrinking
function ShrinkEvenly(model)
    for coord = 1, 4 do
        local direction = getDirectionBySideNumber(coord)
        local size = getSizeBySideNumber(coord)
        model.AfterShrink[coord] = model.AfterShrink[coord] + 0.5 * direction * ShrinkMultiplier[coord] * ShrinkDistance * size
        ShrinkMultiplier[coord] = math.max(0.4, ShrinkDecreaser * ShrinkMultiplier[coord])
    end
end

--- Informs the UI about the state of the shrinking.
--- @param isDelayed - is there delay before shrinking
--- @param currentArea - current playable area
--- @param nextArea - playable area after shrinking
--- @param interval - period between shrinking or delay before shrinking starts
function SyncToUI(isDelayed, currentArea, nextArea, interval)
    Sync.BattleRoyale = Sync.BattleRoyale or { }
    Sync.BattleRoyale.Shrink = { }
    Sync.BattleRoyale.Shrink.Delayed = isDelayed
    Sync.BattleRoyale.Shrink.CurrentArea = currentArea
    Sync.BattleRoyale.Shrink.NextArea = nextArea
    Sync.BattleRoyale.Shrink.Interval = interval
end

--- Causes the map or save area to shrink over time.
--- @param type - shrinking type
--- @param rate - period between shrinking
--- @param delay - delay before shrinking
--- @param destructionTime - method of destroying units, instantaneous(0) or over time(<0)
function Shrinking(type, rate, delay, destructionTime)
    ForkThread(ShrinkingThread, type, rate, delay, destructionTime)
end

--- Causes the map or save area to shrink over time. Expects to run in its own thread.
--- @param type - shrinking type
--- @param rate - period between shrinking
--- @param delay - delay before shrinking
---@param destructionTime - method of destroying units, instantaneous(0) or over time(<0)
function ShrinkingThread(type, rate, delay, destructionTime)

    -- needed for shrinking
    local ScenarioFramework = import("/lua/ScenarioFramework.lua")
    local model = import("/mods/battle-royale/modules/sim/model.lua")
    local nodeController = import("/mods/battle-royale/modules/sim/node-controller.lua")
    local unitController = import("/mods/battle-royale/modules/sim/unit-controller.lua")

    local prng = import("/mods/battle-royale/modules/utils/PseudoRandom.lua").PseudoRandom:OnCreate({1, 2, 3, 4})

    -- tell UI about the delay before shrinking
    SyncToUI( true, model.PlayableArea, model.PlayableArea, delay)

    -- delay before shrinking starts
    WaitSeconds(delay)

    -- if non-instant destruction of a unit outside the playable area is selected, it will start a separate thread of gradual destruction.
    if  not (destructionTime == 0) then
        unitController.DamageOrDestroyStrandedUnits(destructionTime)
    end

    while true do

        if type == "pseudorandom" then
            ShrinkRandomly(prng, model)
        end

        if type == "evenly" then
            ShrinkEvenly(model)
        end

        if type == "clockwise" then
            ShrinkInCircle(true, model)
        end

        if type == "counterclockwise" then
            ShrinkInCircle(false, model)
        end

        -- tell  UI of the next playable area.
        SyncToUI( false, model.PlayableArea, model.PlayableArea, rate)

        -- wait up
        WaitSeconds(rate)

        -- and shrink!
        model.PlayableArea = table.deepcopy(model.AfterShrink)

        -- reducing the playing area is only needed for the instant destruction mode.
        if destructionTime == 0 then
            ScenarioFramework.SetPlayableArea({ x0 = model.PlayableArea[1], y0 = model.PlayableArea[2], x1 = model.PlayableArea[3], y1 = model.PlayableArea[4] }, false)
            unitController.DestroyStrandedUnits()
        end

        nodeController.UpdateNodes()
    end
end

--- Visualizes the playable area after shrinking.
function VisualizeShrinking(destructionMode)
    ForkThread(VisualizeShrinkingThread, destructionMode)
end

--- Visualizes the playable area after shrinking. Expects to run in its own thread.
function VisualizeShrinkingThread(destructionMode)

    local nextAreaColor = "ff5555" --red
    local currentAreaColor = "55ff55" --green

    -- upvalue for performance
    local GetTerrainHeight = GetTerrainHeight

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

    local function DrawArea(area, color)
        local p1 = { area[1], area[2] }
        local p2 = { area[1], area[4] }
        local p3 = { area[3], area[2] }
        local p4 = { area[3], area[4] }

        local n = 64
        DrawDetailedLine(p1, p2, color, n)
        DrawDetailedLine(p1, p3, color, n)
        DrawDetailedLine(p4, p3, color, n)
        DrawDetailedLine(p4, p2, color, n)
    end

    while true do
        WaitSeconds(0.1)

        local model = import("/mods/battle-royale/modules/sim/model.lua")

        DrawArea(model.AfterShrink, nextAreaColor)

        if not (destructionMode == 0) then
            DrawArea(model.PlayableArea, currentAreaColor)
        end
    end
end
