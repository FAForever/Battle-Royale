local oldACU = ACUUnit
local ACUInfo = import('/mods/battle-royale/modules/sim/ACUInfo.lua')

ACUUnit = Class(oldACU) {
    OnKilled = function(self, instigator, type, overkillRatio)
        local selfIndex = self:GetAIBrain():GetArmyIndex()
        ACUInfo.ACUDeathCoordinates:SetCoords(selfIndex, unpack(self:GetPosition()))
        ACUInfo.PlayersNicknames:SetNickname(selfIndex, self:GetAIBrain().Nickname)
        oldACU.OnKilled(self, instigator, type, overkillRatio)
    end
}