
local ACUInfo = import('/mods/battle-royale/modules/sim/ACUInfo.lua')
local DiplomacyController = import('/mods/battle-royale/modules/sim/diplomacy-controller.lua')


local oldACU = ACUUnit
ACUUnit = Class(oldACU) {
    OnKilled = function(self, instigator, type, overkillRatio)

        WARN("TeamList: ")
        DiplomacyController:GetTeamsList()
        WARN("===========")
        WARN("TeamListWithoutPlayer: " .. self.Army)
        DiplomacyController:GetTeamsListWithoutPlayer(self.Army)

        ACUInfo.ACUDeathCoordinates:SetCoords(self.Army, self:GetPositionXYZ())
        ACUInfo.PlayersNicknames:SetNickname(self.Army, self.Brain.Nickname)
        oldACU.OnKilled(self, instigator, type, overkillRatio)
    end
}