local UIAnim = require "widgets/uianim"
local Image = require "widgets/image"
local ICON_RADIUS = 60
local ICON_SCALE = 0.6

local function SetupMouseOver(w)
    --V2C: using Image widget for mouseover hitbox, since anim hitbox is not accurate
    w.uianim:SetClickable(false)
    w.mouseover = w:AddChild(Image())
    w.mouseover:SetRadiusForRayTraces(ICON_RADIUS)
    w.mouseover:MoveToBack()
end

local function AutoToggleWidget(fn)
    return function(w)
        SetupMouseOver(w)
        w.ring = w:AddChild(UIAnim())
        w.ring:GetAnimState():SetBank("spell_icons_woby")
        w.ring:GetAnimState():SetBuild("spell_icons_woby")
        w.ring:GetAnimState():PlayAnimation("autocast_ring", true)
        w.ring.OnUpdate = function(ring, dt)
            if fn() then
                local anim = "autocast_ring"
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
            _w.ring:StartUpdating()
        end
        w.OnHide = function(_w)
            _w.ring:StopUpdating()
        end
        if w.shown then
            w.ring:StartUpdating()
            w.ring:OnUpdate(0)
        end
    end
end

local function StartAOETargeting(inst)
    local playercontroller = ThePlayer.components.playercontroller
    if playercontroller ~= nil then
        playercontroller:StartAOETargetingUsing(inst)
    end
end

local function ReticuleTargetFn(inst)
    return Vector3(ThePlayer.entity:LocalToWorldSpace(7, 0.001, 0)) -- Raised this off the ground a touch so it wont have any z-fighting with the ground biome transition tiles.
end

---@class skill_def_partial
---@field name string
---@field bank string|nil
---@field build string|nil
---@field anims table|nil
---@field spellfn fun(target, doer)|(nil)
---@field cost integer|nil

local CREATURES_MUST = { "_combat" }
local CREATURES_CAN  = { "monster", "smallcreature", "largecreature", "animal", "bigbernie", "character" }
local CREATURES_CANT = { "INLIMBO", "flight", "player", "ghost", "invisible", "noattack", "notarget" }

local function TryConsumeCost(doer, cost)
    if cost == nil then return true end
    if doer.components.sanity and doer.components.sanity.current >= cost then
        doer.components.sanity:DoDelta(-cost)
        return true
    else
        return false
    end
end

---@param data skill_def_partial
---@return table
local function AbsorbSingleTargetSkill(data)
    local spellfn = function(inst, doer, pos)
        if not TryConsumeCost(doer, data and data.cost) then
            return false, "SPELL_NOT_ENOUGH_COST"
        end
        if doer.components.spellbookcooldowns ~= nil and doer.components.spellbookcooldowns:IsInCooldown(data.name) then
            return false, "SPELL_ON_COOLDOWN"
        end
        local target = FindClosestEntityInPoint(pos, 4, nil, CREATURES_MUST, CREATURES_CANT)
        if target ~= nil then
            data.spellfn(target, doer)
            local cooldown = TUNING["SPELL_" .. string.upper(data.name) .. "_COOLDOWN"]
            if doer.components.spellbookcooldowns ~= nil and cooldown ~= nil then
                doer.components.spellbookcooldowns:RestartSpellCooldown(data.name, cooldown)
            end
        end
        return true
    end
    return {
        label = STRINGS.SPELLS.EVIL_EYES[string.upper(data.name)],
        onselect = function(inst)
            local spellbook = inst.components.spellbook
            spellbook:SetSpellName(STRINGS.SPELLS.EVIL_EYES[string.upper(data.name)])
            inst.spellname = data.name
            spellbook:SetSpellAction(nil)
            local aoetargeting = inst.components.aoetargeting
            aoetargeting:SetRange(16)
            aoetargeting:SetDeployRadius(0)
            aoetargeting:SetShouldRepeatCastFn(function(_, doer)
                return
                    doer.components.spellbookcooldowns == nil or
                    doer.components.spellbookcooldowns:IsInCooldown(data.name)
            end)
            aoetargeting.reticule.reticuleprefab = "reticuleabsorb"
            aoetargeting.reticule.targetfn = ReticuleTargetFn
            if TheWorld.ismastersim then
                inst.components.aoespell:SetSpellFn(spellfn)
                spellbook:SetSpellFn(nil)
            end
        end,
        execute = StartAOETargeting,
        bank = data.bank or "spell_icons_willow",
        build = data.build or "spell_icons_willow",
        anims = {
            idle = data.anims and data.anims.idle or { anim = "lunar_fire" },
            focus = data.anims and data.anims.focus or { anim = "lunar_fire_focus", loop = true },
            down = data.anims and data.anims.down or { anim = "lunar_fire_pressed" },
            disabled = data.anims and data.anims.disabled or { anim = "lunar_fire_disabled" },
            cooldown = data.anims and data.anims.cooldown or { anim = "lunar_fire_cooldown" },
        },
        widget_scale = ICON_SCALE,
        checkcooldown = function(user)
            --client safe
            return user
                and user.components.spellbookcooldowns
                and user.components.spellbookcooldowns:GetSpellCooldownPercent(data.name)
                or nil
        end,
        cooldowncolor = { 0.65, 0.65, 0.65, 0.75 },
    }
end

return {
    AutoToggleWidget = AutoToggleWidget,
    AbsorbSingleTargetSkill = AbsorbSingleTargetSkill,
}
