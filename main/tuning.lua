merge(TUNING, {
    SHIRO_HEALTH = 120,
    SHIRO_HUNGER = 180,
    SHIRO_SANITY = 150,
    WAKABA_HEALTH = 60,
    WAKABA_OLDAGER = 12,
    WAKABA_HEALTH_SCALE = .1, -- WAKABA_OLDAGER / 120
    WAKABA_HUNGER = 100,
    WAKABA_SANITY = 200,
    WAKABA_MIN_YEARS_OLD = 13,
    WAKABA_MAX_YEARS_OLD = 25,
    WAKABA_OLDAGE_RECOVER_RATE = 1 / 40,
    CHARACTER_DETAILS_OVERRIDE = {
        wakaba_health = "oldager",
    },
    GAMEMODE_STARTING_ITEMS = {
        DEFAULT = {
            SHIRO = { "spiderscythe" },
            WAKABA = { "helheim_beyonder" },
        },
    },
}, true)
