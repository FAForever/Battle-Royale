
local conversion = import("/mods/dear-windowing/modules/conversion.lua")

local percentage = 0.9

---Displays text in a window object. The text is split into substrings.
---The length of substrings depends on param stringLenght.
---The substring is trimmed at the last space in it to preserve the integrity of the word.
--- @param window - window object in which you want to display the text.
--- @param text - the text to be displayed.
--- @param stringLength - the maximum length of the line into which the text will be divided.
function showText(window, text, stringLength)
    local startedIndex = 1

    if text:len() < stringLength then
        window:Text(text)
        return
    end

    local function getLastSpaceIndex(someString)
        return someString:len() - string.find(StringReverse(someString), " ") + 1
    end

    while startedIndex < text:len() do
        local subString = text:sub(startedIndex, startedIndex + stringLength)

        if subString:len() < stringLength then
            window:Text(subString)
            startedIndex = startedIndex + stringLength
        else
            subString = subString:sub(1, getLastSpaceIndex(subString))
            window:Text(subString)
            startedIndex = startedIndex + getLastSpaceIndex(subString)
        end
    end
end

function CreateInterface(window, isReplay)

    local model = import("/mods/battle-royale/modules/ui/model.lua")
    local time = GameTime()
    local battleRoyale = LOC("<LOC br_ui_battle_royale>Battle Royale")
    local help = LOC("<LOC br_ui_help>Help")

    local helpText1 = LOC("<LOC br_ui_help_text_1>Care packages spawn throughout the map. These contain units that you can capture, reclaim or destroy. The beacon is a quick-access to this functionality. Whatever happens to the beacon happens to the rest of the units.")
    local helpText2 = LOC("<LOC br_ui_help_text_2>As an example, If you capture the beacon the units that go with the beacon become your units. Radar and scouts are useful to find the care packages. The last care package is  shown as a teal box on the map preview.")
    local helpText3 = LOC("<LOC br_ui_help_text_3>Over time the map will shrink. The red line indicates where the map will be after the shrink. All units that are on the outside are destroyed during the shrink.")

    window:Begin()

    window:Space()

    window:BeginTabBar("main-tab-bar", { battleRoyale, help } )

    window:Space()

        if window:BeginTab(battleRoyale) then

            if model.Config.CarePackages then 
                window:Text(LOC("<LOC br_ui_care_packages>Care packages"))
                window:Divider()
                window:Space()

                local curr = time - model.CarePackage.Timestamp
                window:TextWithLabel(LOC("<LOC br_ui_care_packages_time>Time remaning until next package: "), tostring(math.floor( model.CarePackage.Interval - curr + 0.5) ), percentage)
                window:ProgressBar("care-package-progress", curr, model.CarePackage.Interval)
                window:Space()
            end

            window:Text(LOC("<LOC br_ui_shrinking>Shrinking"))
            window:Divider()
            window:Space()

            local curr = time - model.Shrink.Timestamp
            if model.Shrink.Delayed then 
                window:TextWithLabel(LOC("<LOC br_ui_shrinking_start>Time remaning until shrinking starts: "), tostring(math.floor(model.Shrink.Interval - curr + 0.5) ), percentage)
            else 
                window:TextWithLabel(LOC("<LOC br_ui_shrinking_next>Time remaning until next shrink: "), tostring(math.floor(model.Shrink.Interval - curr + 0.5) ), percentage)
            end

            window:ProgressBar("shrink-progress", curr, model.Shrink.Interval)

            window:Space()

            -- construct shapes of next off areas
            local shapes = { }
            if model.Shrink.NextOffAreas then 
                for k, area in model.Shrink.NextOffAreas do 
                    table.insert(shapes, { X = area.x0, Y = area.y0, Width = area.x1 - area.x0, Height = area.y1 - area.y0, Solid = true, Color = "44aa0000" })
                end
            end

            -- construct shapes of actual off areas
            if model.Shrink.OffAreas then 
                for k, area in model.Shrink.OffAreas do 
                    table.insert(shapes, { X = area.x0, Y = area.y0, Width = area.x1 - area.x0, Height = area.y1 - area.y0, Solid = true, Color = "44000000" })
                end
            end

            -- construct shape for care package
            if model.Config.CarePackages then 
                if model.CarePackage.Coordinates then 
                    local coords = model.CarePackage.Coordinates
                    table.insert(shapes, { X = (coords[1] / model.Config.Size[1]) - 0.02, Y = (coords[3] / model.Config.Size[2]) - 0.02, Width = 0.04, Height = 0.04, Solid = false, Color = "9900ffff"})
                end
            end

            window:MapPreview("map", model.Config.Map, shapes)
        end

        if window:BeginTab(help) then

            window:BeginList("help-list", 640)

            window:Space()

            window:Texture("care-package-01", "/mods/battle-royale/textures/care-package-02.png", 316)

            showText(window, helpText1, 55)
            window:Space()
            
            window:Texture("care-package-02", "/mods/battle-royale/textures/care-package-02.png", 316)
            
            window:Space()
            showText(window, helpText2, 55)
            window:Space()
            
            window:Texture("care-package-03", "/mods/battle-royale/textures/care-package-03.png", 316)
            
            window:Space()
            showText(window, helpText3, 55)
            window:Space()
            
            window:Texture("shrink-01", "/mods/battle-royale/textures/shrink-01.png", 316)

            window:Space()

            window:EndList("help-list")

        end 

    window:EndTabBar("main-tab-bar")

    window:End()
end