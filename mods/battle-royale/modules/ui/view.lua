
local conversion = import("/mods/dear-windowing/modules/conversion.lua")

local percentage = 0.9

function CreateInterface(window, isReplay)

    local model = import("/mods/battle-royale/modules/ui/model.lua")
    local time = GameTime()

    window:Begin()

    window:Space()

    window:BeginTabBar("main-tab-bar", { "Battle Royale", "Help" } )

    window:Space()

        if window:BeginTab("Battle Royale") then 

            if model.Config.CarePackages then 
                window:Text("Care packages")
                window:Divider()
                window:Space()

                local curr = time - model.CarePackage.Timestamp
                window:TextWithLabel("Time remaning until next package: ", tostring(math.floor( model.CarePackage.Interval - curr + 0.5) ), percentage)
                window:ProgressBar("care-package-progress", curr, model.CarePackage.Interval)
                window:Space()
            end

            window:Text("Shrinking")
            window:Divider()
            window:Space()

            local curr = time - model.Shrink.Timestamp
            window:TextWithLabel("Time remaning until next shrink: ", tostring(math.floor(model.Shrink.Interval - curr + 0.5) ), percentage)
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

        if window:BeginTab("Help") then 

            window:BeginList("help-list", 640)

            window:Space()

            window:Texture("care-package-01", "/mods/battle-royale/textures/care-package-02.png", 316)

            window:Text("Care packages spawn throughout the map. These contain")
            window:Text("units that you can capture, reclaim or destroy. The beacon")
            window:Text("is a quick-access to this functionality. Whatever happens")
            window:Text("to the beacon happens to the rest of the units.")
            window:Space()
            
            window:Texture("care-package-02", "/mods/battle-royale/textures/care-package-02.png", 316)
            
            window:Space()
            window:Text("As an example, If you capture the beacon the units that go")
            window:Text("with the beacon become your units. Radar and scouts are ")
            window:Text("useful to find the care packages. The last care package is  ")
            window:Text("shown as a teal box on the map preview.")
            window:Space()
            
            window:Texture("care-package-03", "/mods/battle-royale/textures/care-package-03.png", 316)
            
            window:Space()
            window:Text("Over time the map will shrink. The red line indicates")
            window:Text("where the map will be after the shrink. All units that ")
            window:Text("are on the outside are destroyed during the shrink.")
            window:Space()
            
            window:Texture("shrink-01", "/mods/battle-royale/textures/shrink-01.png", 316)

            window:Space()

            window:EndList("help-list")

        end 

    window:EndTabBar("main-tab-bar")

    window:End()
end
