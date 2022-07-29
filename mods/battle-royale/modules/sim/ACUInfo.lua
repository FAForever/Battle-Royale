--- An object containing the coordinates of the death of the ACU,
--- necessary to create a commander's beacon.
ACUDeathCoordinates = { }
PlayersNicknames = { }

--- Stores ACU death coordinates, armyIndex is needed to identify specific ACU.
function ACUDeathCoordinates:SetCoords(armyIndex, x, y, z)
    self[armyIndex] = {x,  y, z}
end

--- Depending on armyIndex returns the ACU's death coordinates.
function ACUDeathCoordinates:GetCoords(armyIndex)
    return self[armyIndex]
end

function PlayersNicknames:SetNickname(armyIndex, nickname)
    self[armyIndex] = {nickname}
end

function PlayersNicknames:GetNickname(armyIndex)
    return self[armyIndex]
end

