--- An object containing the coordinates of the death of the ACU,
--- necessary to create a commander's beacon.
ACUDeathCoordinates = { }

--- Stores ACU death coordinates, armyIndex is needed to identify specific ACU.
function ACUDeathCoordinates:SetCoords(armyIndex, x, y, z)
    self[armyIndex] = {x,  y, z}
end

--- Depending on armyIndex returns the ACU's death coordinates.
function ACUDeathCoordinates:GetCoords(armyIndex)
    return self[armyIndex]
end