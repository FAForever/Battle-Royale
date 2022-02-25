
local AStructureUnit = import('/lua/aeonunits.lua').AStructureUnit

local QuanticClusterHit = import('/lua/EffectTemplates.lua').Aeon_QuanticClusterHit
local QuanticClusterMuzzleFlash = import('/lua/EffectTemplates.lua').Aeon_QuanticClusterMuzzleFlash

UAB5205 = Class(AStructureUnit) {
    FxDamage1 = { import('/lua/EffectTemplates.lua').DamageSparks01 },
    FxDamage2 = { import('/lua/EffectTemplates.lua').DamageSparks01 },
    FxDamage3 = { import('/lua/EffectTemplates.lua').DamageSparks01 },

	OnCreate = function(self)
		AStructureUnit.OnCreate(self)
        
        local effect = CreateEmitterAtBone(self, 'light', self.Army, "/mods/battle-royale/effects/aeon_beacon_idle_effect_01.bp")
        effect:OffsetEmitter(0, 0.05, 0)
        effect:ScaleEmitter(0.25)
        self.Trash:Add(effect)

        local effect = CreateEmitterAtBone(self, 'light', self.Army, "/mods/battle-royale/effects/aeon_beacon_idle_effect_02.bp")
        effect:OffsetEmitter(0, -0.1, 0)
        effect:ScaleEmitter(0.6)
        self.Trash:Add(effect)

        local effect = CreateEmitterAtBone(self, 'light_2', self.Army, "/mods/battle-royale/effects/aeon_beacon_idle_effect_01.bp")
        effect:OffsetEmitter(0, 0.05, 0)
        effect:ScaleEmitter(0.25)
        self.Trash:Add(effect)

        local effect = CreateEmitterAtBone(self, 'light_2', self.Army, "/mods/battle-royale/effects/aeon_beacon_idle_effect_02.bp")
        effect:OffsetEmitter(0, -0.1, 0)
        effect:ScaleEmitter(0.6)
        self.Trash:Add(effect)


        -- rotate a bit
        local r = CreateRotator(self, 'UAB5205', 'y')
        self.Trash:Add(self.r)
        r:SetSpinDown(false)
        r:SetTargetSpeed(30)
        r:SetAccel(20)

        -- rotate a bit
        local r = CreateRotator(self, 'UAB5205_2', 'y')
        self.Trash:Add(self.r)
        r:SetSpinDown(false)
        r:SetTargetSpeed(30)
        r:SetAccel(20)
	end,

    DeathThread = function(self, instigator, type, overkillRatio)

        for k, effect in QuanticClusterHit do 
            local effect = CreateEmitterAtBone(self, 'light', self.Army, effect)
            effect:ScaleEmitter(0.35)
        end

        for k, effect in QuanticClusterMuzzleFlash do 
            local effect = CreateEmitterAtBone(self, 'light', self.Army, effect)
            effect:ScaleEmitter(0.35)
        end

        WaitSeconds(0.1)

        self:HideBone('UAB5205', false)

        WaitSeconds(0.1)

        for k, effect in QuanticClusterHit do 
            local effect = CreateEmitterAtBone(self, 'light_2', self.Army, effect)
            effect:ScaleEmitter(0.35)
        end

        for k, effect in QuanticClusterMuzzleFlash do 
            local effect = CreateEmitterAtBone(self, 'light_2', self.Army, effect)
            effect:ScaleEmitter(0.35)
        end

        WaitSeconds(0.1)

        self:HideBone('UAB5205_2', false)

        WaitSeconds(0.1)

        AStructureUnit.DeathThread(self, instigator, type, overkillRatio)
    end,

    -- override to disable default damage effects
    CreateDestructionEffects = function() end,
}

TypeClass = UAB5205