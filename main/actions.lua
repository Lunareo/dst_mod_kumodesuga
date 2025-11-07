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


local Spell = AddAction(
    "SPELL",
    STRINGS.ACTIONS.CASTAOE.GENERIC,
    function(act)
        return true
    end
)

Spell.pre_action_cb = function(act)
    local inst = act.doer
    if inst ~= nil and inst.components.spelluser then
        inst.components.spelluser:ActivateSpellItem()
    end
end
Spell.priority = 10
Spell.rmb = true
Spell.distance = 36
Spell.mount_valid = false

local UnSpell = AddAction(
    "UNSPELL",
    STRINGS.UI.HUD.CANCEL,
    function(act)
        return true
    end
)

UnSpell.pre_action_cb = function(act)
    local inst = act.doer
    if inst ~= nil and inst.components.spelluser then
        inst.components.spelluser:DeactivateSpellItem()
    end
end
UnSpell.priority = 10
UnSpell.rmb = true
UnSpell.distance = 36
UnSpell.mount_valid = false
