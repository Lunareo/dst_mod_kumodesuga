local ICON_SCALE = 0.6
local spells_common = require "prefabs/spells_common"
local AutoToggleWidget, AbsorbSingleTargetSkill = spells_common.AutoToggleWidget, spells_common.AbsorbSingleTargetSkill

---@class ThePlayer
---@field _toggle_nightvision netvar|nil

local function isNightVisionActivated()
    return ThePlayer and ThePlayer.components.nightvision and ThePlayer.components.nightvision.update:value()
end

local function decreasepenalty(params)
    local inst, penalty = params.inst, params.penalty
    if not (inst and inst:IsValid() and penalty) then return end
    for t = 0, 30 do
        Sleep(1)
        inst.components.health:DeltaPenalty(-penalty / 30)
    end
end
local SPELL_FNS = {
    freeze = function(target, doer)
        target:AddDebuff("freeze", "buff_freeze", { doer = doer })
    end,
    gravity = function(target, doer)
        local sh = SpawnAt("daywalker_sinkhole", target)
        if sh then sh:DoTaskInTime(5, sh.Remove) end
    end,
    destruction = function(target, doer)
        if not (target and target.components.combat and doer and doer:IsValid() and doer.components.health) then return end
        local base = doer.components.health.currenthealth * .9
        target.components.combat:GetAttacked(doer, base * 10, nil, "spell_destruction")
        doer.components.health:DoDelta(-base, 10, "spell_destruction", nil, doer)
        local penalty = doer.components.health.penalty or 0
        doer.components.health:DeltaPenalty(doer.components.health:GetMaxWithPenalty() * .9)
        penalty = doer.components.health.penalty - penalty
        doer._recover_from_destruction = StartThread(decreasepenalty, doer.GUID, { inst = doer, penalty = penalty })
    end
}

return {
    {
        label = STRINGS.SPELLS.TOGGLENIGHTVISION,
        onselect = function(inst)
            inst.components.spellbook.closeonexecute = false
            --if TheWorld.ismastersim then -- useless, maybe
            --    if inst.components.spellbookcooldowns ~= nil then
            --        inst.components.spellbookcooldowns:RestartSpellCooldown("togglenightvision", 5)
            --    end
            --end
        end,
        execute = function(inst)
            SendModRPCToServer(GetModRPC("kmds.skills", "skills.updating"), hash("nightvision"))
        end,
        bank = "spell_icons_woby",
        build = "spell_icons_woby",
        anims =
        {
            idle = { anim = "working" },
            focus = { anim = "working_focus" },
            down = { anim = "working_pressed" },
        },
        widget_scale = ICON_SCALE,
        postinit = AutoToggleWidget(isNightVisionActivated),
        checkcooldown = function(user)
            --client safe
            return user
                and user.components.spellbookcooldowns
                and user.components.spellbookcooldowns:GetSpellCooldownPercent("togglenightvision")
                or nil
        end,
        cooldowncolor = { 0.65, 0.65, 0.65, 0.75 },
    },
    AbsorbSingleTargetSkill {
        name = "freeze",
        spellfn = SPELL_FNS.freeze,
    },
    {
        label = STRINGS.SPELLS.GRAVITY,
        onselect = function(inst)
            inst.components.spellbook.closeonexecute = false
        end,
    },
    AbsorbSingleTargetSkill {
        name = "destruction",
        spellfn = SPELL_FNS.destruction,
    },
}
