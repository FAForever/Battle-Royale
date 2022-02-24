

local Entity = import('/lua/sim/entity.lua').Entity
local CStructureUnit = import('/lua/seraphimunits.lua').SStructureUnit

XSB5305 = Class(CStructureUnit) {
	OnCreate = function(self)
		CStructureUnit.OnCreate(self)

        -- special effects
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

        -- add shield bulbs
        self:AddShieldToBone('ball1')
        self:AddShieldToBone('ball2')
        self:AddShieldToBone('ball3')
	end,

    --- Adds a small shield to a bone of this unit
    AddShieldToBone = function(self, bone)

        local shield = Entity()
        shield:AttachTo(self, bone)
        shield:SetMesh('/effects/entities/SeraphimShield01/SeraphimShield01_mesh')
        shield:SetDrawScale(1)
        shield:SetCollisionShape('Sphere', 0, 0, 0, 0.75)

        shield:SetVizToAllies('Intel')
        shield:SetVizToNeutrals('Intel')
        shield:SetVizToEnemies('Intel')
        
        shield.OnCollisionCheck = function(self, other, firingWeapon)
            CreateEmitterOnEntity(other, other.Army, '/mods/battle-royale/effects/seraphim_beacon_impact.bp')
        end
        
        self.Trash:Add(shield)
    end,
}

TypeClass = XSB5305