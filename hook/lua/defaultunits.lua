
local ACUInfo = import('/mods/battle-royale/modules/sim/ACUInfo.lua')

local oldACU = ACUUnit
ACUUnit = Class(oldACU) {
    OnKilled = function(self, instigator, type, overkillRatio)
        ACUInfo.ACUDeathCoordinates:SetCoords(self.Army, self:GetPositionXYZ())
        ACUInfo.PlayersNicknames:SetNickname(self.Army, self.Brain.Nickname)
        oldACU.OnKilled(self, instigator, type, overkillRatio)
    end
}