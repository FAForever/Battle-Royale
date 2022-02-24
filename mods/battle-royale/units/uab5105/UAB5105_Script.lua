#****************************************************************************
#**
#**  File     :  /cdimage/units/UAB5103/UAB5103_script.lua
#**  Author(s):  John Comes, David Tomandl
#**
#**  Summary  :  Aeon Quantum Gate Beacon Unit
#**
#**  Copyright � 2005 Gas Powered Games, Inc.  All rights reserved.
#****************************************************************************

local AStructureUnit = import('/lua/aeonunits.lua').AStructureUnit

UAB5105 = Class(AStructureUnit) {
	FxTransportBeacon = {'/effects/emitters/red_beacon_light_01_emit.bp'},
	FxTransportBeaconScale =1,
	
	OnCreate = function(self)
		AStructureUnit.OnCreate(self)
        
        -- create beacon effect
        for k = 0, self:GetBoneCount() do 
            local name = self:GetBoneName(k)
            if string.find(name, "light") then 
                self.Trash:Add(CreateAttachedEmitter(self, k, self:GetArmy(), "/mods/battle-royale/effects/beacon_light.bp"))
            end
        end

        -- rotate a bit
        local r = CreateRotator(self, 'UAB5105', 'y')
        self.Trash:Add(self.r)
        r:SetSpinDown(false)
        r:SetTargetSpeed(30)
        r:SetAccel(20)
	end,
}

TypeClass = UAB5105