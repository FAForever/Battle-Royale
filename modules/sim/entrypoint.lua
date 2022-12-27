
function Entrypoint()

    local utils = import("/mods/Battle-Royale-by-Dark-Horse/modules/sim/utils.lua")
    local nodeController = import("/mods/Battle-Royale-by-Dark-Horse/modules/sim/node-controller.lua")
    local economicController = import("/mods/Battle-Royale-by-Dark-Horse/modules/sim/economic-controller.lua")
    local shrinkingController = import("/mods/Battle-Royale-by-Dark-Horse/modules/sim/shrinking-controller.lua")
    local options = import("/mods/Battle-Royale-by-Dark-Horse/lua/ai/lobbyoptions/lobbyoptions.lua").AIOpts

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
        nodeController.UpdateNodes()
        nodeController.CarePackages(ScenarioInfo.Options.CarePackagesRate, ScenarioInfo.Options.CarePackagesAmount, ScenarioInfo.Options.CarePackagesCurve)

    end

    -- initialize economic packages if applicable
    if ScenarioInfo.Options.EconomicPackagesRate > 0 then
        nodeController.UpdateNodes()
        economicController.EconomicCarePackages(ScenarioInfo.Options.EconomicPackagesRate, ScenarioInfo.Options.CarePackagesCurve)
    end

    -- initialize shrinking
    shrinkingController.Shrinking(ScenarioInfo.Options.ShrinkingType, ScenarioInfo.Options.ShrinkingRate, ScenarioInfo.Options.ShrinkingDelay, ScenarioInfo.Options.DestructionMode)
    shrinkingController.VisualizeShrinking(ScenarioInfo.Options.DestructionMode)

end