local SKILL_UTIL = require "prefabs/playerskillutil"
local ICON_SCALE = 0.6

local function StartAOETargeting(inst)
    local playercontroller = ThePlayer and ThePlayer.components and ThePlayer.components.playercontroller
    if playercontroller ~= nil then
        playercontroller:StartAOETargetingUsing(inst)
    end
end

local function ReticuleTargetFn(inst)
    if ThePlayer == nil or ThePlayer.entity == nil then
        return Vector3(0, 0.001, 0)
    end
    return Vector3(ThePlayer.entity:LocalToWorldSpace(7, 0.001, 0)) -- Raised this off the ground a touch so it wont have any z-fighting with the ground biome transition tiles.
end

---@class skill_def_partial
---@field name string
---@field bank string|nil
---@field build string|nil
---@field anims table|nil
---@field spellfn fun(target, doer)|(nil)
---@field cost integer|nil
---@field can_cast_fn nil|fun(doer: ent, target:ent|nil):boolean

local CREATURES_MUST = { "_combat" }
local CREATURES_CAN  = { "monster", "smallcreature", "largecreature", "animal", "bigbernie", "character" }
local CREATURES_CANT = { "INLIMBO", "flight", "player", "ghost", "invisible", "noattack", "notarget", "structure" }

local function TryConsumeCost(doer, cost)
    if cost == nil or cost <= 0 then return true end
    local final_cost = math.ceil(cost * SKILL_UTIL.GetCostMultiplier(doer))
    local magicpoint = doer and doer.components and doer.components.magicpoint
    return magicpoint ~= nil and magicpoint:Cost(final_cost)
end

---@param data skill_def_partial
---@return table
local function AbsorbSingleTargetSkill(data)
    local spellfn = function(inst, doer, pos)
        local cooldowns = doer.components.spellbookcooldowns
        if cooldowns ~= nil and cooldowns:IsInCooldown(data.name) then
            return false, "SPELL_ON_COOLDOWN"
        end

        local target = FindClosestEntityInPoint(pos, 4, nil, CREATURES_MUST, CREATURES_CANT)
        if target == nil then
            return true
        end

        if data.can_cast_fn ~= nil and not data.can_cast_fn(doer, target) then
            return false
        end

        if not TryConsumeCost(doer, data and data.cost) then
            return false, "SPELL_NOT_ENOUGH_COST"
        end

        data.spellfn(target, doer)
        local cooldown = TUNING["SPELL_" .. string.upper(data.name) .. "_COOLDOWN"]
        if cooldowns ~= nil and cooldown ~= nil then
            cooldowns:RestartSpellCooldown(data.name, cooldown)
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
        bank = data.bank,
        build = data.build,
        anims = data.anims--[[ or { -- show struct
            idle = { anim = "lunar_fire" },
            focus = { anim = "lunar_fire_focus", loop = true },
            down = { anim = "lunar_fire_pressed" },
            disabled = { anim = "lunar_fire_disabled" },
            cooldown = { anim = "lunar_fire_cooldown" },
        }]],
        widget_scale = ICON_SCALE,
        checkcooldown = function(user)
            --client safe
            return user
                and user.components.spellbookcooldowns
                and user.components.spellbookcooldowns:GetSpellCooldownPercent(data.name)
                or nil
        end,
        cooldowncolor = { 0.65, 0.65, 0.65, 0.75 },
        _validtest = data._validtest,
    }
end

---指向性AOE法术的公共实现。PointAOESkill 与 ConeAOESkill 仅为预设不同的薄封装。
---@param data skill_def_partial
---@param reticule string # 瞄准圈prefab
---@param ping string # 瞄准圈落点特效prefab
---@param default_range number
---@param default_radius number|nil # 为nil时固定使用0（锥形无落点半径）
---@return table
local function BuildAOESkill(data, reticule, ping, default_range, default_radius)
    local spellfn = function(inst, doer, pos)
        local cooldowns = doer.components.spellbookcooldowns
        if cooldowns ~= nil and cooldowns:IsInCooldown(data.name) then
            return false, "SPELL_ON_COOLDOWN"
        end

        if data.can_cast_fn ~= nil and not data.can_cast_fn(doer, pos) then
            return false
        end

        if not TryConsumeCost(doer, data and data.cost) then
            return false, "SPELL_NOT_ENOUGH_COST"
        end

        data.spellfn(pos, doer)
        local cooldown = TUNING["SPELL_" .. string.upper(data.name) .. "_COOLDOWN"]
        if cooldowns ~= nil and cooldown ~= nil then
            cooldowns:RestartSpellCooldown(data.name, cooldown)
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
            aoetargeting:SetRange(data.range or default_range)
            aoetargeting:SetDeployRadius(default_radius ~= nil and (data.radius or default_radius) or 0)
            aoetargeting:SetShouldRepeatCastFn(function(_, doer)
                return
                    doer.components.spellbookcooldowns == nil or
                    doer.components.spellbookcooldowns:IsInCooldown(data.name)
            end)
            aoetargeting.reticule.reticuleprefab = reticule
            aoetargeting.reticule.pingprefab = ping
            if TheWorld.ismastersim then
                inst.components.aoespell:SetSpellFn(spellfn)
                spellbook:SetSpellFn(nil)
            end
        end,
        execute = StartAOETargeting,
        bank = data.bank,
        build = data.build,
        anims = data.anims,
        widget_scale = ICON_SCALE,
        checkcooldown = function(user)
            return user
                and user.components.spellbookcooldowns
                and user.components.spellbookcooldowns:GetSpellCooldownPercent(data.name)
                or nil
        end,
        cooldowncolor = { 0.65, 0.65, 0.65, 0.75 },
        _validtest = data._validtest,
    }
end

local function PointAOESkill(data)
    return BuildAOESkill(data, "reticuleaoe", "reticuleaoeping", 16, 3)
end

local function ConeAOESkill(data)
    return BuildAOESkill(data, "reticulearc", "reticulearcping", 8)
end

return {
    AbsorbSingleTargetSkill = AbsorbSingleTargetSkill,
    PointAOESkill = PointAOESkill,
    ConeAOESkill = ConeAOESkill,
}
