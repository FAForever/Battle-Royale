--- the diameter of the circle that is drawn around the death of the commander.
local circleDiameter = 20


--- Thread that gradually reduces the diameter of the circle that is drawn around the death site of the ACU .
function DiameterChangeThread()

    while true do
        WaitSeconds(0.5)
        if (circleDiameter <= 2) then
            circleDiameter = 20
        end
        circleDiameter = circleDiameter - 2
    end

end


--- Thread that draws a circle around the death of the ACU .
function DrawCircleThread(position)

    -- TODO possible to use the color of the killed player
    local colorHex = "1137F4" --blue

    while true do
        WaitSeconds(0.1)
        DrawCircle(position, circleDiameter, colorHex)
    end
end

--- Shows information about the killed player. The number of units and their cost in mass.
--- @param nickname - nickname of the killed player
--- @param unitsData - number of units and their cost in mass.
function ShowDeathInfo(nickname, unitsData)
    local message = LOC("<LOC br_ui_death_info>%s was killed. Place of death is shown on the map. Capture the beacon to get %s units worth %s mass. Or destroy the beacon without letting other players capture it.")
    message = message:format(nickname, unitsData.unitAmount, unitsData.totalMassCost)
    PrintText(message, 20, 'ffffff', 15, 'center')
end