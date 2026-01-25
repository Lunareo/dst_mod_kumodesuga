STRINGS = {
    ACTIONS = {
        PARRY = "Parry",
        CASTAOE = {
            SPIDERSCYTHE = "Sweep",
        },
        USESPELLBOOK = {
            CASTSPELL = GLOBAL.STRINGS.ACTIONS.CASTSPELL.GENERIC,
        },
    },
    CHARACTERS = {
        GENERIC = {
            ACTIONFAIL = {
                CASTAOE = {
                    SPELL_NOT_ENOUGH_COST = "Performing this spell requires more cost.",
                },
            },
            ANNOUNCE_ATTACH_BUFF_HEALTH_PENALTY_REDUCTION = "only_used_by_shiro",
            DESCRIBE = {
                ARAMASA = "",
                CHIPS = "Crispy snack.",
                KURIKUTA_DRIED = "Some kind of dried fruit with a very sweet taste.",
                SHIRO = "Quiet beauty.",
                SILK_ROBE = "",
                WAKABA = "Quiet beauty.",
            },
        },
        SHIRO = {
            ACTIONFAIL = {
                CASTAOE = {
                    SPELL_ON_COOLDOWN = "Waiting for skill's cooldown is necessary.",
                },
            },
            ANNOUNCE_ATTACH_BUFF_HEALTH_PENALTY_REDUCTION = "That caused a huge damage to my eyes, I need some time to recover...",
            ANNOUNCE_DETACH_BUFF_HEALTH_PENALTY_REDUCTION = "I feel better now.",
            DESCRIBE = {
                CHIPS = "I need more.",
                KURIKUTA_DRIED = "Although it's not fresh, it's much better than the monster's meat.",
                SHIRO = "%s, are you my standin?",
                SILK_ROBE = "",
                SPIDERSCYTHE = "...It gives a sense of closeness and reassurance.",
                WAKABA = "",
            },
        },
        WAKABA = {
            ACTIONFAIL = {
                CASTAOE = {
                    SPELL_ON_COOLDOWN = "Adding limit to my power makes game more interesting.",
                },
            },
            DESCRIBE = {
                CHIPS = "Don't worry about getting fat, this is a perfect body.",
                HELHEIM_BEYONDER = "...",
                SHIRO = "",
                SPIDERSCYTHE = "Hope she likes this gift.",
                WAKABA = "Despicable imitator.",
            },
        },
    },
    CHARACTER_DESCRIPTIONS = {
        shiro = "*A girl with a mysterious identity\n*Bad at expressing\n*Cannot hold the liquor",
        wakaba = "*A taciturn female high school student\n*Cannot empathize with others\n*Is good at action games\n*This is also part of \"Game\"",
    },
    CHARACTER_NAMES = {
        shiro = "White Weaver",
        wakaba = "Hiiro Wakaba",
    },
    CHARACTER_QUOTES = {
        shiro = "...",
        wakaba = "...",
    },
    CHARACTER_SURVIVABILITY = {
        shiro = GLOBAL.STRINGS.CHARACTER_SURVIVABILITY.wilson,
        wakaba = GLOBAL.STRINGS.CHARACTER_SURVIVABILITY.wanda,
    },
    CHARACTER_TITLES = {
        shiro = "Goddess' standin",
        wakaba = "Goddess' avatar",
    },
    INSIGHT_DESC = {
        ARAMASA = "Cause 8 times dmg per atk",
    },
    NAMES = {
        ABYSSDAMAGE = "<color=#221356>Abyss Damage</color>: <color=#221356>%2.1d</color>",
        ABYSSDEFENSE = "<color=#221356>Abyss Defense</color>: <color=#221356>%2.1d</color>",
        ARACHNECURSE = "Curse of Arachne",
        ARAMASA = "Aramasa",
        BUFF_CURSE = "Curse",
        BUFF_CURSE_REGEN = "Regen",
        BUFF_EROSION = "Erosion",
        BUFF_FREEZE = "Freeze",
        CHIPS = "Chips",
        DECREASE_HUNGER = "Hunger",
        EROSION = "Erosion",
        EROSIONDAMAGE = "<color=#451758>Erosion Damage</color>: <color=#451758>%2.1d</color>",
        EROSIONDEFENSE = "<color=#451758>Erosion Defense</color>: <color=#451758>%2.1d</color>",
        HALF_SANITY_VAL = GLOBAL.STRINGS.NAMES.HALF_SANITY,
        HELHEIM_BEYONDER = "Helheim Beyonder",
        KUMO_OVERSATURATE = "Stuffed",
        KUMO_ATK_STEALER = "ATK Stolen",
        KUMO_SATURATE = "Satiete",
        KURIKUTA_DRIED = "Dried Kurikuta Fruit",
        SHIRO = "Shiraori",
        SILK_ROBE = "Silk Rope",
        SPIDERSCYTHE = "Arachne",
        SPIDERSCYTHE_SHIRO = "Spider Scythe",
        STORING_SPACE = "Storing Space",
        STORING_SPACE_DTOR = "Remove Storing Space",
        WAKABA = "Wakaba",
    },
    RECIPE_DESC = {
        ARAMASA = "A replica of a creator's glove.",
        HELHEIM_BEYONDER = "",
        SILK_SHIRO = "The signature skill of spider-type monsters.",
        SPIDERSCYTHE = "An ominous weapon made from the leg of an ominous spider-monster.",
        STORING_SPACE = "Applycation of space magic.",
    },
    SKILLTREE = {
        SHIRO = {},
    },
    SKIN_DESCRIPTIONS = {
        shiro = "She might looks would be blown down by wind.\nYet she's the storm that blows everything down.",
        shiro_classic = "Initial version from mod \"Kumoko\"",
        shiro_jk = "\"She must be wakaba.\"",
        wakaba = "God made puppet.",
    },
    SKIN_NAMES = {
        shiro = "Death White",
        shiro_classic = "Kumoko",
        shiro_jk = "School Days",
        wakaba = "Goddess' role playing",
    },
    SKIN_QUOTES = {
        shiro = "\"...\"",
        shiro_classic = "I need more power.",
        shiro_jk = "I was in my memories, but it's fake.",
        wakaba = "\"...\"",
    },
    SPELLS = {
        TOGGLENIGHTVISION = "Spider Vision",
        EVIL_EYES = {
            CURSE = string.format("Curse Stare(%d san)", TUNING.SPELL_CURSE_COST),
            DESTRUCTION = string.format("Erosion Glare(%d san)", TUNING.SPELL_DESTRUCTION_COST),
            EROSION = string.format("Erosion Glance(%d san)", TUNING.SPELL_EROSION_COST),
            FREEZE = string.format("Freeze Stare(%d san)", TUNING.SPELL_FREEZE_COST),
            GRAVITY = string.format("Gravitation Glance(%d san)", TUNING.SPELL_GRAVITY_COST),
            TWIST = string.format("Twist Glance(%d san)", TUNING.SPELL_TWIST_COST),
        },
    },
    UI = {
        HUD = {
            DEATH_ANNOUNCEMENT_WAKABA = {
                [1] = "The role-playing game of %s is over! Her body returned to the netherworld.",
                [2] = "The role-playing game of %s is over! Her body was destroyed.",
            },
            REZ_ANNOUNCEMENT_WAKABA = {
                [1] = "By the hand of %s, %s was able to descend upon the Constant once again."
            },
        },
    },
}
local strs = env.STRINGS
rawset(env, "STRINGS", nil)
return strs