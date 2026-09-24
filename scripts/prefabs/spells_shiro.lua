local ICON_RADIUS = 60
local ICON_SCALE = 0.6
local UIAnim = require "widgets/uianim"
local Image = require "widgets/image"
local spells_common = require "prefabs/spells_common"
local AbsorbSingleTargetSkill = spells_common.AbsorbSingleTargetSkill
local PointAOESkill = spells_common.PointAOESkill
local ConeAOESkill = spells_common.ConeAOESkill

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
                local anim = data and data.anim and
                    (data.anim .. (w.animstate:IsCurrentAnimation(data.anim) and "" or "_focus") .. "_casting") or
                    "visual_enhance_casting"
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

--- 客户端安全：rider 的 replica 会同步服务端的骑乘状态。
---@param inst ent
---@return boolean|nil
local function IsRiding(inst)
    if inst == nil then
        return false
    end
    local replica = inst.replica ~= nil and inst.replica.rider or nil
    if replica ~= nil then
        return replica:IsRiding()
    end
    local rider = inst.components ~= nil and inst.components.rider or nil
    return rider ~= nil and rider:IsRiding()
end

local SPELL_FNS = {
    freeze = function(target, doer)
        SpawnAt("fx_book_sleep", target)
        target:AddDebuff("freeze", "buff_freeze", { doer = doer })
    end,
    gravity = function(pos, doer)
        local field = CreateEntity()
        field.entity:AddTransform()
        field.entity:AddAnimState()
        field.entity:AddNetwork()
        field.AnimState:SetBank("sinkhole")
        field.AnimState:SetBuild("antlion_sinkhole")
        field.AnimState:PlayAnimation("cracks_pre1")
        field.Transform:SetPosition(pos.x, 0, pos.z)
        field:AddTag("FX")
        field:AddTag("NOCLICK")
        field.persists = false

        if not TheWorld.ismastersim then return end

        local ents = TheSim:FindEntities(pos.x, 0, pos.z, 3)
        for _, ent in ipairs(ents) do
            if ent ~= doer and ent:IsValid() and not ent:IsInLimbo() and ent.components.workable ~= nil then
                local action = ent.components.workable:GetWorkAction()
                if action == ACTIONS.CHOP or action == ACTIONS.MINE then
                    if not (ent:HasTag("structure") or ent:HasTag("wall") or ent:HasTag("chest")) then
                        ent.components.workable:Destroy(doer)
                    end
                end
            end
        end

        local affected = {}
        field:DoPeriodicTask(0.25, function()
            local current = {}
            local targets = TheSim:FindEntities(pos.x, 0, pos.z, 3, { "_combat" }, { "INLIMBO", "player", "companion", "playerghost", "wall" })
            for _, t in ipairs(targets) do
                if t:IsValid() and t.components.locomotor ~= nil and not (t.components.follower and t.components.follower:GetLeader() and t.components.follower:GetLeader():HasTag("player")) then
                    current[t] = true
                    t.components.locomotor:SetExternalSpeedMultiplier(t, "gravity_slow", 0.5)
                end
            end
            for t in pairs(affected) do
                if not current[t] and t:IsValid() and t.components.locomotor ~= nil then
                    t.components.locomotor:RemoveExternalSpeedMultiplier(t, "gravity_slow")
                end
            end
            affected = current
        end)

        field:ListenForEvent("onremove", function()
            for t in pairs(affected) do
                if t:IsValid() and t.components.locomotor ~= nil then
                    t.components.locomotor:RemoveExternalSpeedMultiplier(t, "gravity_slow")
                end
            end
        end)

        field:DoTaskInTime(5, function()
            if field:IsValid() then field:Remove() end
        end)
    end,
    hypnosis = function(pos, doer)
        local doer_pos = doer:GetPosition()
        local facing = (pos - doer_pos):Normalize()
        local ents = TheSim:FindEntities(doer_pos.x, 0, doer_pos.z, 8, { "_combat" }, { "INLIMBO", "player", "companion", "playerghost", "wall" })
        for _, ent in ipairs(ents) do
            if ent ~= doer and ent:IsValid() and not (ent.components.follower and ent.components.follower:GetLeader() and ent.components.follower:GetLeader():HasTag("player")) then
                local dir = (ent:GetPosition() - doer_pos):Normalize()
                local dot = facing.x * dir.x + facing.z * dir.z
                if dot >= 0.5 then
                    SpawnAt("fx_book_sleep", ent)
                    if ent.components.sleeper ~= nil then
                        ent.components.sleeper:AddSleepiness(10, 10)
                    elseif ent.components.grogginess ~= nil then
                        ent.components.grogginess:AddGrogginess(10, 10)
                    end
                end
            end
        end
    end,
    destruction = function(target, doer)
        if not (target and target.components.combat and doer and doer:IsValid() and doer.components.health) then return end
        if doer.components.health.currenthealth < 10 then return end
        local base = doer.components.health.currenthealth * .9
        doer.components.health:DoDelta(-base, false, "spell_destruction", nil, doer)
        target.components.combat:GetAttacked(doer, 0, nil, "spell_destruction", { erosion = base * 10 })
        SpawnAt("wanda_attack_pocketwatch_old_fx", target)
        SpawnAt("erosion_fx_loop", target)
    end,
    curse = function(target, doer)
        SpawnAt("monkey_morphin_power_players_fx", target)
        target:AddDebuff("curse", "buff_curse", { doer = doer })
    end,
    desidiae = function(target, doer)
        SpawnAt("erosion_fx_loop", target)
        target:AddDebuff("desidiae", "buff_desidiae", { doer = doer })
    end,
}

