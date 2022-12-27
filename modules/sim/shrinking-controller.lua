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

--- Function that starts a thread that fills the non-playable area with X symbols
function FillUnplayableArea(squareEdgeSize)
    ForkThread(FillUnplayableAreaThread, squareEdgeSize)
end

--- Fills the unplayable area with X symbols.
--- The size of the X symbol depends on xLineSize, and the distance between the X symbols depends on squareEdgeSize
function FillUnplayableAreaThread(squareEdgeSize)

    local model = import("/mods/Battle-Royale-by-Dark-Horse/modules/sim/model.lua")
    local GetTerrainHeight = GetTerrainHeight

    local currentArea = table.deepcopy(model.PlayableArea) -- needed to track if model.PlayableArea has changed
    local sx0, sy0, sx1, sy1 = unpack(ScenarioInfo.MapData.PlayableRect)
    local msnps = math.floor((sx1 - sx0) / squareEdgeSize) -- maximum squares number per side.


    local function Equals(area1, area2)
        return area1[1] == area2[1]
                and area1[2] == area2[2]
                and area1[3] == area2[3]
                and area1[4] == area2[4]
    end

    --- Finds the points that are the center of the X symbol.
    local function FindPoints(playableArea)

        local points = {}
        local x = sx0
        local y = sy0
        local edgeSize = sx1 / msnps

        --- Checks if any part of the X character is in the area.
        local function InsideArea(area, x, y, size)

            local function InsideRectangle(rectangle, x, y)
                local xBool = rectangle[1] < x and x < rectangle[3]
                local yBool = rectangle[2] < y and y < rectangle[4]
                return xBool and yBool
            end

            local topLeft = InsideRectangle(area, x - size, y - size)
            local topRight = InsideRectangle(area, x + size, y - size)

            local bottomRight = InsideRectangle(area, x + size, y + size)
            local bottomLeft = InsideRectangle(area, x - size, y + size)

            return topLeft or topRight or bottomRight or bottomLeft
        end

        for k = 0, msnps - 1 do

            if x < sx1 then
                x = edgeSize / 2 + edgeSize * k
            else
                x = edgeSize / 2
            end

            for l = 0, msnps - 1 do
                if y < sy1 then
                    y = edgeSize / 2 + edgeSize * l
                else
                    y = edgeSize / 2
                end

                local notInPlayable = not InsideArea(playableArea, x, y, edgeSize / 2)

                if notInPlayable then
                    table.insert(points, { x = x, y = y })
                end
            end

        end

        return points
    end

    local function DrawX(point, size)
        local color = "ff5555" --red

        local topLeft = { point.x - size, GetTerrainHeight(point.x - size, point.y - size), point.y - size }
        local bottomRight = { point.x + size, GetTerrainHeight(point.x - size, point.y + size), point.y + size }

        local topRight = { point.x + size, GetTerrainHeight(point.x + size, point.y - size), point.y - size }
        local bottomLeft = { point.x - size, GetTerrainHeight(point.x - size, point.y + size), point.y + size }

        DrawLine(topLeft, bottomRight, color)
        DrawLine(topRight, bottomLeft, color)
    end

    local points = {}
    local xLineSize = math.floor(squareEdgeSize / 8)

    while true do
        WaitSeconds(0.1)
        local model = import("/mods/Battle-Royale-by-Dark-Horse/modules/sim/model.lua")

        if not Equals(currentArea, model.PlayableArea) then
            currentArea = table.deepcopy(model.PlayableArea)
            points = FindPoints(model.PlayableArea)
        end

        for _, point in points do
            DrawX(point, xLineSize)
        end
    end
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
    local model = import("/mods/Battle-Royale-by-Dark-Horse/modules/sim/model.lua")
    local nodeController = import("/mods/Battle-Royale-by-Dark-Horse/modules/sim/node-controller.lua")
    local economicController = import("/mods/Battle-Royale-by-Dark-Horse/modules/sim/economic-controller.lua")
    local unitController = import("/mods/Battle-Royale-by-Dark-Horse/modules/sim/unit-controller.lua")

    local prng = import("/mods/Battle-Royale-by-Dark-Horse/modules/utils/PseudoRandom.lua").PseudoRandom:OnCreate({ 1, 2, 3, 4 })

    local sx0, sy0, sx1, sy1 = unpack(ScenarioInfo.MapData.PlayableRect)
    local isShrinkDone = false


    -- tell UI about the delay before shrinking
    SyncToUI(true, model.PlayableArea, model.PlayableArea, delay)

    -- delay before shrinking starts
    WaitSeconds(delay)

    -- if non-instant destruction of a unit outside the playable area is selected, it will start a separate thread of gradual destruction.
    if not (destructionTime == 0) then
        local squareEdgeSize = math.floor((sx1 - sx0) / 40)
        unitController.DamageOrDestroyStrandedUnits(destructionTime)

        FillUnplayableArea(squareEdgeSize)
    end

    local function CheckCanPlayableAreaShrink(model)
        local minX = ((sx1 - sx0) / 100) * 15
        local minY = ((sy1 - sy0) / 100) * 15

        local px0, py0, px1, py1 = unpack(model.AfterShrink)

        local xBool = px1 - px0 > minX
        local yBool = py1 - py0 > minY

        return xBool and yBool
    end

    while not isShrinkDone do

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
        SyncToUI(false, model.PlayableArea, model.PlayableArea, rate)

        -- wait up
        WaitSeconds(rate)

        -- and shrink if it possible!
        if CheckCanPlayableAreaShrink(model) then
            model.PlayableArea = table.deepcopy(model.AfterShrink)
        else
            model.AfterShrink = table.deepcopy(model.PlayableArea)
            isShrinkDone = true
        end

        -- reducing the playing area is only needed for the instant destruction mode.
        if destructionTime == 0 then
            ScenarioFramework.SetPlayableArea({ x0 = model.PlayableArea[1], y0 = model.PlayableArea[2], x1 = model.PlayableArea[3], y1 = model.PlayableArea[4] }, false)
            unitController.DestroyStrandedUnits()
        end
        nodeController.UpdateNodes()
        economicController.UpdateNodes()
    end
end

--- Visualizes the playable area after shrinking.
function VisualizeShrinking(destructionMode)
    ForkThread(VisualizeShrinkingThread, destructionMode)
end

--- Visualizes the playable area after shrinking. Expects to run in its own thread.
function VisualizeShrinkingThread(destructionMode)

    local nextAreaColor = "ff9900" --orange
    local currentAreaColor = "55ff55" --green

    -- upvalue for performance
    local GetTerrainHeight = GetTerrainHeight

    local function DrawDetailedLine(p1, p2, color, n)
        local prev = { p1[1], GetTerrainHeight(p1[1], p1[2]), p1[2] }
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

        local model = import("/mods/Battle-Royale-by-Dark-Horse/modules/sim/model.lua")

        DrawArea(model.AfterShrink, nextAreaColor)

        if not (destructionMode == 0) then
            DrawArea(model.PlayableArea, currentAreaColor)
        end
    end
end
