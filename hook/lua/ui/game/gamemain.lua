
local BattleRoyaleCreateUI = CreateUI;
function CreateUI(isReplay) 

	BattleRoyaleCreateUI(isReplay) 

	-- similar to hook/lua/siminit.lua
	-- initialize our own ui elements

	ForkThread(
		function()
			import('/mods/Battle-Royale-by-Dark-Horse/modules/ui/entrypoint.lua').Entrypoint(isReplay)
		end
	);

end