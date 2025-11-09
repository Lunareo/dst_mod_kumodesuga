local Parry = AddAction(
    "PARRY",
    STRINGS.ACTIONS.PARRY,
    function(act)
        local inst = act.doer
        if inst ~= nil and inst.components.parryable then
            inst.components.parryable:Parry()
            return true
        end
        return false
    end
)

Parry.priority = 10
Parry.rmb = true
Parry.distance = 36
Parry.mount_valid = false

local parryhandler = ActionHandler(Parry, "doshortaction")

AddStategraphActionHandler("wilson", parryhandler)
AddStategraphActionHandler("wilson_client", parryhandler)

UTIL.FnExtend(ACTIONS.USESPELLBOOK, "strfn", nil, function(rets, act)
    if act.doer and act.doer.components.spellbook and act.doer == act.target then
        rets = { "CASTSPELL" }
    end
    return rets
end)