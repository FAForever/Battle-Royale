
ACUDeathCoordinates = { }
PlayersNicknames = { }

--- Stores the coordinates where the ACU of an army died
---@param self table
---@param army number
---@param x number
---@param y number
---@param z number
function ACUDeathCoordinates:SetCoords(army, x, y, z)
    self[army] = {x, y, z}
end


--- Retrieves the coordinates of where the ACU of an army died
---@param self table
---@param army number
---@return table<number, number, number>
function ACUDeathCoordinates:GetCoords(army)
    return self[army]
end

--- Stores the name of the army
---@param self table
---@param army number
---@param nickname string
function PlayersNicknames:SetNickname(army, nickname)
    self[army] = {nickname}
end

--- Retrieves the name of an army
---@param self table
---@param army number
---@return string
function PlayersNicknames:GetNickname(army)
    return self[army]
end

