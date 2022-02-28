
local AStructureUnit = import('/lua/aeonunits.lua').AStructureUnit

local QuanticClusterHit = import('/lua/EffectTemplates.lua').Aeon_QuanticClusterHit
local QuanticClusterMuzzleFlash = import('/lua/EffectTemplates.lua').Aeon_QuanticClusterMuzzleFlash

UAB5305 = Class(AStructureUnit) {
	
	FxTransportBeacon = '/mods/battle-royale/effects/beacon_light.bp',
	FxTransportBeaconScale = 1,

    FxDamage1 = { import('/lua/EffectTemplates.lua').DamageSparks01 },
    FxDamage2 = { import('/lua/EffectTemplates.lua').DamageSparks01 },
    FxDamage3 = { import('/lua/EffectTemplates.lua').DamageSparks01 },

    IdleAnim = "/mods/battle-royale/units/uab5105/uab5105_idle.sca",
    Entities = 3,

	OnCreate = function(self)
		AStructureUnit.OnCreate(self)
        
        local bp = self:GetBlueprint()

        -- base effect
        local effect = CreateEmitterAtBone(self, 'base_effect', self.Army, "/mods/battle-royale/effects/aeon_beacon_idle_effect_01.bp")
        effect:OffsetEmitter(0, -0.4, 0)
        effect:ScaleEmitter(0.5) 
        self.Trash:Add(effect)

        local effect = CreateEmitterAtBone(self, 'base_effect', self.Army, "/mods/battle-royale/effects/aeon_beacon_idle_effect_02.bp")
        effect:OffsetEmitter(0, -0.05, 0)
        effect:ScaleEmitter(0.6)
        self.Trash:Add(effect)

        -- local effect = CreateEmitterAtBone(self, 'base_effect', self.Army, self.FxTransportBeacon)
        -- effect:ScaleEmitter(self.FxTransportBeaconScale)
        -- effect:OffsetEmitter(0, 0.05, 0)
        -- self.Trash:Add(effect)

        -- effect per node
        local rotations = {30, -20, 40}
        for k = 1, self.Entities do 
            local effect = CreateEmitterAtBone(self, 'light' .. k, self.Army, "/mods/battle-royale/effects/aeon_beacon_idle_effect_01.bp")
            effect:OffsetEmitter(0, 0.05, 0)
            effect:ScaleEmitter(0.25) 
            self.Trash:Add(effect)

            local effect = CreateEmitterAtBone(self, 'ball' .. k, self.Army, "/mods/battle-royale/effects/aeon_beacon_idle_effect_02.bp")
            effect:OffsetEmitter(0, 0.0, 0)
            effect:ScaleEmitter(0.5)
            self.Trash:Add(effect)

            local r = CreateRotator(self, 'ball' .. k, 'y')
            self.Trash:Add(r)
            r:SetSpinDown(false)
            r:SetTargetSpeed(rotations[k])
            r:SetAccel(20)
        end
	end,

    DeathThread = function(self, instigator, type, overkillRatio)

        -- create an explosion at each section
        for k = 1, self.Entities do 
            local bone = 'ball' .. k

            for k, effect in QuanticClusterHit do 
                local effect = CreateEmitterAtBone(self, bone, self.Army, effect)
                effect:ScaleEmitter(0.35)
            end

            for k, effect in QuanticClusterMuzzleFlash do 
                local effect = CreateEmitterAtBone(self, bone, self.Army, effect)
                effect:ScaleEmitter(0.35)
            end

            WaitSeconds(0.1)
            self:HideBone(bone, false)
        end

        AStructureUnit.DeathThread(self, instigator, type, overkillRatio)
    end,

    -- override to disable default damage effects
    CreateDestructionEffects = function() end,
}

TypeClass = UAB5305