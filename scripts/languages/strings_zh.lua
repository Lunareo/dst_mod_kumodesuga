return {
    NAMES = {
        SHIRO = "白织",
        WAKABA = "若叶姬色",
        HELHEIM_BEYONDER = "超越冥界",
        KURIKUTA_DRIED = "干燥库利库塔果实",
        SPIDERSCYTHE = "阿剌克涅",
        SPIDERSCYTHE_SHIRO = "蜘蛛大镰刀",
        STORING_SPACE = "储物空间",
        STORING_SPACE_DTOR = "解除储物空间",
        CHIPS = "薯片",
        EROSION = "腐蚀",
        ARACHNECURSE = "蜘蛛女郎的诅咒",
        DECREASE_HUNGER = "饥饿度",
        KUMO_SATURATE = "饱足",
        KUMO_OVERSATURATE = "吃撑了",
        BUFF_EROSION = "腐蚀",
        BUFF_FREEZE = "冻结",
        EROSIONDAMAGE = "<color=#451758>腐蚀伤害</color>: <color=#451758>%2.1d</color>",
        EROSIONDEFENSE = "<color=#451758>腐蚀抗性</color>: <color=#451758>%2.1d</color>",
        ABYSSDAMAGE = "<color=#221356>外道伤害</color>: <color=#221356>%2.1d</color>",
        ABYSSDEFENSE = "<color=#221356>外道抗性</color>: <color=#221356>%2.1d</color>",
    },
    RECIPE_DESC = {
        HELHEIM_BEYONDER = nil,
        SPIDERSCYTHE = "An ominous weapon made from the leg of an ominous spider-monster.",
        STORING_SPACE = "对空间魔术的娴熟应用。",
        SILK_SHIRO = "蜘蛛型魔物的基本功。",
    },
    ACTIONS = {
        PARRY = "闪避",
        CASTAOE = {
            SPIDERSCYTHE = "横扫",
        },
        USESPELLBOOK = {
            CASTSPELL = nil,
        },
    },
    SPELLS = {
        TOGGLENIGHTVISION = "锐利目光",
        EVIL_EYES = {
            FREEZE = "静止之邪眼",
            CURSE = "诅咒之邪眼",
            EROSION = "腐蚀之邪眼",
            TWIST = "歪曲之邪眼",
            GRAVITY = "引斥之邪眼",
        },
    },
    CHARACTER_TITLES = {
        shiro = "神之替身",
        wakaba = "神之化身",
    },
    CHARACTER_NAMES = {
        shiro = "白",
        wakaba = "若叶姬色",
    },
    CHARACTER_DESCRIPTIONS = {
        shiro = "*A girl with a mysterious identity\n*Bad at expressing\n*Cannot hold the liquor",
        wakaba =
        "*A taciturn female high school student\n*Cannot empathize with others\n*Is good at action games\n*This is also part of \"Game\"",
    },
    CHARACTER_QUOTES = {
        shiro = nil,
        wakaba = nil,
    },
    CHARACTER_SURVIVABILITY = {
        shiro = STRINGS.CHARACTER_SURVIVABILITY.wilson,
        wakaba = STRINGS.CHARACTER_SURVIVABILITY.wanda,
    },
    CHARACTERS = {
        SHIRO = {
            DESCRIBE = {
                SHIRO = "%s, 你是我的替身吗?",
                WAKABA = nil,
                SPIDERSCYTHE = "有一种亲近的感觉。",
                CHIPS = "没想到在这里也能吃到这个。",
                KURIKUTA_DRIED = "比起有毒魔物的肉, 这个已经非常不错了。",
            },
        },
        WAKABA = {
            DESCRIBE = {
                SHIRO = "",
                WAKABA = "拙劣的模仿。",
                HELHEIM_BEYONDER = nil,
                SPIDERSCYTHE = "希望她喜欢这个礼物。",
                CHIPS = "不必担心发胖，这个身躯是完美的。",
            },
        },
        GENERIC = {
            DESCRIBE = {
                SHIRO = "Quiet beauty.",
                WAKABA = "Quiet beauty.",
                CHIPS = "酥脆可口的小零食。",
                KURIKUTA_DRIED = "Some kind of dried fruit with a very sweet taste.",
            },
        },
    },
    UI = {
        HUD = {
            DEATH_ANNOUNCEMENT_WAKABA = {
                "%s 的扮演游戏结束了! 她的躯体被摧毁了.",
                "%s 的扮演游戏结束了! 她的躯体回归了冥界.",
            },
            REZ_ANNOUNCEMENT_WAKABA = {
                "借由 %s 之手, %s 得以再次降临永恒领域."
            },
        },
    },
    SKIN_NAMES = {
        shiro = "白色死神",
        wakaba = "返校日",
        shiro_jk = "返校日",
        shiro_classic = "蜘蛛子",
    },
    SKIN_DES = {
        shiro = "She might looks would be blown down by wind.\nYet she's the storm that blows everything down.",
        wakaba = "God made puppet.",
        shiro_jk = "\"She must be wakaba.\"",
        shiro_classic = "来自“蜘蛛子”模组的第一版。",
    },
    SKIN_QUOTES = {
        shiro = nil,
        wakaba = nil,
        shiro_jk = "如同记忆里的一般, 尽管那是虚假的。",
        shiro_classic = "我的那些能力都去哪了?",
    },
}
