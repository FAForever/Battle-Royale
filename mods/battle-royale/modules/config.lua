
-- types: "Land T1", "Land T2", "Land T3", "Air T1", "Air T2", "Air T3", "Navy T1", "Navy T2", "Navy T3"

Land = { }

--- Adds a land entry with the correct formatting.
local function AddLandEntry(min, max, type, count)
    table.insert(Land, { Min = min, Max = max, Type = type, Count = count } )
end

AddLandEntry(0, 5, "Land T1", 10)
AddLandEntry(5, 10, "Land T1", 10)
AddLandEntry(8, 16, "Land T2", 4)
AddLandEntry(15, 25, "Land T2", 8)
AddLandEntry(20, 35, "Land T2", 10)
AddLandEntry(25, 35, "Land T3", 2)
AddLandEntry(30, 50, "Land T3", 6)
AddLandEntry(50, 600, "Land T3", 10)
AddLandEntry(40, 600, "Land T4", 1)

AddLandEntry(1, 5, "Air T1", 4)
AddLandEntry(5, 10, "Air T1", 10)
AddLandEntry(8, 16, "Air T2", 4)
AddLandEntry(15, 25, "Air T2", 8)
AddLandEntry(20, 35, "Air T2", 10)
AddLandEntry(25, 35, "Air T3", 2)
AddLandEntry(30, 50, "Air T3", 6)
AddLandEntry(50, 600, "Air T3", 10)
AddLandEntry(40, 600, "Air T4", 1)

Navy = { }

--- Adds a naval entry with the correct formatting.
local function AddNavalEntry(min, max, type, count)
    table.insert(Navy, { Min = min, Max = max, Type = type, Count = count } )
end

AddNavalEntry(0, 5, "Navy T1", 4)
AddNavalEntry(5, 10, "Navy T1", 8)
AddNavalEntry(8, 16, "Navy T2", 2)
AddNavalEntry(15, 25, "Navy T2", 4)
AddNavalEntry(20, 35, "Navy T2", 6)
AddNavalEntry(25, 35, "Navy T3", 1)
AddNavalEntry(30, 600, "Navy T3", 2)
AddNavalEntry(40, 600, "Navy T4", 1)

--- Retrieves the valid entries from the table given the timestamp (in minutes).
function GetValidEntries(entries, minutes)
    local valids = { }

    for k, element in entries do 
        if element.Min < minutes and minutes < element.Max then 
            table.insert(valids, element)
        end
    end

    return valids
end