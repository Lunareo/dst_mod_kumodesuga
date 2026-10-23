local MakePlayerCharactor = require "prefabs/player_common"
local SpellSetter = require "prefabs/spellsetter"

local avatar_name = "wrath"

local assets = {
    Asset("SCRIPT", "scripts/prefabs/player_common.lua"),
}

local prefabs = {
    "katana_wrath",
    "goblin_dagger",
    "flame_sword",
    "lightning_sword",
    "explosive_sword",
    "lightning_grid_sword",
}

local start_inv = {}
for k, v in pairs(TUNING.GAMEMODE_STARTING_ITEMS) do
    start_inv[string.lower(k)] = v[string.upper(avatar_name)]
end

prefabs = FlattenTree({ prefabs, start_inv }, true)

-- 技能树接入
local skilldefs = require "prefabs/skilltree_defs"
local BuildSkillsData = require "prefabs/skilltree_wrath"
local skill_data = BuildSkillsData(skilldefs.CUSTOM_FUNCTIONS)
skilldefs.CreateSkillTreeFor(avatar_name, skill_data.SKILLS)
skilldefs.SKILLTREE_ORDERS[avatar_name] = skill_data.ORDERS
if skilldefs.SKILLTREE_METAINFO and skilldefs.SKILLTREE_METAINFO[avatar_name] then
    skilldefs.SKILLTREE_METAINFO[avatar_name].BACKGROUND_SETTINGS = skill_data.BACKGROUND_SETTINGS
end
if skilldefs.CUSTOM_FUNCTIONS then
    skilldefs.CUSTOM_FUNCTIONS[avatar_name] = skill_data.CUSTOM_FUNCTIONS
end

---@class avatar_wrath: ent
---@field components table

---偏肉食饮食统计修改函数
local function WrathCustomStatsModFn(eater, health_delta, hunger_delta, sanity_delta, food, feeder)
    if food and food.components.edible then
        local foodtype = food.components.edible.foodtype
        -- 生肉、生鱼、生怪兽肉：负生命与负理智归零
        if health_delta < 0 then
            health_delta = 0
        end
        if sanity_delta < 0 then
            sanity_delta = 0
        end

        -- 熟食素食（纯蔬果无肉）：饥饿收益仅 50%
        if foodtype == FOODTYPE.VEGGIE or foodtype == FOODTYPE.SEEDS then
            hunger_delta = hunger_delta * 0.5
        end
    end
    return health_delta, hunger_delta, sanity_delta
end

---恶食拒食判断：拒食生蔬菜、生水果、生蘑菇
local function WrathCanEatTest(inst, item)
    if item and item.components.edible then
        local foodtype = item.components.edible.foodtype
        -- 生蔬果、生蘑菇判定
        if foodtype == FOODTYPE.VEGGIE or foodtype == FOODTYPE.SEEDS then
            -- 如果有 cookable 组件或 raw 标签，说明是未经烹饪的生食
            if item:HasTag("raw") or item.components.cookable ~= nil then
                return false
            end
        end
    end
    return true
end

---禁忌之声与常态理智流失计算
local function WrathSanityRateFn(inst)
    if inst.components.wrathstate ~= nil then
        return inst.components.wrathstate:GetSanityRateModifier()
    end
    return 0
end

local common_postinit = function(inst)
    inst.MiniMapEntity:SetIcon(avatar_name .. ".tex")
    inst:AddTag("wrath")
    inst:AddTag("master_swordsman")
    SpellSetter(inst)
end

local master_postinit = function(inst)
    inst.starting_inventory = start_inv[TheNet:GetServerGameMode()] or start_inv.default
    inst.soundsname = "wilson"

    -- 1. 基础三维
    inst.components.health:SetMaxHealth(TUNING.WRATH_HEALTH or 200)
    inst.components.hunger:SetMax(TUNING.WRATH_HUNGER or 200)
    inst.components.sanity:SetMax(TUNING.WRATH_SANITY or 120)

    -- 常态耗粮 1.25 倍
    inst.components.hunger.hungerrate = inst.components.hunger.hungerrate * (TUNING.WRATH_HUNGER_RATE_MULT or 1.25)

    -- 2. 鬼人体魄 20% 物理减免
    inst.components.health.externalabsorbmodifiers:SetModifier(inst, TUNING.WRATH_ABSORB or 0.20, "wrath_oni_body")

    -- 3. 恶食肉食者设置
    inst.components.eater:SetStrongStomach(true)
    inst.components.eater:SetCanEatRawMeat(true)
    inst.components.eater:SetCanEatTest(WrathCanEatTest)
    inst.components.eater.custom_stats_mod_fn = WrathCustomStatsModFn

    -- 4. 禁忌之声理智流失
    inst.components.sanity.custom_rate_fn = WrathSanityRateFn

    -- 5. MP 魔法系统
    inst:AddComponent("magicpoint")
    inst.components.magicpoint:SetMax(TUNING.WRATH_MAGICPOINT or 150)
    inst.components.magicpoint:SetCurrent(TUNING.WRATH_MAGICPOINT or 150)
    inst.components.magicpoint.rate = 1

    -- 6. 专属综合状态管理组件
    inst:AddComponent("wrathstate")
end

return MakePlayerCharactor(avatar_name, prefabs, assets, common_postinit, master_postinit)
