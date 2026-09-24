TUNING = {
    BUFF = {
        CURSE_ATK_STEAL_MULT = .5,
    },
    DRUNK_KEYS = {
        "liquor", "wine", "酒",
    },
    DRUNKEN_MODI = {
        COMBAT = 2,      -- 全伤害提升100% (2倍)
        GROGGY = 30,     -- 醉酒暴走持续30秒
        SPEED = 1.15,    -- 移速+15%
        SLEEP = 5,       -- 醒酒后昏睡5秒
        SLEEPINESS = 10, -- 一次性灌入的醉倒值，需高于目标的 grogginess 抗性
        HANGOVER = 60,   -- 宿醉衰弱60秒
    },
    SHIRO_HEALTH = 75,
    SHIRO_HUNGER = 180,
    SHIRO_SANITY = 150,
    SHIRO_MAGICPOINT = 150,
    SHIRO_HUNGERY_SPEED_MULT = .7,
    SHIRO_STARVING_SANITY_RATE = 1.25, -- 每秒独立流失的理智，默认与原版饥饿伤害速率相同
    WAKABA_HEALTH = 60,
    WAKABA_OLDAGER = 12,
    WAKABA_HEALTH_SCALE = .1, -- WAKABA_OLDAGER / 120
    WAKABA_HUNGER = 100,
    WAKABA_SANITY = 200,
    WAKABA_MIN_YEARS_OLD = 13,
    WAKABA_MAX_YEARS_OLD = 25,
    WAKABA_OLDAGE_RECOVER_RATE = 1 / 40,
    ARIEL_HEALTH = 300,
    ARIEL_HUNGER = 250,
    ARIEL_SANITY = 200,
    ARIEL_HUNGER_RATE_MULT = 1.5, -- 巨大食量负荷：饥饿消耗为普通角色 1.5 倍
    ARIEL = require "ariel_tuning",
    BEYONDER_USES = 200,
    BEYONDER_RANGE = 10,
    BEYONDER_BASE_DMG = 42.5,
    BEYONDER_EROSION_DMG = 8.5,
    CHARACTER_DETAILS_OVERRIDE = {
        shiro_sanity = "magicpoint",
        wakaba_health = "oldager",
    },
    GAMEMODE_STARTING_ITEMS = {
        DEFAULT = {
            SHIRO = { "spiderscythe", "silk", "silk", "silk", },
            WAKABA = { "helheim_beyonder" },
            ARIEL = {},
        },
    },
    MIGHTY_STRIKE_MULT = 3,
    SKILLS = {
        SHIRO_ALLEGIANCE_LUNAR_RESIST = .75,
        SHIRO_ALLEGIANCE_SHADOW_RESIST = .75,
        SHIRO_ALLEGIANCE_VS_LUNAR_BONUS = 1.25,
        SHIRO_ALLEGIANCE_VS_SHADOW_BONUS = 1.25,
    },
    SPIDER_SCYTHE_ATK_RANGE = 1,
    SPIDER_SCYTHE_BASE_DMG = 34,
    SPIDER_SCYTHE_DAPPER = GLOBAL.TUNING.CRAZINESS_MED,
    SPIDER_SCYTHE_EROSION_DMG = 17,
    SPIDER_SCYTHE_HP_DRAIN_RT = 2.5,
    SPIDER_SCYTHE_REPAIR_RT = .7,
    SPIDER_SCYTHE_SP_COST_RT = -1,
    SPIDER_SCYTHE_THN_DMG = -.5,
    SPIDER_SCYTHE_USES = 200,
    SPELL_FREEZE_COOLDOWN = 3,
    SPELL_FREEZE_COST = 5,
    SPELL_CURSE_COOLDOWN = nil,
    SPELL_CURSE_COST = 10,
    SPELL_EROSION_COOLDOWN = nil,
    SPELL_EROSION_COST = 10,
    SPELL_TWIST_COOLDOWN = 3,
    SPELL_TWIST_COST = 10,
    SPELL_GRAVITY_COOLDOWN = nil,
    SPELL_GRAVITY_COST = 10,
    SPELL_HYPNOSIS_COOLDOWN = 20,
    SPELL_HYPNOSIS_COST = 20,
    SPELL_DESTRUCTION_COOLDOWN = GLOBAL.TUNING.SEG_TIME * 4,
    SPELL_DESTRUCTION_COST = 100,
    SPELL_DESIDIAE_COOLDOWN = nil,
    SPELL_DESIDIAE_COST = 15,
}
merge(GLOBAL.TUNING, env.TUNING, true)
rawset(env, "TUNING", nil)