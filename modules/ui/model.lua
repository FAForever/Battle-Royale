
-- LOBBY OPTIONS --

--- Options received from the lobby through the sim.
Config = { }

-- CARE PACKAGES --

CarePackage = { }
CarePackage.Coordinates = nil
CarePackage.InWater = false
CarePackage.Blueprints = { }
CarePackage.Interval = 40
CarePackage.Timestamp = 0

-- SHRINKING --

Shrink = { }
Shrink.CurrentArea = { 0, 0, 512, 512 }
Shrink.NextArea = { 0, 0, 512, 512 }
Shrink.Interval = 40
Shrink.Timestamp = 0
Shrink.Delayed = true

-- COMMANDER BEACON --
Beacon = { }
Beacon.BuildCostEnergy = 0
Beacon.BuildTime = 0
Beacon.T2StageTime = 0
Beacon.T3StageTime = 0
Beacon.Timestamp = 0
