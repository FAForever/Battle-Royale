local import = import

--- Determines whether the coordinates are within a particular area.
local function InsideRectangle(rect, coords)
    local xBool = rect[1] < coords[1] and coords[1] < rect[3]
    local yBool = rect[2] < coords[3] and coords[3] < rect[4]
    return xBool and yBool
end

--- Instantly destroys units outside the play area.
function DestroyStrandedUnits()

    local model = import("/mods/battle-royale/modules/sim/model.lua")

    -- retrieve the brains
    local brains = ArmyBrains

    -- go over each undefeated brain
    for k, brain in brains do
        if not brain:IsDefeated() then
            local units = brain:GetListOfUnits(categories.ALLUNITS, false, false)

            -- go over each non-dead unit
            for k, unit in units do
                if not unit.Dead then

                    -- take 'em out if they're outside the playable area
                    local coords = unit:GetPosition()
                    if not InsideRectangle(model.PlayableArea, coords) then
                        unit:Kill()
                    end
                end
            end
        end
    end
end

--- Function that starts a separate thread that damages or destroys units.
function DamageOrDestroyStrandedUnits(destructionTime)
    ForkThread(DamageOrDestroyStrandedUnitsThread, destructionTime)
end

--- A thread in which, with a periodicity of one second, damage is done to a unit that is outside the play area.
--- The damage dealt depends on the destructionTime and IsRegenIgnore parameters.
--- If the damage from the non-playable zone exceeds the unit's current health, the unit will be destroyed.
--- @param destructionTime - time in seconds that a unit with full health can survive outside the play area. Must be greater than 0.
function DamageOrDestroyStrandedUnitsThread(destructionTime)

    if destructionTime == 0 or destructionTime < 0 then
        WARN("Destruction time = ".. destructionTime .. ". But must be greater than 0")
    end

    local BuffCalculate = import("/lua/sim/Buff.lua").BuffCalculate
    local IsRegenIgnore = ScenarioInfo.Options.Regen -- ignore = 1 , consider = 0

    while true do

        local model = import("/mods/battle-royale/modules/sim/model.lua")

        --- Returns the regen value, taking into account buffs and veterancy.
        local function GetCurrentRegen(unit)
            local bpRegen = unit:GetBlueprint().Defense.RegenRate or 0
            return BuffCalculate(unit, nil, 'Regen', bpRegen)
        end

        --- Damage is calculated with or without regen.
        --- IsRegenIgnore parameter is defined in the lobby options.
        local function CalcDamage(unit)
            local damage = unit:GetMaxHealth() / destructionTime
            return IsRegenIgnore == 1 and damage + GetCurrentRegen(unit) or damage
        end

        local function DoDamageOrKill(unit)
            local currentHealth = unit:GetHealth()
            local damage = CalcDamage(unit)

            if currentHealth > damage then
                unit:SetHealth(unit, currentHealth - damage)
            else
                unit:Kill()
            end
        end

        -- retrieve the brains
        local brains = ArmyBrains

        -- go over each undefeated brain
        for k, brain in brains do
            if not brain:IsDefeated() then
                local units = brain:GetListOfUnits(categories.ALLUNITS, false, false)

                -- go over each non-dead unit
                for k, unit in units do
                    if not unit.Dead then

                        local coords = unit:GetPosition()
                        if not InsideRectangle(model.PlayableArea, coords) then
                            DoDamageOrKill(unit)
                        end
                    end
                end
            end
        end

        WaitSeconds(1)
    end
end