#****************************************************************************
#**
#**  File     :  /cdimage/units/COB5105/COB5105_script.lua
#**  Author(s):  John Comes, David Tomandl
#**
#**  Summary  :  UEF Quantum Gate Beacon Unit
#**
#**  Copyright © 2005 Gas Powered Games, Inc.  All rights reserved.
#****************************************************************************

local TStructureUnit = import('/lua/terranunits.lua').TStructureUnit

COB5205 = Class(TStructureUnit) {
	FxTransportBeacon = {'/effects/emitters/red_beacon_light_01_emit.bp'},
	FxTransportBeaconScale =1,

	OnCreate = function(self)
		TStructureUnit.OnCreate(self)
		
		 -- rotate a bit
        local r = CreateRotator(self, 'ball1', 'y')
        self.Trash:Add(self.r)
        r:SetSpinDown(false)
        r:SetTargetSpeed(80)
        r:SetAccel(20)

        local r = CreateRotator(self, 'ball2', 'y')
        self.Trash:Add(self.r)
        r:SetSpinDown(false)
        r:SetTargetSpeed(-60)
        r:SetAccel(20)

	end,
}

TypeClass = COB5205