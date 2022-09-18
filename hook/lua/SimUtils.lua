local TargetArmy = ScenarioInfo.Options.TargetArmy

--- This code is taken from the game engine.
--- Only a small part of it has been changed.
--- For the convenience of finding changes, they are marked as "change".

function TransferUnitsOwnership(units, ToArmyIndex, captured)
    local toBrain = GetArmyBrain(ToArmyIndex)

    --- change
    ---The condition is not correctly determined here, which does not allow returning units to the killed player
    ---and transferring them to another army. Necessary for the mod to work correctly.
    if not toBrain or (toBrain:IsDefeated() and not TargetArmy) or not units or table.empty(units) then
    --if not toBrain or toBrain:IsDefeated() or not units or table.empty(units) then
        return
    end
    local fromBrain = GetArmyBrain(units[1].Army)
    local shareUpgrades

    if ScenarioInfo.Options.Share == 'FullShare' then
        shareUpgrades = true
    end

    -- do not gift insignificant units
    units = EntityCategoryFilterDown(categories.ALLUNITS - categories.INSIGNIFICANTUNIT, units)

    -- gift most valuable units first
    table.sort(units, function (a, b) return a:GetBlueprint().Economy.BuildCostMass > b:GetBlueprint().Economy.BuildCostMass end)

    local newUnits = {}
    local upUnits = {}
    local pauseKennels = {}
    local upgradeKennels = {}

    for k,v in units do
        local owner = v.Army
        -- Only allow units not attached to be given. This is because units will give all of it's children over
        -- aswell, so we only want the top level units to be given.
        -- Units currently being captured is also denied
        local disallowTransfer = owner == ToArmyIndex or
                v:GetParent() ~= v or (v.Parent and v.Parent ~= v) or
                v.CaptureProgress > 0

        if disallowTransfer then
            continue
        end

        local unit = v
        local bp = unit:GetBlueprint()
        local unitId = unit.UnitId

        -- B E F O R E
        local numNukes = unit:GetNukeSiloAmmoCount()  -- looks like one of these 2 works for SMDs also
        local numTacMsl = unit:GetTacticalSiloAmmoCount()
        local massKilled = unit.Sync.totalMassKilled
        local massKilledTrue = unit.Sync.totalMassKilledTrue
        local unitHealth = unit:GetHealth()
        local shieldIsOn = false
        local ShieldHealth = 0
        local hasFuel = false
        local fuelRatio = 0
        local enh = {} -- enhancements
        local oldowner = unit.oldowner
        local upgradesTo = unit.UpgradesTo
        local defaultBuildRate
        local upgradeBuildRate
        local exclude

        if unit.MyShield then
            shieldIsOn = unit:ShieldIsOn()
            ShieldHealth = unit.MyShield:GetHealth()
        end
        if bp.Physics.FuelUseTime and bp.Physics.FuelUseTime > 0 then   -- going through the BP to check for fuel
            fuelRatio = unit:GetFuelRatio()                             -- usage is more reliable then unit.HasFuel
            hasFuel = true                                              -- cause some buildings say they use fuel
        end
        local posblEnh = bp.Enhancements
        if posblEnh then
            for k,v in posblEnh do
                if unit:HasEnhancement(k) then
                    table.insert(enh, k)
                end
            end
        end

        if bp.CategoriesHash.ENGINEERSTATION and bp.CategoriesHash.UEF then
            --We have to kill drones which are idling inside Kennel at the moment of transfer
            --otherwise additional dummy drone will appear after transfer
            for _,drone in unit:GetCargo() do
                drone:Destroy()
            end
        end

        if unit.TransferUpgradeProgress and shareUpgrades then
            local progress = unit:GetWorkProgress()
            local upgradeBuildTime = unit.UpgradeBuildTime

            defaultBuildRate = unit:GetBuildRate()

            if progress > 0.05 then --5%. EcoManager & auto-paused mexes etc.
                --What build rate do we need to reach required % in 1 tick?
                upgradeBuildRate = upgradeBuildTime * progress * 10
            end
        end

        unit.IsBeingTransferred = true

        -- changing owner
        unit = ChangeUnitArmy(unit,ToArmyIndex)
        if not unit then
            continue
        end

        table.insert(newUnits, unit)

        unit.oldowner = oldowner

        if IsAlly(owner, ToArmyIndex) then
            if not unit.oldowner then
                unit.oldowner = owner
            end

            if not sharedUnits[unit.oldowner] then
                sharedUnits[unit.oldowner] = {}
            end
            table.insert(sharedUnits[unit.oldowner], unit)
        end

        -- A F T E R
        if massKilled and massKilled > 0 then
            unit:CalculateVeterancyLevelAfterTransfer(massKilled, massKilledTrue)
        end
        if enh and not table.empty(enh) then
            for k, v in enh do
                unit:CreateEnhancement(v)
            end
        end
        if unitHealth > unit:GetMaxHealth() then
            unitHealth = unit:GetMaxHealth()
        end
        unit:SetHealth(unit,unitHealth)
        if hasFuel then
            unit:SetFuelRatio(fuelRatio)
        end
        if numNukes and numNukes > 0 then
            unit:GiveNukeSiloAmmo((numNukes - unit:GetNukeSiloAmmoCount()))
        end
        if numTacMsl and numTacMsl > 0 then
            unit:GiveTacticalSiloAmmo((numTacMsl - unit:GetTacticalSiloAmmoCount()))
        end
        if unit.MyShield then
            unit.MyShield:SetHealth(unit, ShieldHealth)
            if shieldIsOn then
                unit:EnableShield()
            else
                unit:DisableShield()
            end
        end
        if EntityCategoryContains(categories.ENGINEERSTATION, unit) then
            if not upgradeBuildRate or not shareUpgrades then
                if bp.CategoriesHash.UEF then
                    --use special thread for UEF Kennels.
                    --Give them 1 tick to spawn their drones and then pause both station and drone.
                    table.insert(pauseKennels, unit)
                else --pause cybran hives immediately
                    unit:SetPaused(true)
                end
            elseif bp.CategoriesHash.UEF then
                unit.UpgradesTo = upgradesTo
                unit.DefaultBuildRate = defaultBuildRate
                unit.UpgradeBuildRate = upgradeBuildRate

                table.insert(upgradeKennels, unit)

                exclude = true
            end
        end

        if upgradeBuildRate and not exclude then
            unit.UpgradesTo = upgradesTo
            unit.DefaultBuildRate = defaultBuildRate
            unit.UpgradeBuildRate = upgradeBuildRate

            table.insert(upUnits, unit)
        end

        unit.IsBeingTransferred = false

        if v.OnGiven then
            v:OnGiven(unit)
        end
    end

    if not captured then
        if upUnits[1] then
            ForkThread(UpgradeTransferredUnits, upUnits)
        end

        if pauseKennels[1] then
            ForkThread(PauseTransferredKennels, pauseKennels)
        end

        if upgradeKennels[1] then
            ForkThread(UpgradeTransferredKennels, upgradeKennels)
        end
    end

    return newUnits
end