
--- Retrieves all units through the help of the scripts of packer.
function FindAllUnits ()

    local mods = {
        nomads = { path = "/mods/battle-royale/modules/packer/units-nomads.lua" },
        blackops = { path = "/mods/battle-royale/modules/packer/units-blackops.lua" },
        brewlan = { path = "/mods/battle-royale/modules/packer/units-brewlan.lua" },
        extremewars = { path = "/mods/battle-royale/modules/packer/units-extremewars.lua" },
        marlo = { path = "/mods/battle-royale/modules/packer/units-marlo.lua" },
        supremeunits = { path = "/mods/battle-royale/modules/packer/units-supremeunits.lua" },
        totalmayhem = { path = "/mods/battle-royale/modules/packer/units-totalmayhem.lua" }
    }

    -- separate check for nomads
    if(__blueprints['xnl0001']) then
		mods.nomads = true;
	end

	-- check all normal mods
	for index, mod in __active_mods do
		if(mod.name == "BrewLAN") then
			mods.brewlan.enabled = true;
        elseif(mod.name == "Total Mayhem") then
			mods.totalmayhem.enabled = true;
		elseif(mod.name == "BlackOps FAF: Unleashed") then
			mods.blackops.enabled = true;
		elseif(mod.name == "Marlo's mod Compilation") then
			mods.marlo.enabled = true;
		elseif(mod.name == "SupremeUnitPackV6Official") then
			mods.supremeunits.enabled = true;
		elseif(mod.name == "Extreme Wars") then
			mods.extremewars.enabled = true;
		elseif(mod.name == "Extreme Wars.") then	-- broken vault version
			PrintText("WRONG VERSION OF EXTREME WARS", 35, 'ffff0000', 6, 'center')	
		end
	end

    -- start with base game units
    local base = import("/mods/battle-royale/modules/packer/units-base.lua").UnitTable

    -- move over all the enabled mods
    for k, mod in mods do 
        if mod.enabled then 

            -- get the unit table
            local other = import(mod.path).UnitTable 

            -- concatenate them
            for k, tech in base do -- e.g. "Land T1"
                for i, type in tech do -- e.g. "1 Scout"
                    table.destructiveCat(base[k][i], other[k][i])
                end
            end
        end
    end

    -- combine all categories of each type
    for k, type in base do 
        base[k] = table.concatenate(unpack(type))
    end

    -- return the (combined) unit tables
    return base
end