
function Entrypoint()

    local utils = import("/mods/battle-royale/modules/sim/utils.lua")
    local controller = import("/mods/battle-royale/modules/sim/controller.lua")
    local options = import("/mods/battle-royale/lua/ai/lobbyoptions/lobbyoptions.lua").AIOpts

    -- initialize area rect to entire map if applicable
    ScenarioInfo.MapData.PlayableRect = ScenarioInfo.MapData.PlayableRect or {0, 0, ScenarioInfo.size[1], ScenarioInfo.size[2]}

    -- make sure the options exists
    for k, option in options do 
        if not ScenarioInfo.Options[option.key] then 
            ScenarioInfo.Options[option.key] = option.values[option.default].key
        end
    end

    -- send configuration data
    Sync.BattleRoyale = Sync.BattleRoyale or { }
    Sync.BattleRoyale.Config = { }
    Sync.BattleRoyale.Config.Map = ScenarioInfo.map
    Sync.BattleRoyale.Config.MapArea = ScenarioInfo.MapData.PlayableRect
    Sync.BattleRoyale.Config.Size = ScenarioInfo.size
    Sync.BattleRoyale.Config.CarePackages = ScenarioInfo.Options.CarePackagesRate > 0

    -- initialize care packages if applicable
    if ScenarioInfo.Options.CarePackagesRate > 0 then 
        controller.UpdateNodes()
        controller.CarePackages(ScenarioInfo.Options.CarePackagesRate)
    end

    -- tell people about the UI mod
    utils.SendAnnouncement("Battle Royale", "Requires the Dear Windowing UI mod enabled", 10)

    -- initialize shrinking
    controller.Shrinking(ScenarioInfo.Options.ShrinkingType, ScenarioInfo.Options.ShrinkingRate)
    controller.VisualizeShrinking()

end