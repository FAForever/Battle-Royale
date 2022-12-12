function GetEmptyTeamIndex(teams)
    for index, team in teams do
        local count = 0
        for _, _ in team do
            count = count + 1
        end

        WARN("team: " .. tostring(index) .. " members: " .. tostring(count))

        if count == 0 then
            return index
        end
    end

    return 0

end

function GetPlayersList(ignoredPlayerId)
    local players = {}

    for index, brain in ArmyBrains do

        if (ignoredPlayerId == index) then
            continue
        end

        if not brain:IsDefeated() and not ArmyIsCivilian(index) then
            table.insert(players, { id = index, isAdded = false })
        end

    end

    return players

end

function RemoveEmptyTeam(index, teams)

    if index == 0 then
        return teams
    end

    table.remove(teams, index)
    return teams
end

function GetTeamsList()
    DetermineTeams(0)
end

function GetTeamsListWithoutPlayer(ignoredPlayerId)
    DetermineTeams(ignoredPlayerId)
end

function DetermineTeams(ignoredPlayerId)
    local teamIndex = 1
    local teams = {}

    local players = GetPlayersList(ignoredPlayerId)

    for _, player in players do

        teams[teamIndex] = {}

        if player.isAdded then
            continue
        end

        table.insert(teams[teamIndex], player.id)
        player.isAdded = true

        for _, player2 in players do


            if not (player.id == player2.id) and IsAlly(player.id, player2.id) and not player2.isAdded then

                table.insert(teams[teamIndex], player2.id)
                player2.isAdded = true

            end
        end

        teamIndex = teamIndex + 1

    end

    --print("determined teams :" .. teamIndex)

    local emptyTeamIndex = GetEmptyTeamIndex(teams)

    while (not (emptyTeamIndex == 0)) do
        teams = RemoveEmptyTeam(emptyTeamIndex, teams)
        emptyTeamIndex = GetEmptyTeamIndex(teams)
    end

    --print("really teams: " .. #teams)

    for index, team in teams do

        for _, id in team do
            print("team: " .. index .. " player id: " .. tostring(id))
        end
        print("---------------")
    end
end