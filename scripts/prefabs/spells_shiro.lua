local ICON_RADIUS = 60
local ICON_SCALE = 0.6
local UIAnim = require "widgets/uianim"
local Image = require "widgets/image"
local spells_common = require "prefabs/spells_common"
local AbsorbSingleTargetSkill = spells_common.AbsorbSingleTargetSkill

local function SetupMouseOver(w)
    --V2C: using Image widget for mouseover hitbox, since anim hitbox is not accurate
    w.uianim:SetClickable(false)
    w.mouseover = w:AddChild(Image())
    w.mouseover:SetRadiusForRayTraces(ICON_RADIUS)
    w.mouseover:MoveToBack()
end

local function AutoToggleWidget(fn, data)
    return function(w)
        SetupMouseOver(w)
        w.spark = w:AddChild(UIAnim())
        w.spark:GetAnimState():SetBank(data and data.bank or data.build)
        w.spark:GetAnimState():SetBuild(data and data.build)
        w.spark:GetAnimState():PlayAnimation(data and data.anim, true)
        w.spark.OnUpdate = function(ring, dt)
            if fn() then
                local anim = data and data.anim
                if not ring:GetAnimState():IsCurrentAnimation(anim) then
                    local frame = ring:GetAnimState():GetCurrentAnimationFrame()
                    ring:GetAnimState():PlayAnimation(anim, true)
                    ring:GetAnimState():SetFrame(frame)
                end
                ring:Show()
                w.overrideclicksound = "dontstarve/HUD/toggle_off"
            else
                ring:Hide()
                w.overrideclicksound = "dontstarve/HUD/toggle_on"
            end
        end
        w.OnShow = function(_w)
            _w.spark:StartUpdating()
        end
        w.OnHide = function(_w)
            _w.spark:StopUpdating()
        end
        if w.shown then
            w.spark:StartUpdating()
            w.spark:OnUpdate(0)
        end
    end
end

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
        bank = "spell_icons_shiro",
        build = "spell_icons_shiro",
        anims =
        {
            idle = { anim = "visual_enhance" },
            focus = { anim = "visual_enhance_focus", loop = true },
            down = { anim = "visual_enhance" },
        },
        widget_scale = ICON_SCALE,
        postinit = AutoToggleWidget(isNightVisionActivated, { build = "spell_icons_shiro", anim = "visual_enhance_casting" }),
        _validtest = function(inst)
            return inst and inst.components.skilltreeupdater:IsActivated("vision_enhance")
        end,
    },
    AbsorbSingleTargetSkill {
        name = "freeze",
        bank = "spell_icons_shiro",
        build = "spell_icons_shiro",
        anims = {
            idle = { anim = "eye_of_freeze" },
            focus = { anim = "eye_of_freeze_focus", loop = true },
            down = { anim = "eye_of_freeze" },
        },
        spellfn = SPELL_FNS.freeze,
        cost = TUNING.SPELL_FREEZE_COST,
    },
    AbsorbSingleTargetSkill {
        name = "curse",
        bank = "spell_icons_shiro",
        build = "spell_icons_shiro",
        anims = {
            idle = { anim = "eye_of_curse" },
            focus = { anim = "eye_of_curse_focus", loop = true },
            down = { anim = "eye_of_curse" },
        },
        spellfn = SPELL_FNS.curse,
        cost = TUNING.SPELL_CURSE_COST,
    },
    AbsorbSingleTargetSkill {
        name = "destruction",
        bank = "spell_icons_shiro",
        build = "spell_icons_shiro",
        anims = {
            idle = { anim = "eye_of_destroy" },
            focus = { anim = "eye_of_destroy_focus", loop = true },
            down = { anim = "eye_of_destroy" },
        },
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
