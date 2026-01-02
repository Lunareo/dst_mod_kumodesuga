local _GLOBAL, _env, _tenv = GLOBAL, env, {}
setfenv(1, _tenv)
---constants
EQUIPSLOTS = {
    SPELL = "spell",
}

CHARACTER_INGREDIENT = {
    HUNGER = "decrease_hunger",
    MAX_SANITY_VAL = "half_sanity_val",
}
------------
_env.merge(_GLOBAL, _tenv)
_GLOBAL.setfenv(1, _env)