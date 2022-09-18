


--- Stores the config received from the sync in the model.
function StoreOptions(config)
    local model = import("/mods/battle-royale/modules/ui/model.lua")
    model.Config = table.deepcopy(config)
end

--- Stores the information surrounding the next shrink from the sync in the model.
function StoreCarePackageInformation(information)
    local model = import("/mods/battle-royale/modules/ui/model.lua")
    model.CarePackage = table.deepcopy(information)
    model.CarePackage.Timestamp = GameTime()
end

--- Stores information about the commander's beacon  from the sync in the model.
function StoreBeaconInformation(information)
    local model = import("/mods/battle-royale/modules/ui/model.lua")
    model.Beacon = table.deepcopy(information)
    model.Beacon.Timestamp = GameTime()
end

--- Computes the areas that are between the inner and outer rectangle.
local function OffMapAreas(inner, outer, size)

    local x0 = inner[1] / size[1]
    local y0 = inner[2] / size[2]
    local x1 = inner[3] / size[1]
    local y1 = inner[4] / size[2]

    local ox0 = outer[1] / size[1]
    local oy0 = outer[2] / size[2]
    local ox1 = outer[3] / size[1]
    local oy1 = outer[4] / size[2]

    -- This is a rectangle above the playable area that is longer, left to right, than the playable area
    local OffMapArea1 = {}
    OffMapArea1.x0 = ox0
    OffMapArea1.y0 = oy0
    OffMapArea1.x1 = x1
    OffMapArea1.y1 = y0

    -- This is a rectangle below the playable area that is longer, left to right, than the playable area
    local OffMapArea2 = {}
    OffMapArea2.x0 = x1
    OffMapArea2.y0 = oy0
    OffMapArea2.x1 = ox1
    OffMapArea2.y1 = y1

    -- This is a rectangle to the left of the playable area, that is the same height (up to down) as the playable area
    local OffMapArea3 = {}
    OffMapArea3.x0 = x0
    OffMapArea3.y0 = y1
    OffMapArea3.x1 = ox1
    OffMapArea3.y1 = oy1

    -- This is a rectangle to the right of the playable area, that is the same height (up to down) as the playable area
    local OffMapArea4 = {}
    OffMapArea4.x0 = ox0
    OffMapArea4.y0 = y0
    OffMapArea4.x1 = x0
    OffMapArea4.y1 = oy1

    return { OffMapArea1, OffMapArea2, OffMapArea3, OffMapArea4 }

end

--- Stores the information surrounding the current care package from the sync in the model.
function StoreShrinkInformation(information)
    local model = import("/mods/battle-royale/modules/ui/model.lua")
    model.Shrink = table.deepcopy(information)
    model.Shrink.Timestamp = GameTime()
    model.Shrink.OffAreas = OffMapAreas(model.Shrink.CurrentArea, model.Config.MapArea, model.Config.Size)
    model.Shrink.NextOffAreas = OffMapAreas(model.Shrink.NextArea, model.Shrink.CurrentArea, model.Config.Size)
end

-- {
--     title = string,
--     subTitle = string
--     sound = {
--        cue = string,
--        bank = string,
--    }
-- }
function ProcessAnnouncement(data)

    -- create an actual announcement
    local Announcement = import('/lua/ui/game/announcement.lua');
    Announcement.CreateAnnouncement(data.title, GetFrame(0), data.subTitle)

    -- if there is sound, add it 
    if data.sound then 
        ForkThread(
            function()
                WaitSeconds(1.0)
                local sound = Sound({Cue = data.sound.cue, Bank = data.sound.bank})
                PlaySound(sound)
            end
        )
    end
end