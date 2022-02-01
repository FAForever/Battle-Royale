
AIOpts = {

    {
        default = 3,
        label = "Battle Royale: setup time",
        help = "Determines how long it takes before the shrinking starts.",
        key = 'ShrinkingDelay',
        values = {
            {
                text = "None",
                help = "Disables the delay before shrinking the battlefield.",
                key = 0,
            },
            {
                text = "Very short",
                help = "The battlefield starts shrinking after 60 seconds.",
                key = 60,
            },
            {
                text = "Short",
                help = "The battlefield starts shrinking after 120 seconds.",
                key = 120,
            },
            {
                text = "Medium",
                help = "The battlefield starts shrinking after 240 seconds.",
                key = 240,
            },
            {
                text = "Long",
                help = "The battlefield starts shrinking after 360 seconds.",
                key = 360,
            },
        },
    },

    {
        default = 1,
        label = "Shrinking type",
        help = "Determines how the battlefield shrinks over time.",
        key = 'ShrinkingType',
        values = {
            {
                text = "Random",
                help = "A random side is chosen for shrinking.",
                key = 'pseudorandom',
            },
            {
                text = "Square",
                help = "Each side is chosen for shrinking, sides shrink slightly slower to compensate.",
                key = 'evenly',
            },
            {
                text = "Clockwise",
                help = "The shrinking is clockwise.",
                key = 'clockwise',
            },
            {
                text = "Сounterclockwise",
                help = "The shrinking is counterclockwise.",
                key = 'counterclockwise',
            },
        },
    },
    {
        default = 2,
        label = "Shrinking interval",
        help = "Determines how fast the battlefield shrinks.",
        key = 'ShrinkingRate',
        values = {
            {
                text = "Slow",
                help = "The battlefield shrinks every 180 seconds.",
                key = 180,
            },
            {
                text = "Medium",
                help = "The battlefield shrinks every 140 seconds.",
                key = 140,
            },
            {
                text = "Fast",
                help = "The battlefield shrinks every 100 seconds.",
                key = 100,
            },
            {
                text = "Hyper",
                help = "The battlefield shrinks every 60 seconds.",
                key = 60,
            },
        },
    },
    {
        default = 3,
        label = "Care packages interval",
        help = "Determines how fast care packages spawn.",
        key = 'CarePackagesRate',
        values = {
            {
                text = "Off",
                help = "Care",
                key = 0,
            },
            {
                text = "Slow",
                help = "A care package spawns every 60 seconds.",
                key = 60,
            },
            {
                text = "Medium",
                help = "A care package spawns every 40 seconds.",
                key = 40,
            },
            {
                text = "Fast",
                help = "A care package spawns every 20 seconds.",
                key = 20,
            },
            {
                text = "Hyper",
                help = "A care package spawns every 10 seconds.",
                key = 10,
            },
        },
    },
    {
        default = 2,
        label = "Care packages curve",
        help = "Determines how quickly care packages become more worth in tech..",
        key = 'CarePackagesCurve',
        values = {
            {
                text = "Slow",
                help = "Tech 3 will become available at about 30 minutes.",
                key = 0.75,
            },
            {
                text = "Medium",
                help = "Tech 3 will become available at about 25 minutes.",
                key = 1.0,
            },
            {
                text = "Fast",
                help = "Tech 3 will become available at about 20 minutes.",
                key = 1.25,
            },
            {
                text = "Hyper",
                help = "Tech 3 will become available at about 15 minutes.",
                key = 1.5,
            },
        },
    },
    {
        default = 1,
        label = "Care packages amount",
        help = "Determines how quickly care packages become more worth in tech..",
        key = 'CarePackagesAmount',
        values = {
            {
                text = "Normal",
                help = "The default number of units spawn in.",
                key = 1.0,
            },
            {
                text = "Many",
                help = "Double the number of units spawn in.",
                key = 2.0,
            },
        },
    },
}
