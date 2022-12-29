
local ACUInfo = import('/mods/Battle-Royale-by-Dark-Horse/modules/sim/ACUInfo.lua')

local oldACU = ACUUnit
ACUUnit = Class(oldACU) {
    OnKilled = function(self, instigator, type, overkillRatio)
        ACUInfo.ACUDeathCoordinates:SetCoords(self.Army, self:GetPositionXYZ())
        ACUInfo.PlayersNicknames:SetNickname(self.Army, self.Brain.Nickname)
        oldACU.OnKilled(self, instigator, type, overkillRatio)
    end
}