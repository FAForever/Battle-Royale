
AIOpts = {

    -- {
    --     default = 1,
    --     label = "Battle Royale: setup time",
    --     help = "Determines how long it takes before the shrinking starts.",
    --     key = 'ShrinkingDelay',
    --     values = {
    --         {
    --             text = "Short",
    --             help = "The battlefield starts shrinking after 120 seconds.",
    --             key = 120,
    --         },
    --         {
    --             text = "Medium",
    --             help = "The battlefield starts shrinking after 240 seconds.",
    --             key = 240,
    --         },
    --         {
    --             text = "Long",
    --             help = "The battlefield starts shrinking after 360 seconds.",
    --             key = 360,
    --         },
    --     },
    -- },

    {
        default = 1,
        label = "Battle Royale: shrinking type",
        help = "Determines how the battlefield shrinks over time.",
        key = 'ShrinkingType',
        values = {
            {
                text = "Pseudo random",
                help = "A pseudo-randomly chosen side shrinks during each iteration.",
                key = 'pseudorandom',
            },
            {
                text = "Evenly",
                help = "Each side shrinks during each iteration.",
                key = 'evenly',
            },
        },
    },
    {
        default = 1,
        label = "Battle Royale: shrinking interval",
        help = "Determines how fast the battlefield shrinks.",
        key = 'ShrinkingRate',
        values = {
            {
                text = "Slow",
                help = "The battlefield shrinks every 180 seconds.",
                key = 180,
            },
            {
                text = "Mediocre",
                help = "The battlefield shrinks every 140 seconds.",
                key = 140,
            },
            {
                text = "Fast",
                help = "The battlefield shrinks every 100 seconds.",
                key = 100,
            },
        },
    },
    {
        default = 3,
        label = "Battle Royale: care packages interval",
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
                text = "Mediocre",
                help = "A care package spawns every 40 seconds.",
                key = 40,
            },
            {
                text = "Fast",
                help = "A care package spawns every 20 seconds.",
                key = 20,
            },
        },
    },
}
