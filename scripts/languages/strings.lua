STRINGS = {
    NAMES = {
        SHIRO = "Shiraori",
        WAKABA = "Wakaba",
        HELHEIM_BEYONDER = "Helheim Beyonder",
        KURIKUTA_DRIED = "Dried Kurikuta Fruit",
        SPIDERSCYTHE = "Arachne",
        SPIDERSCYTHE_SHIRO = "Spider Scythe",
        STORING_SPACE = "Storing Space",
        STORING_SPACE_DTOR = "Remove Storing Space",
        CHIPS = "Chips",
        EROSION = "Erosion",
        ARACHNECURSE = "Curse of Arachne",
        DECREASE_HUNGER = "Hunger",
        KUMO_SATURATE = "Satiete",
        KUMO_OVERSATURATE = "Stuffed",
        BUFF_EROSION = "Erosion",
        BUFF_FREEZE = "Freeze",
        BUFF_CURSE = "Curse",
        BUFF_CURSE_REGEN = "Regen",
        EROSIONDAMAGE = "<color=#451758>Erosion Damage</color>: <color=#451758>%2.1d</color>",
        EROSIONDEFENSE = "<color=#451758>Erosion Defense</color>: <color=#451758>%2.1d</color>",
        ABYSSDAMAGE = "<color=#221356>Abyss Damage</color>: <color=#221356>%2.1d</color>",
        ABYSSDEFENSE = "<color=#221356>Abyss Defense</color>: <color=#221356>%2.1d</color>",
        SILK_ROBE = "Silk Rope",
    },
    RECIPE_DESC = {
        HELHEIM_BEYONDER = "",
        SPIDERSCYTHE = "An ominous weapon made from the leg of an ominous spider-monster.",
        STORING_SPACE = "Applycation of space magic.",
        SILK_SHIRO = "The signature skill of spider-type monsters.",
    },
    ACTIONS = {
        PARRY = "Parry",
        CASTAOE = {
            SPIDERSCYTHE = "Sweep",
        },
        USESPELLBOOK = {
            CASTSPELL = GLOBAL.STRINGS.ACTIONS.CASTSPELL.GENERIC,
        },
    },
    SPELLS = {
        TOGGLENIGHTVISION = "Spider Vision",
        EVIL_EYES = {
            FREEZE = "Freeze Stare",
            CURSE = "Curse Stare",
            EROSION = "Erosion Glance",
            TWIST = "Twist Glance",
            GRAVITY = "Gravitation Glance",
            DESTRUCTION = "Erosion Glare",
        },
    },
    SKILLTREE = {
        SHIRO = {
        },
    },
    CHARACTER_TITLES = {
        shiro = "Goddess' standin",
        wakaba = "Goddess' avatar",
    },
    CHARACTER_NAMES = {
        shiro = "White Weaver",
        wakaba = "Hiiro Wakaba",
    },
    CHARACTER_DESCRIPTIONS = {
        shiro = "*A girl with a mysterious identity\n*Bad at expressing\n*Cannot hold the liquor",
        wakaba =
        "*A taciturn female high school student\n*Cannot empathize with others\n*Is good at action games\n*This is also part of \"Game\"",
    },
    CHARACTER_QUOTES = {
        shiro = "...",
        wakaba = "...",
    },
    CHARACTER_SURVIVABILITY = {
        shiro = GLOBAL.STRINGS.CHARACTER_SURVIVABILITY.wilson,
        wakaba = GLOBAL.STRINGS.CHARACTER_SURVIVABILITY.wanda,
    },
    CHARACTERS = {
        SHIRO = {
            DESCRIBE = {
                SHIRO = "%s, are you my standin?",
                WAKABA = "",
                SPIDERSCYTHE = "...It gives a sense of closeness and reassurance.",
                CHIPS = "I need more.",
                KURIKUTA_DRIED = "Although it's not fresh, it's much better than the monster's meat.",
                SILK_ROBE = "",
            },
            ACTIONFAIL = {
                CASTAOE = {
                    SPELL_ON_COOLDOWN = "Waiting for skill's cooldown is necessary.",
                },
            },
            ANNOUNCE_ATTACH_BUFF_EROSION_REGEN = "That caused a huge damage to my eyes, I need some time to recover...",
            ANNOUNCE_DETACH_BUFF_EROSION_REGEN = "I feel better now.",
        },
        WAKABA = {
            DESCRIBE = {
                SHIRO = "",
                WAKABA = "Despicable imitator.",
                HELHEIM_BEYONDER = "...",
                SPIDERSCYTHE = "Hope she likes this gift.",
                CHIPS = "Don't worry about getting fat, this is a perfect body.",
            },
            ACTIONFAIL = {
                CASTAOE = {
                    SPELL_ON_COOLDOWN = "Adding limit to my power makes game more interesting.",
                },
            },
        },
        GENERIC = {
            DESCRIBE = {
                SHIRO = "Quiet beauty.",
                WAKABA = "Quiet beauty.",
                CHIPS = "Crispy snack.",
                KURIKUTA_DRIED = "Some kind of dried fruit with a very sweet taste.",
                SILK_ROBE = "",
            },
        },
    },
    UI = {
        HUD = {
            DEATH_ANNOUNCEMENT_WAKABA = {
                "The role-playing game of %s is over! Her body was destroyed.",
                "The role-playing game of %s is over! Her body returned to the netherworld.",
            },
            REZ_ANNOUNCEMENT_WAKABA = {
                "By the hand of %s, %s was able to descend upon the Constant once again."
            },
        },
    },
    SKIN_NAMES = {
        shiro = "Death White",
        wakaba = "Goddess' role playing",
        shiro_jk = "School Days",
        shiro_classic = "Kumoko",
    },
    SKIN_DES = {
        shiro = "She might looks would be blown down by wind.\nYet she's the storm that blows everything down.",
        wakaba = "God made puppet.",
        shiro_jk = "\"She must be wakaba.\"",
        shiro_classic = "Initial version from mod \"Kumoko\"",
    },
    SKIN_QUOTES = {
        shiro = "\"...\"",
        wakaba = "\"...\"",
        shiro_jk = "I was in my memories, but it's fake.",
        shiro_classic = "I need more power.",
    },
}
local strs = env.STRINGS
rawset(env, "STRINGS", nil)
return strs