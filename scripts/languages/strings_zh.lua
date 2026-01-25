STRINGS = {
    ACTIONS = {
        PARRY = "闪避",
        CASTAOE = {
            SPIDERSCYTHE = "横扫",
        },
        USESPELLBOOK = {
            CASTSPELL = nil,
        },
    },
    CHARACTERS = {
        GENERIC = {
            ACTIONFAIL = {
                CASTAOE = {
                    SPELL_NOT_ENOUGH_COST = "施放这个法术需要更多的魔力!",
                },
            },
            ANNOUNCE_ATTACH_BUFF_HEALTH_PENALTY_REDUCTION = nil,
            DESCRIBE = {
                ARAMASA = nil,
                CHIPS = "酥脆可口的小零食。",
                KURIKUTA_DRIED = "味道很好的干果。",
                SHIRO = "她真好看。",
                SILK_ROBE = "坚韧但不厚重, 丝滑但不透凉。",
                WAKABA = "她真好看。",
            },
        },
        SHIRO = {
            ACTIONFAIL = {
                CASTAOE = {
                    SPELL_ON_COOLDOWN = "魔导大师也需要一些冷却时间。",
                },
            },
            ANNOUNCE_ATTACH_BUFF_HEALTH_PENALTY_REDUCTION = "这一记对我的眼睛造成了巨大的伤害, 我需要一些时间来恢复...",
            ANNOUNCE_DETACH_BUFF_HEALTH_PENALTY_REDUCTION = "我感觉好多了.",
            DESCRIBE = {
                CHIPS = "没想到在这里也能吃到这个。",
                KURIKUTA_DRIED = "比起有毒魔物的肉, 这个已经非常不错了。",
                SHIRO = "%s, 你是我的替身吗?",
                SILK_ROBE = "由千锤百炼的织丝技能制作而成, 比一般的布料耐用得多。",
                SPIDERSCYTHE = "有一种亲近的感觉。",
                WAKABA = nil,
            },
        },
        WAKABA = {
            ACTIONFAIL = {
                CASTAOE = {
                    SPELL_ON_COOLDOWN = "稍作限制能让游戏变得更有趣。",
                },
            },
            DESCRIBE = {
                CHIPS = "不必担心发胖，这个身躯是完美的。",
                HELHEIM_BEYONDER = nil,
                SHIRO = "",
                SPIDERSCYTHE = "希望她喜欢这个礼物。",
                WAKABA = "拙劣的模仿。",
            },
        },
    },
    CHARACTER_DESCRIPTIONS = {
        shiro = "*身份神秘的少女\n*不善于表达\n*不要让她接触酒精",
        wakaba = "*沉默寡言的JK\n*没有共情的能力\n*很擅长电子游戏\n*(这也是游戏的一部分)",
    },
    CHARACTER_NAMES = {
        shiro = "白",
        wakaba = "若叶姬色",
    },
    CHARACTER_QUOTES = {
        shiro = nil,
        wakaba = nil,
    },
    CHARACTER_SURVIVABILITY = {
        shiro = STRINGS.CHARACTER_SURVIVABILITY.wilson,
        wakaba = STRINGS.CHARACTER_SURVIVABILITY.wanda,
    },
    CHARACTER_TITLES = {
        shiro = "神之替身",
        wakaba = "神之化身",
    },
    INSIGHT_DESC = {
        ARAMASA = "攻击造成8次伤害",
    },
    NAMES = {
        ABYSSDAMAGE = "<color=#221356>外道伤害</color>: <color=#221356>%2.1d</color>",
        ABYSSDEFENSE = "<color=#221356>外道抗性</color>: <color=#221356>%2.1d</color>",
        ARACHNECURSE = "蜘蛛女郎的诅咒",
        ARAMASA = "天羽羽斩",
        BUFF_CURSE = "诅咒",
        BUFF_CURSE_REGEN = "再生",
        BUFF_EROSION = "腐蚀",
        BUFF_FREEZE = "冻结",
        CHIPS = "薯片",
        DECREASE_HUNGER = "饥饿度",
        EROSION = "腐蚀",
        EROSIONDAMAGE = "<color=#451758>腐蚀伤害</color>: <color=#451758>%2.1d</color>",
        EROSIONDEFENSE = "<color=#451758>腐蚀抗性</color>: <color=#451758>%2.1d</color>",
        HALF_SANITY_VAL = nil,
        HELHEIM_BEYONDER = "超越冥界",
        KUMO_ATK_STEALER = "攻击窃取",
        KUMO_OVERSATURATE = "吃撑了",
        KUMO_SATURATE = "饱足",
        KURIKUTA_DRIED = "干燥库利库塔果实",
        SHIRO = "白织",
        SILK_ROBE = "丝质长袍",
        SPIDERSCYTHE = "阿剌克涅",
        SPIDERSCYTHE_SHIRO = "蜘蛛大镰刀",
        STORING_SPACE = "储物空间",
        STORING_SPACE_DTOR = "解除储物空间",
        WAKABA = "若叶姬色",
    },
    RECIPE_DESC = {
        ARAMASA = "一位创世者的手套的仿品。",
        HELHEIM_BEYONDER = nil,
        SILK_SHIRO = "蜘蛛型魔物的基本功。",
        SPIDERSCYTHE = "传说级蜘蛛魔物的前腿制作的武器。",
        STORING_SPACE = "对空间魔术的娴熟应用。",
    },
    SKILLTREE = {
        SHIRO = {},
    },
    SKIN_DESCRIPTIONS = {
        shiro = "她看似弱不禁风\n实则拥有摧枯拉朽的力量。",
        shiro_classic = "来自“蜘蛛子”模组的第一版。",
        shiro_jk = "",
        wakaba = "神造人偶。",
    },
    SKIN_NAMES = {
        shiro = "白色死神",
        shiro_classic = "蜘蛛子",
        shiro_jk = "返校日",
        wakaba = "返校日",
    },
    SKIN_QUOTES = {
        shiro = nil,
        shiro_classic = "我的那些能力都去哪了?",
        shiro_jk = "如同记忆里的一般, 尽管那是虚假的。",
        wakaba = nil,
    },
    SPELLS = {
        TOGGLENIGHTVISION = "锐利目光",
        EVIL_EYES = {
            CURSE = string.format("诅咒之邪眼(%d理智)", TUNING.SPELL_CURSE_COST),
            DESTRUCTION = string.format("腐蚀之邪眼(%d理智)", TUNING.SPELL_DESTRUCTION_COST),
            EROSION = string.format("腐蚀之邪眼(%d理智)", TUNING.SPELL_EROSION_COST),
            FREEZE = string.format("静止之邪眼(%d理智)", TUNING.SPELL_FREEZE_COST),
            GRAVITY = string.format("引斥之邪眼(%d理智)", TUNING.SPELL_GRAVITY_COST),
            TWIST = string.format("歪曲之邪眼(%d理智)", TUNING.SPELL_TWIST_COST),
        },
    },
    UI = {
        HUD = {
            DEATH_ANNOUNCEMENT_WAKABA = {
                [1] = "%s 的扮演游戏结束了! 她的躯体回归了冥界.",
                [2] = "%s 的扮演游戏结束了! 她的躯体被摧毁了.",
            },
            REZ_ANNOUNCEMENT_WAKABA = {
                [1] = "借由 %s 之手, %s 得以再次降临永恒领域."
            },
        },
    },
}
local strs = env.STRINGS
rawset(env, "STRINGS", nil)
return strs
