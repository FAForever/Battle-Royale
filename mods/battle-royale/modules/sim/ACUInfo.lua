--- An object containing the coordinates of the death of the ACU,
--- necessary to create a commander's beacon.
ACUDeathCoordinates = {
    x = 0,
    y = 0,
    z = 0,
}

function ACUDeathCoordinates:GetCoords()
    return {self.x, self.y, self.z}
end

function ACUDeathCoordinates:SetCoords(x, y, z)
    self.x = x
    self.y = y
    self.z = z
end