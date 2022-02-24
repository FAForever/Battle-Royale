
local CStructureUnit = import('/lua/seraphimunits.lua').SStructureUnit

XSB5305 = Class(CStructureUnit) {
	FxTransportBeacon = {'/effects/emitters/red_beacon_light_01_emit.bp'},
	FxTransportBeaconScale =1,

	OnCreate = function(self)
		CStructureUnit.OnCreate(self)

		local hoverfx = CreateAttachedEmitter(self, -1, self:GetArmy(), "/mods/battle-royale/effects/seraphim_beacon_hover.bp")
		hoverfx:OffsetEmitter(0, 0.7, 0)
		self.Trash:Add(hoverfx)

		local distortfx = CreateAttachedEmitter(self, -1, self:GetArmy(), "/mods/battle-royale/effects/seraphim_beacon_distortion_03.bp")
		distortfx:OffsetEmitter(0, 0.7, 0)
		self.Trash:Add(distortfx)

        -- rotate a bit
        local r = CreateRotator(self, 'ball1', 'y')
        self.Trash:Add(self.r)
        r:SetSpinDown(false)
        r:SetTargetSpeed(90)
        r:SetAccel(20)

        local r = CreateRotator(self, 'ball2', 'y')
        self.Trash:Add(self.r)
        r:SetSpinDown(false)
        r:SetTargetSpeed(-60)
        r:SetAccel(20)

        local r = CreateRotator(self, 'ball3', 'y')
        self.Trash:Add(self.r)
        r:SetSpinDown(false)
        r:SetTargetSpeed(30)
        r:SetAccel(20)

	end,
}

TypeClass = XSB5305