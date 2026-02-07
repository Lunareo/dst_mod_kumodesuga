local ICON_SCALE = 0.6
local spells_common = require "prefabs/spells_common"
local AutoToggleWidget, AbsorbSingleTargetSkill = spells_common.AutoToggleWidget, spells_common.AbsorbSingleTargetSkill

---@class ThePlayer
---@field _toggle_nightvision netvar|nil

local function isNightVisionActivated()
    return ThePlayer and ThePlayer.components.nightvision and ThePlayer.components.nightvision.update:value()
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
        doer:AddDebuff("health_penalty_reduction", "buff_health_penalty_reduction",
            { regentick = 30, regenval = penalty / 30 })
    end,
    curse = function(target, doer)
        target:AddDebuff("curse", "buff_curse", { doer = doer })
    end,
}

local allskills = {
    {
        label = STRINGS.SPELLS.TOGGLENIGHTVISION,
        onselect = function(inst)
            inst.components.spellbook.closeonexecute = false
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
        _validtest = function(inst)
            return inst and inst.components.skilltreeupdater:IsActivated("vision_enhance")
        end,
    },
    AbsorbSingleTargetSkill {
        name = "freeze",
        spellfn = SPELL_FNS.freeze,
        cost = TUNING.SPELL_FREEZE_COST,
    },
    AbsorbSingleTargetSkill {
        name = "curse",
        spellfn = SPELL_FNS.curse,
        cost = TUNING.SPELL_CURSE_COST,
    },
    AbsorbSingleTargetSkill {
        name = "destruction",
        spellfn = SPELL_FNS.destruction,
        cost = TUNING.SPELL_DESTRUCTION_COST,
    },
}

return function(inst)
    local skills = {}
    for k, v in ipairs(allskills) do
        if not v._validtest or v._validtest(inst) then
            skills[#skills + 1] = v
        end
    end
    return skills
end
