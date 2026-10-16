local MakePlayerCharactor = require "prefabs/player_common"
local SpellSetter = require "prefabs/spellsetter"
local Combat = require "ariel_combat"

local avatar_name = "ariel"
local assets = {
    Asset("ANIM", "anim/shiro.zip"),
    Asset("ANIM", "anim/ghost_shiro_build.zip"),
    Asset("ANIM", "anim/spell_icons_shiro.zip"),
    Asset("SCRIPT", "scripts/prefabs/player_common.lua"),
}
local prefabs = { "ariel_gate", "ariel_puppet_1", "ariel_puppet_2", "ariel_puppet_3", "ariel_puppet_4" }
local start_inv = {}
for k, v in pairs(TUNING.GAMEMODE_STARTING_ITEMS) do
    start_inv[string.lower(k)] = v.ARIEL
end
prefabs = FlattenTree({ prefabs, start_inv }, true)

local skilldefs = require "prefabs/skilltree_defs"
local BuildSkillsData = require "prefabs/skilltree_ariel"
local skill_data = BuildSkillsData(skilldefs.CUSTOM_FUNCTIONS)
skilldefs.CreateSkillTreeFor(avatar_name, skill_data.SKILLS)
skilldefs.SKILLTREE_ORDERS[avatar_name] = skill_data.ORDERS
skilldefs.SKILLTREE_METAINFO[avatar_name].BACKGROUND_SETTINGS = skill_data.BACKGROUND_SETTINGS
skilldefs.CUSTOM_FUNCTIONS[avatar_name] = skill_data.CUSTOM_FUNCTIONS

---@class avatar_ariel: ent
---@field _arielpool netvar
---@field _arielmax netvar
---@field _arielwear netvar
---@field _arieltier netvar
---@field _arielstance netvar

---@param inst avatar_ariel
local function common_postinit(inst)
    -- 普通形态和幽灵均指向真实存在的资源，皮肤条目也注册同一映射。
    inst.overrideskinmodebuild = "shiro"
    inst.ghostbuild = "ghost_shiro_build"
    inst.AnimState:SetBuild("shiro")
    inst.AnimState:SetHatOffset(0, 35)
    inst:AddTag(avatar_name)
    inst:AddTag("spiderwhisperer")
    inst:AddTag("spiderdisguise")
    inst:AddTag("stronggrip")
    inst.MiniMapEntity:SetIcon("ariel.tex")
    inst._arielpool = net_float(inst.GUID, "ariel.pool", "arieldirty")
    inst._arielmax = net_float(inst.GUID, "ariel.max", "arieldirty")
    inst._arielwear = net_float(inst.GUID, "ariel.wear", "arieldirty")
    inst._arieltier = net_tinybyte(inst.GUID, "ariel.tier", "arieldirty")
    inst._arielstance = net_tinybyte(inst.GUID, "ariel.stance", "arieldirty")
    SpellSetter(inst)
    inst.components.spellbook:SetRequiredTag("ariel")
    inst.components.spellbook:SetCanUseFn(function(_, user)
        return user == inst and not user:HasTag("playerghost")
    end)
end

---@param inst avatar_ariel
local function master_postinit(inst)
    inst.starting_inventory = start_inv[TheNet:GetServerGameMode()] or start_inv.default
    inst.soundsname = "wathgrithr"
    inst.components.health:SetMaxHealth(TUNING.ARIEL_HEALTH)
    inst.components.hunger:SetMax(TUNING.ARIEL_HUNGER)
    inst.components.sanity:SetMax(TUNING.ARIEL_SANITY)
    inst.components.hunger.hungerrate = inst.components.hunger.hungerrate * TUNING.ARIEL_HUNGER_RATE_MULT
    inst.components.combat:SetDefaultDamage(TUNING.ARIEL.unarmed_damage)
    inst.components.eater:SetStrongStomach(true)
    inst.components.sanity.no_moisture_penalty = true
    inst.components.temperature.maxmoisturepenalty = 0
    inst.components.inventory.isexternallyinsulated:SetModifier(inst, true, "ariel")
    inst.components.playerlightningtarget:SetOnStrikeFn(function() inst:PushEvent("lightningdamageavoided") end)
    inst.components.locomotor:SetTriggersCreep(false)
    inst.components.locomotor:SetSlowMultiplier(1)
    inst.components.sandstormwatcher:SetSandstormSpeedMultiplier(1)
    inst.components.moonstormwatcher:SetMoonstormSpeedMultiplier(1)
    inst.components.playervision:ForceGoggleVision(true)
    for _, tag in ipairs({ "lunar_aligned", "shadow_aligned" }) do
        inst.components.damagetyperesist:AddResist(tag, inst, TUNING.ARIEL.allegiance_resist, "ariel")
    end
    inst:AddComponent("arielgluttony")
    inst:AddComponent("arielcommander")
    inst.components.arielgluttony:Refresh()
    inst:ListenForEvent("mounted", function() inst.components.arielgluttony:Refresh() end)
    inst:ListenForEvent("dismounted", function() inst.components.arielgluttony:Refresh() end)

    -- 只免疫明确标记的毒伤；电击由原版绝缘与防雷路径处理，不扩大到整次攻击免伤。
    local getattacked = inst.components.combat.GetAttacked
    inst.components.combat.GetAttacked = function(self, attacker, damage, weapon, stimuli, spdamage)
        if stimuli == "poison" then damage = 0 end
        return getattacked(self, attacker, damage, weapon, stimuli, spdamage)
    end
    local delta = inst.components.health.DoDelta
    inst.components.health.DoDelta = function(self, amount, overtime, cause, ...)
        if amount < 0 and (cause == "poison" or cause == "poisonous_gas") then return 0 end
        if amount > 0 and overtime and inst.components.arielgluttony:IsExhausted() then return 0 end
        return delta(self, amount, overtime, cause, ...)
    end
    local sanitydelta = inst.components.sanity.DoDelta
    inst.components.sanity.DoDelta = function(self, amount, overtime, ...)
        if amount > 0 and overtime and inst.components.arielgluttony:IsExhausted() then return end
        return sanitydelta(self, amount, overtime, ...)
    end
    local addcoldness = inst.components.freezable.AddColdness
    inst.components.freezable.AddColdness = function(self, ...)
        local pool = inst.components.arielgluttony
        if pool:GetTier() < 3 and not pool:IsHumility() then return addcoldness(self, ...) end
    end
end

-- player_common 在 common_postinit 前就用模板名设置 build；改返回的 Prefab 身份，
-- 保持角色为 Ariel，同时让构造阶段也只访问真实存在的白织美术。
local template = MakePlayerCharactor("shiro", prefabs, assets, common_postinit, master_postinit)
for i = #template.deps, 1, -1 do
    if table.contains(PREFAB_SKINS.shiro, template.deps[i]) then table.remove(template.deps, i) end
end
for _, asset in ipairs(template.assets) do
    if asset.type == "INV_IMAGE" and asset.file == "skull_shiro" then asset.file = "skull_wilson" end
end
-- 将早期皮肤助手的 Lua 注册记录交回 Prefab 加载器，确保原生资源依赖也能加载。
return Prefab(avatar_name, template.fn, template.assets, template.deps), assert(Prefabs.ariel_none)
