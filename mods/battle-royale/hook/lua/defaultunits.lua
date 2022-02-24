local oldACU = ACUUnit
local ACUDeathCoordinates = import('/mods/battle-royale/modules/sim/ACUInfo.lua').ACUDeathCoordinates

ACUUnit = Class(oldACU) {
    OnKilled = function(self, instigator, type, overkillRatio)
        local selfIndex = self:GetAIBrain():GetArmyIndex()
        ACUDeathCoordinates:SetCoords(selfIndex, unpack(self:GetPosition()))
        oldACU.OnKilled(self, instigator, type, overkillRatio)
    end
}