local allskills = {
    --{
    --    label = STRINGS.SPELLS.TOGGLENIGHTVISION,
    --    onselect = function(inst)
    --        if inst.components.spellbook ~= nil then
    --            inst.components.spellbook.closeonexecute = false
    --        end
    --    end,
    --    execute = function(inst)
    --        SendModRPCToServer(GetModRPC("kmds.skills", "skills.updating"), hash("nightvision"))
    --    end,
    --    bank = "spell_icons_shiro",
    --    build = "spell_icons_shiro",
    --    anims =
    --    {
    --        idle = { anim = "visual_enhance" },
    --        focus = { anim = "visual_enhance_focus", loop = true },
    --        down = { anim = "visual_enhance" },
    --    },
    --    widget_scale = ICON_SCALE,
    --    postinit = AutoToggleWidget(isNightVisionActivated, { build = "spell_icons_shiro", anim = "visual_enhance" }),
    --    _validtest = function(inst)
    --        return inst and inst.components.skilltreeupdater and inst.components.skilltreeupdater:IsActivated("vision_enhance")
    --    end,
    --},
    AbsorbSingleTargetSkill {
        name = "freeze",
        bank = "spell_icons_shiro",
        build = "spell_icons_shiro",
        anims = {
            idle = { anim = "eye_of_freeze" },
            focus = { anim = "eye_of_freeze_focus", loop = true },
            down = { anim = "eye_of_freeze" },
            disabled = { anim = "eye_of_freeze_disabled" },
            cooldown = { anim = "eye_of_freeze_disabled" },
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
            disabled = { anim = "eye_of_curse_disabled" },
            cooldown = { anim = "eye_of_curse_disabled" },
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
            disabled = { anim = "eye_of_destroy_disabled" },
            cooldown = { anim = "eye_of_destroy_disabled" },
        },
        spellfn = SPELL_FNS.destruction,
        can_cast_fn = function(doer)
            return doer.components.health ~= nil and doer.components.health.currenthealth >= 10
        end,
        cost = TUNING.SPELL_DESTRUCTION_COST,
    },
    PointAOESkill {
        name = "gravity",
        bank = "spell_icons_shiro",
        build = "spell_icons_shiro",
        anims = {
            idle = { anim = "eye_of_curse" },
            focus = { anim = "eye_of_curse_focus", loop = true },
            down = { anim = "eye_of_curse" },
            disabled = { anim = "eye_of_curse_disabled" },
            cooldown = { anim = "eye_of_curse_disabled" },
        },
        spellfn = SPELL_FNS.gravity,
        cost = TUNING.SPELL_GRAVITY_COST,
        range = 16,
        radius = 3,
    },
    ConeAOESkill {
        name = "hypnosis",
        bank = "spell_icons_shiro",
        build = "spell_icons_shiro",
        anims = {
            idle = { anim = "eye_of_freeze" },
            focus = { anim = "eye_of_freeze_focus", loop = true },
            down = { anim = "eye_of_freeze" },
            disabled = { anim = "eye_of_freeze_disabled" },
            cooldown = { anim = "eye_of_freeze_disabled" },
        },
        spellfn = SPELL_FNS.hypnosis,
        cost = TUNING.SPELL_HYPNOSIS_COST,
        range = 8,
    },
    AbsorbSingleTargetSkill {
        name = "desidiae",
        bank = "spell_icons_shiro",
        build = "spell_icons_shiro",
        anims = {
            idle = { anim = "eye_of_curse" },
            focus = { anim = "eye_of_curse_focus", loop = true },
            down = { anim = "eye_of_curse" },
            disabled = { anim = "eye_of_curse_disabled" },
            cooldown = { anim = "eye_of_curse_disabled" },
        },
        spellfn = SPELL_FNS.desidiae,
        cost = TUNING.SPELL_DESIDIAE_COST or 15,
        _validtest = function(inst)
            return inst and inst.components.skilltreeupdater and inst.components.skilltreeupdater:IsActivated("desidiae")
        end,
    },
    {
        label = STRINGS.SPELLS.OPEN_SPACE_PROXY,
        onselect = function(inst)
            if inst.components.spellbook ~= nil then
                inst.components.spellbook:SetSpellName(STRINGS.SPELLS.OPEN_SPACE_PROXY)
                inst.components.spellbook.closeonexecute = true
            end
        end,
        execute = function(inst)
            SendModRPCToServer(GetModRPC("kmds.spells", "spells.open_space_proxy"))
        end,
        bank = "spell_icons_shiro",
        build = "spell_icons_shiro",
        anims =
        {
            idle = { anim = "space_proxy" },
            focus = { anim = "space_proxy_focus", loop = true },
            down = { anim = "space_proxy" },
        },
        widget_scale = ICON_SCALE,
        postinit = SetupMouseOver,
        default_focus = true,
        _validtest = function(inst)
            return inst and inst.components.skilltreeupdater and inst.components.skilltreeupdater:IsActivated("spacemagic_1")
        end,
    },
    {
        label = STRINGS.SPELLS.CREATE_CLONE,
        onselect = function(inst)
            if inst.components.spellbook ~= nil then
                inst.components.spellbook:SetSpellName(STRINGS.SPELLS.CREATE_CLONE)
                inst.components.spellbook.closeonexecute = true
            end
        end,
        execute = function(inst)
            SendModRPCToServer(GetModRPC("kmds.spells", "spells.create_clone"))
        end,
        bank = "spell_icons_shiro",
        build = "spell_icons_shiro",
        anims = {
            idle = { anim = "space_proxy" },
            focus = { anim = "space_proxy_focus", loop = true },
            down = { anim = "space_proxy" },
        },
        widget_scale = ICON_SCALE,
        postinit = SetupMouseOver,
    },
    {
        -- 仅骑乘时出现；图标复用原版 woby 指令盘的 mount 系列动画。
        label = STRINGS.ACTIONS.DISMOUNT,
        onselect = function(inst)
            if inst.components.spellbook ~= nil then
                inst.components.spellbook:SetSpellName(STRINGS.ACTIONS.DISMOUNT)
                inst.components.spellbook.closeonexecute = true
            end
        end,
        execute = function(inst)
            SendModRPCToServer(GetModRPC("kmds.spells", "spells.dismount"))
        end,
        bank = "spell_icons_woby",
        build = "spell_icons_woby",
        anims =
        {
            idle = { anim = "mount" },
            focus = { anim = "mount_focus" },
            down = { anim = "mount_pressed" },
        },
        widget_scale = ICON_SCALE,
        postinit = SetupMouseOver,
        _validtest = IsRiding,
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
