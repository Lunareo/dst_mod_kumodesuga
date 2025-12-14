local _GLOBAL, _env, _tenv = GLOBAL, env, {}
setfenv(1, _tenv)
---constants
EQUIPSLOTS = {
    SPELL = "spell",
}
------------
_env.merge(_GLOBAL, _tenv)
_GLOBAL.setfenv(1, _env)