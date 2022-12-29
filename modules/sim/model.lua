
-- Initialize the units that can reside in care packages.
CarePackages = import("/mods/Battle-Royale-by-Dark-Horse/modules/packer/units.lua").FindAllUnits()

--- The number of nodes that can be used to drop care packages on.
NodeCount = 0

--- The nodes where you can drop care packages.
Nodes = { }

--- Determines spawn points for 'care packages' that can contain new units.
local function CreateNodes()

    -- make option?
    local density = 40

    -- initialize return state
    local nodeCount = 0
    local nodes = { }

    -- localize so that they are faster
    local GetTerrainHeight = GetTerrainHeight
    local GetSurfaceHeight = GetSurfaceHeight
    local Vector = Vector

    local brain = ArmyBrains[1]

    local function CreateNode(coords, inWater)
        return {
            Coordinates = coords,
            InWater = inWater
        }
    end

    -- determine map size
    local mx = ScenarioInfo.size[1]
    local mz = ScenarioInfo.size[2]

    -- number of nodes per axis, e.g. the map will have 1600 nodes to choose from
    local fx = mx / density
    local fz = mz / density

    -- loop over y-axis
    for z = 1, density do 

        -- compute map-coordinate
        cz = fz * (z - 0.5) 

        -- loop over x-axis
        for x = 1, density do   

            -- compute map-coordiate
            cx = fx * (x - 0.5)

            -- compute coords
            local coords = {cx, GetTerrainHeight(cx,cz), cz }

            -- find nearest place where we can build a land factory
            local buildingBP = "ueb0304"

            -- check if this is a water node
            local inWater = GetSurfaceHeight(cx, cz) > GetTerrainHeight(cx, cz)

            -- if it is, adjust for a naval factory instead of a land factory
            if inWater then 
                buildingBP = "uab0103"
            end

            -- determine closest building location and consider that to be a point where we can fire things at
            -- function CAiBrain:FindPlaceToBuild(buildingType, whatToBuild, baseTemplate, relative, closeToBuilder, optIgnoreAlliance, BuildLocationX, BuildLocationZ, optIgnoreThreatUnder)
            local valid = brain:CanBuildStructureAt(buildingBP, coords)

            if valid then 
                -- construct the a node
                nodeCount= nodeCount + 1
                nodes[nodeCount] = CreateNode(coords, inWater)
            end
        end
    end

    -- update the model
    NodeCount = nodeCount
    Nodes = nodes
end

CreateNodes()

-- this is the current playable area
PlayableArea = ScenarioInfo.MapData.PlayableRect

-- the version that is slightly shrinken
AfterShrink = table.deepcopy(PlayableArea)