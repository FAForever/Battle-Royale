
local SimPing = import('/lua/simping.lua')

local PingTypes = {
    alert = {
        Lifetime = 6, 
        Mesh = 'alert_marker', 
        Ring = '/game/marker/ring_yellow02-blur.dds', 
        ArrowColor = 'yellow', 
        Sound = 'UEF_Select_Radar'
    },
    move = {
        Lifetime = 6, 
        Mesh = 'move', 
        Ring = '/game/marker/ring_blue02-blur.dds', 
        ArrowColor = 'blue', 
        Sound = 'Cybran_Select_Radar'
    },
    attack = {
        Lifetime = 6, 
        Mesh = 'attack_marker', 
        Ring = '/game/marker/ring_red02-blur.dds', 
        ArrowColor = 'red', 
        Sound = 'Aeon_Select_Radar'
    },
    marker = {
        Lifetime = 5, 
        Ring = '/game/marker/ring_yellow02-blur.dds', 
        ArrowColor = 'yellow', 
        Sound = 'UI_Main_IG_Click', 
        Marker = true
    },
}   

-- format of the ping
-- local data = {Owner = army - 1, Type = pingType, Location = position}
-- data = table.merged(data, PingTypes[pingType])

function AttackPing(position, army)
    local data = { }
    data.Owner = army - 1
    data.Type = 'attack'
    data.Location = position

    SimPing.SpawnPing(table.merged(data, PingTypes[data.Type]))
end

function AlertPing(position, army)
    local data = { }
    data.Owner = army - 1
    data.Type = 'alert'
    data.Location = position

    SimPing.SpawnPing(table.merged(data, PingTypes[data.Type]))
end

function MovePing(position, army)
    local data = { }
    data.Owner = army - 1
    data.Type = 'move'
    data.Location = position

    SimPing.SpawnPing(table.merged(data, PingTypes[data.Type]))
end
