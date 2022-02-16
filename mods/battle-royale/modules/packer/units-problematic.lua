
--- List of units for which you need to adjust the spawn radius, because without adjustment, the beacon is inside the unit.

-- Format: name = { id, radiusIncrease }
-- where:
--  - id: unit blueprint identifier as used by the mod
--  - radiusIncrease: the value by which to increase the radius to spawn the units in

UnitTable = {
    tempest = {
        id = 'UAS0401',
        radiusIncrease = 6
    },
    fatboy = {
        id = 'UEL0401',
        radiusIncrease = 2
    },
}