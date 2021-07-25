
local BattleRoyaleOnSync = OnSync

function OnSync()

    -- don't break anything!
    BattleRoyaleOnSync()

    -- send to controller
    if Sync.BattleRoyale and Sync.BattleRoyale.Config then 
        local controller = import("/mods/battle-royale/modules/ui/controller.lua")
        controller.StoreOptions(Sync.BattleRoyale.Config)
    end

    -- send to controller
    if Sync.BattleRoyale and Sync.BattleRoyale.CarePackage then 
        local controller = import("/mods/battle-royale/modules/ui/controller.lua")
        controller.StoreShrinkInformation(Sync.BattleRoyale.CarePackage)
    end

    -- send to controller
    if Sync.BattleRoyale and Sync.BattleRoyale.Shrink then 
        local controller = import("/mods/battle-royale/modules/ui/controller.lua")
        controller.StoreCarePackageInformation(Sync.BattleRoyale.Shrink)
    end

    -- send an announcement
    if Sync.SendAnnouncement then
        local controller = import("/mods/battle-royale/modules/ui/controller.lua")
        controller.ProcessAnnouncement(Sync.SendAnnouncement)
    end


end 