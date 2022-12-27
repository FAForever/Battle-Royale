AIOpts = {

    {
        default = 3,
        label = '<LOC br_delay_label>Battle Royale: setup time',
        help = '<LOC br_delay_help>Determines how long it takes before the shrinking starts.',
        key = 'ShrinkingDelay',
        values = {
            {
                text = "<LOC br_delay_values_none_text>None",
                help = "<LOC br_delay_values_none_help>Disables the delay before shrinking the battlefield.",
                key = 0,
            },
            {
                text = "<LOC br_delay_values_very_short_text>Very short",
                help = "<LOC br_delay_values_very_short_help>The battlefield starts shrinking after 60 seconds.",
                key = 60,
            },
            {
                text = "<LOC br_delay_values_short_text>Short",
                help = "<LOC br_delay_values_short_help>The battlefield starts shrinking after 120 seconds.",
                key = 120,
            },
            {
                text = "<LOC br_delay_values_medium_text>Medium",
                help = "<LOC br_delay_values_medium_help>The battlefield starts shrinking after 240 seconds.",
                key = 240,
            },
            {
                text = "<LOC br_delay_values_long_text>Long",
                help = "<LOC br_delay_values_long_help>The battlefield starts shrinking after 360 seconds.",
                key = 360,
            },
        },
    },

    {
        default = 1,
        label = "<LOC br_type_label>Shrinking type",
        help = "<LOC br_type_help>Determines how the battlefield shrinks over time.",
        key = 'ShrinkingType',
        values = {
            {
                text = "<LOC br_type_values_random_text>Random",
                help = "<LOC br_type_values_random_help>A random side is chosen for shrinking.",
                key = 'pseudorandom',
            },
            {
                text = "<LOC br_type_values_square_text>Square",
                help = "<LOC br_type_values_square_help>Each side is chosen for shrinking, sides shrink slightly slower to compensate.",
                key = 'evenly',
            },
            {
                text = "<LOC br_type_values_clockwise_text>Clockwise",
                help = "<LOC br_type_values_clockwise_help>The shrinking is clockwise.",
                key = 'clockwise',
            },
            {
                text = "<LOC br_type_values_counterclockwise_text>Сounterclockwise",
                help = "<LOC br_type_values_counterclockwise_help>The shrinking is counterclockwise.",
                key = 'counterclockwise',
            },
        },
    },
    {
        default = 2,
        label = "<LOC br_interval_label>Shrinking interval",
        help = "<LOC br_interval_help>Determines how fast the battlefield shrinks.",
        key = 'ShrinkingRate',
        values = {
            {
                text = "<LOC br_interval_values_slow_text>Slow",
                help = "<LOC br_interval_values_slow_help>The battlefield shrinks every 180 seconds.",
                key = 180,
            },
            {
                text = "<LOC br_interval_values_medium_text>Medium",
                help = "<LOC br_interval_values_medium_help>The battlefield shrinks every 140 seconds.",
                key = 140,
            },
            {
                text = "<LOC br_interval_values_fast_text>Fast",
                help = "<LOC br_interval_values_fast_help>The battlefield shrinks every 100 seconds.",
                key = 100,
            },
            {
                text = "<LOC br_interval_values_hyper_text>Hyper",
                help = "<LOC br_interval_values_hyper_help>The battlefield shrinks every 60 seconds.",
                key = 60,
            },
        },
    },
    {
        default = 3,
        label = "<LOC br_packages_interval_label>Care packages interval",
        help = "<LOC br_packages_interval_help>Determines how fast care packages spawn.",
        key = 'CarePackagesRate',
        values = {
            {
                text = "<LOC br_packages_interval_values_off_text>Off",
                help = "<LOC br_packages_interval_values_off_help>Disables care package spawn.",
                key = 0,
            },
            {
                text = "<LOC br_packages_interval_values_slow_text>Slow",
                help = "<LOC br_packages_interval_values_slow_help>A care package spawns every 60 seconds.",
                key = 60,
            },
            {
                text = "<LOC br_packages_interval_values_medium_text>Medium",
                help = "<LOC br_packages_interval_values_medium_help>A care package spawns every 40 seconds.",
                key = 40,
            },
            {
                text = "<LOC br_packages_interval_values_fast_text>Fast",
                help = "<LOC br_packages_interval_values_fast_help>A care package spawns every 20 seconds.",
                key = 20,
            },
            {
                text = "<LOC br_packages_interval_values_hyper_text>Hyper",
                help = "<LOC br_packages_interval_values_hyper_help>A care package spawns every 10 seconds.",
                key = 10,
            },
        },
    },
    {
        default = 3,
        label = "<LOC br_eco_packages_interval_label>Economic packages interval",
        help = "<LOC br_eco_packages_interval_help>Determines how fast economic packages spawn.",
        key = 'EconomicPackagesRate',
        values = {
            {
                text = "<LOC br_eco_packages_interval_values_off_text>Off",
                help = "<LOC br_eco_packages_interval_values_off_help>Disables economic package spawn.",
                key = 0,
            },
            {
                text = "<LOC br_eco_packages_interval_values_slow_text>Slow",
                help = "<LOC br_eco_packages_interval_values_slow_help>A economic package spawns every 60 - 120 seconds.",
                key = 60,
            },
            {
                text = "<LOC br_eco_packages_interval_values_medium_text>Medium",
                help = "<LOC br_eco_packages_interval_values_medium_help>A economic package spawns every 40 - 80 seconds.",
                key = 40,
            },
            {
                text = "<LOC br_eco_packages_interval_values_fast_text>Fast",
                help = "<LOC br_eco_packages_interval_values_fast_help>A economic package spawns every 20 - 40 seconds.",
                key = 20,
            },
            {
                text = "<LOC br_eco_packages_interval_values_hyper_text>Hyper",
                help = "<LOC br_eco_packages_interval_values_hyper_help>A economic package spawns every 10 - 20 seconds.",
                key = 10,
            },
        },
    },
    {
        default = 2,
        label = "<LOC br_beacon_tech_level_label>Com beacon tech level",
        help = "<LOC br_beacon_tech_level_help>Determines the beacon of what tech level will appear after the death of the commander. The higher the mass cost of the killed player's units, the higher the tech level of the beacon, but the beacon capture time and the cost of capture in energy also increase with the  tech level.",
        key = "BeaconTechLevel",
        values = {
            {
                text = "<LOC br_beacon_tech_level_values_low_text>Low",
                help = "<LOC br_beacon_tech_level_values_low_help>Commander beacon levels: t1 - if the cost of units in the mass was up to 20к, t2 - from 20k to 80k, t3 - from 80k and above",
                key = 0.75,
            },
            {
                text = "<LOC br_beacon_tech_level_values_normal_text>Normal",
                help = "<LOC br_beacon_tech_level_values_normal_help>Commander beacon levels: t1 - if the cost of units in the mass was up to 30к, t2 - from 30k to 100k, t3 - from 100k and above",
                key = 1,
            },
            {
                text = "<LOC br_beacon_tech_level_values_high_text>High",
                help = "<LOC br_beacon_tech_level_values_high_help>Commander beacon levels: t1 - if the cost of units in the mass was up to 42к, t2 - from 42k to 120k, t3 - from 120k and above",
                key = 1.25,
            },
            {
                text = "<LOC br_beacon_tech_level_values_very_high_text>Very high",
                help = "<LOC br_beacon_tech_level_values_very_high_help>Commander beacon levels: t1 - if the cost of units in the mass was up to 60к, t2 - from 60k to 150k, t3 - from 150k and above",
                key = 1.5,
            },
        },
    },
    {
        default = 2,
        label = "<LOC br_packages_curve_label>Care packages curve",
        help = "<LOC br_packages_curve_help>Determines how quickly care packages become more worth in tech..",
        key = 'CarePackagesCurve',
        values = {
            {
                text = "<LOC br_packages_curve_values_slow_text>Slow",
                help = "<LOC br_packages_curve_values_slow_help>Tech 3 will become available at about 30 minutes.",
                key = 0.75,
            },
            {
                text = "<LOC br_packages_curve_values_medium_text>Medium",
                help = "<LOC br_packages_curve_values_medium_help>Tech 3 will become available at about 25 minutes.",
                key = 1.0,
            },
            {
                text = "<LOC br_packages_curve_values_fast_text>Fast",
                help = "<LOC br_packages_curve_values_fast_help>Tech 3 will become available at about 20 minutes.",
                key = 1.25,
            },
            {
                text = "<LOC br_packages_curve_values_hyper_text>Hyper",
                help = "<LOC br_packages_curve_values_hyper_help>Tech 3 will become available at about 15 minutes.",
                key = 1.5,
            },
        },
    },
    {
        default = 1,
        label = "<LOC br_packages_amount_label>Care packages amount",
        help = "<LOC br_packages_amount_help>Determines unit amount in care packages.",
        key = 'CarePackagesAmount',
        values = {
            {
                text = "<LOC br_packages_amount_values_normal_text>Normal",
                help = "<LOC br_packages_amount_values_normal_help>The default number of units spawn in.",
                key = 1.0,
            },
            {
                text = "<LOC br_packages_amount_values_double_text>Many",
                help = "<LOC br_packages_amount_values_double_help>Double the number of units spawn in.",
                key = 2.0,
            },
        },
    },
    {
        default = 1,
        label = "<LOC br_unit_buffer_label>Battle Royale: unit buffer",
        help = "<LOC br_unit_buffer_help>Determine what will happen to the units of the killed player.",
        key = "TargetArmy",
        values = {
            {
                text = "<LOC br_unit_buffer_values_neutral_text>Neutral army",
                help = "<LOC br_unit_buffer_values_neutral_help>After the player is defeated, the units will be transferred to the neutral army and become non-aggressive.",
                key = "neutral_army",
            },
            {
                text = "<LOC br_unit_buffer_values_players_text>Players army",
                help = "<LOC br_unit_buffer_values_players_help>After the defeat, the units remain with the player, but he loses control over them. Units remain hostile to opponents. Not recommended when playing in teams.",
                key = "players_army",
            },
        },
    },
    {
        default = 4,
        label = "<LOC br_destruction_mode_label>Unit destruction mode",
        help = "<LOC br_destruction_mode_help>Determines whether a unit outside the playable area will be destroyed instantly or over time.",
        key = "DestructionMode",
        values = {
            {
                text = "<LOC br_destruction_mode_values_instantly_text>Instantly",
                help = "<LOC br_destruction_mode_values_instantly_help>Any unit outside the playable area will be instantly destroyed.",
                key = 0,
            },
            {
                text = "<LOC br_destruction_mode_values_10_sec_text>10 sec",
                help = "<LOC br_destruction_mode_values_10_sec_help>Unit with full health outside the play area will survive 10 seconds. By default, regen is ignored.",
                key = 10,
            },
            {
                text = "<LOC br_destruction_mode_values_20_sec_text>20 sec",
                help = "<LOC br_destruction_mode_values_20_sec_help>Unit with full health outside the play area will survive 20 seconds. By default, regen is ignored.",
                key = 20,
            },
            {
                text = "<LOC br_destruction_mode_values_30_sec_text>30 sec",
                help = "<LOC br_destruction_mode_values_30_sec_help>Unit with full health outside the play area will survive 30 seconds. By default, regen is ignored.",
                key = 30,
            },
            {
                text = "<LOC br_destruction_mode_values_40_sec_text>40 sec",
                help = "<LOC br_destruction_mode_values_40_sec_help>Unit with full health outside the play area will survive 40 seconds. By default, regen is ignored.",
                key = 40,
            },
            {
                text = "<LOC br_destruction_mode_values_50_sec_text>50 sec",
                help = "<LOC br_destruction_mode_values_50_sec_help>Unit with full health outside the play area will survive 50 seconds. By default, regen is ignored.",
                key = 50,
            },
            {
                text = "<LOC br_destruction_mode_values_60_sec_text>60 sec",
                help = "<LOC br_destruction_mode_values_60_sec_help>Unit with full health outside the play area will survive 60 seconds. By default, regen is ignored.",
                key = 60,
            },
        }
    },
    {
        default = 1,
        label = "<LOC br_regen_label>Regen",
        help = "<LOC br_regen_help>Determines if health regeneration works outside the play area. Units with high regen will last longer outside the play area.",
        key = "Regen",
        values = {
            {
                text = "<LOC br_regen_values_ignore_text>Ignore",
                help = "<LOC br_regen_values_ignore_help>Unit with full health outside the play area will die within the time specified in the destruction mode.",
                key = 1,
            },
            {
                text = "<LOC br_regen_values_consider_text>Consider",
                help = "<LOC br_regen_values_consider_help>Health regeneration will reduce damage from non-playable area. Cybran's SACUs with a regen upgrade may not take any damage from the non-playable zone at all.",
                key = 0,
            },
        },
    },
    {
        default = 1,
        label = "<LOC br_sacu_spawn_label>SACU spawn",
        help = "<LOC br_sacu_spawn_help>Adds a resource SACU of one of the three races, or an engineering SACU of a seraph to the experimental units that appear.",
        key = "SacuSpawn",
        values = {
            {
                text = "<LOC br_sacu_spawn_values_yes_text>Yes",
                help = "<LOC br_sacu_spawn_values_yes_help>Add SACU to experimental unit",
                key = 1,
            },
            {
                text = "<LOC br_sacu_spawn_values_no_text>No",
                help = "<LOC br_sacu_spawn_values_no_help>Don't add SACU to experimental unit",
                key = 0,
            },
        },
    },
    {
        default = 2,
        label = "<LOC br_naval_exps_label>Naval exps",
        help = "<LOC br_naval_exps_help>Adjusts the possibility of ground/air experimental units spawning in water",
        key = "NavalExps",
        values = {
            {
                text = "<LOC br_naval_exps_values_only_naval_text>Only naval",
                help = "<LOC br_naval_exps_values_only_naval_help>Only navy experimental units appear in the water",
                key = "only_naval",
            },
            {
                text = "<LOC br_naval_exps_values_fifty_fifty_text>Fifty fifty",
                help = "<LOC br_naval_exps_values_fifty_fifty_help>One naval and then one land/air experimental units appear appears in the water in turn",
                key = "fifty_fifty",
            },
            {
                text = "<LOC br_naval_exps_values_more_naval_text>More naval",
                help = "<LOC br_naval_exps_values_more_naval_help>In water, two out of three experimental units will be navy",
                key = "more_naval",
            },
            {
                text = "<LOC br_naval_exps_values_more_other_text>More other",
                help = "<LOC br_naval_exps_values_more_other_help>In water, two out of three experimental units will be land/air",
                key = "more_other",
            },
        },
    },
}
