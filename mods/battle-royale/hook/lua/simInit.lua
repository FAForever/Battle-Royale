
local BattleRoyaleBeginSession = BeginSession
function BeginSession()

    -- dun break anything!
    BattleRoyaleBeginSession();

    -- similar to hook/lua/ui/game/gamemain.CreateUI.lua
	-- initialize our own sim elements

    ForkThread(
		function()
			import('/mods/battle-royale/modules/sim/entrypoint.lua').Entrypoint()
		end
	);

end