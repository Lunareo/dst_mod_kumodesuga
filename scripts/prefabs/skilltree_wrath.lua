---@type table<string, integer[]>
local ORDERS_LIST = {
    magic_arsenal = { -150, 195 },
    sword_mastery = { 0, 195 },
    oni_dominator = { 150, 195 },
    allegiance = { 0, 260 },
}

local ORDERS = {}
for group, pos in pairs(ORDERS_LIST) do
    table.insert(ORDERS, { group, pos })
end

---@param group string
---@param dx integer
---@param dy integer
---@return integer[]
local function Coord(group, dx, dy)
    return { ORDERS_LIST[group][1] + dx, ORDERS_LIST[group][2] - 35 + dy }
end

local function BuildSkillData(custom_functions)
    local SkillTreeFns = require "prefabs/skilltree_defs"
    local skills = {}

    ----------------------------------------------------------------------------
    -- 1. 【随身魔库】（8 点）
    ----------------------------------------------------------------------------
    -- 1.1 心念成刃
    skills.wrath_craft_speed = {
        icon = "wilson_torch_1",
        pos = Coord("magic_arsenal", -25, 0),
        group = "magic_arsenal",
        tags = { "wrath", "magic_arsenal" },
        root = true,
        connects = { "wrath_unlock_lightning", "wrath_weapon_maintenance" },
    }
    -- 1.2 解锁：迅雷魔剑
    skills.wrath_unlock_lightning = {
        icon = "wilson_torch_2",
        pos = Coord("magic_arsenal", -25, -45),
        group = "magic_arsenal",
        tags = { "wrath", "magic_arsenal" },
        connects = { "wrath_unlock_explosive" },
    }
    -- 1.3 解锁：爆碎魔剑
    skills.wrath_unlock_explosive = {
        icon = "wilson_torch_3",
        pos = Coord("magic_arsenal", -25, -90),
        group = "magic_arsenal",
        tags = { "wrath", "magic_arsenal" },
        connects = { "wrath_unlock_grid" },
    }
    -- 1.4 解锁：雷栅阵剑
    skills.wrath_unlock_grid = {
        icon = "wilson_torch_4",
        pos = Coord("magic_arsenal", -25, -135),
        group = "magic_arsenal",
        tags = { "wrath", "magic_arsenal" },
        connects = { "wrath_explosive_mastery" },
    }
    -- 1.5 武器保养
    skills.wrath_weapon_maintenance = {
        icon = "wilson_alchemy_1",
        pos = Coord("magic_arsenal", 25, 0),
        group = "magic_arsenal",
        tags = { "wrath", "magic_arsenal" },
        connects = { "wrath_quick_draw" },
    }
    -- 1.6 快速拔刀
    skills.wrath_quick_draw = {
        icon = "wilson_alchemy_2",
        pos = Coord("magic_arsenal", 25, -45),
        group = "magic_arsenal",
        tags = { "wrath", "magic_arsenal" },
        connects = { "wrath_element_combo" },
    }
    -- 1.7 元素连携
    skills.wrath_element_combo = {
        icon = "wilson_alchemy_3",
        pos = Coord("magic_arsenal", 25, -90),
        group = "magic_arsenal",
        tags = { "wrath", "magic_arsenal" },
        connects = { "wrath_explosive_mastery" },
    }
    -- 1.8 爆破精研（终极）
    skills.wrath_explosive_mastery = {
        icon = "wilson_alchemy_4",
        pos = Coord("magic_arsenal", 0, -180),
        group = "magic_arsenal",
        tags = { "wrath", "magic_arsenal", "capstone" },
    }

    ----------------------------------------------------------------------------
    -- 2. 【心眼剑圣】（8 点）
    ----------------------------------------------------------------------------
    -- 2.1 剑心通明
    skills.wrath_parry_window = {
        icon = "wilson_beard_1",
        pos = Coord("sword_mastery", -25, 0),
        group = "sword_mastery",
        tags = { "wrath", "sword_mastery" },
        root = true,
        connects = { "wrath_quick_counter", "wrath_iron_body" },
    }
    -- 2.2 迅捷反击
    skills.wrath_quick_counter = {
        icon = "wilson_beard_2",
        pos = Coord("sword_mastery", -25, -45),
        group = "sword_mastery",
        tags = { "wrath", "sword_mastery" },
        connects = { "wrath_heart_echo" },
    }
    -- 2.3 心流回响
    skills.wrath_heart_echo = {
        icon = "wilson_beard_3",
        pos = Coord("sword_mastery", -25, -90),
        group = "sword_mastery",
        tags = { "wrath", "sword_mastery" },
        connects = { "wrath_parry_expose" },
    }
    -- 2.4 铁壁体魄
    skills.wrath_iron_body = {
        icon = "wilson_torch_1",
        pos = Coord("sword_mastery", 25, 0),
        group = "sword_mastery",
        tags = { "wrath", "sword_mastery" },
        connects = { "wrath_iaijutsu_dash" },
    }
    -- 2.5 居合蓄势
    skills.wrath_iaijutsu_dash = {
        icon = "wilson_torch_2",
        pos = Coord("sword_mastery", 25, -45),
        group = "sword_mastery",
        tags = { "wrath", "sword_mastery" },
        connects = { "wrath_perfect_parry" },
    }
    -- 2.6 完美招架
    skills.wrath_perfect_parry = {
        icon = "wilson_torch_3",
        pos = Coord("sword_mastery", 25, -90),
        group = "sword_mastery",
        tags = { "wrath", "sword_mastery" },
        connects = { "wrath_sword_master_flow" },
    }
    -- 2.7 心眼破势
    skills.wrath_parry_expose = {
        icon = "wilson_beard_4",
        pos = Coord("sword_mastery", -25, -135),
        group = "sword_mastery",
        tags = { "wrath", "sword_mastery" },
        connects = { "wrath_sword_master_flow" },
    }
    -- 2.8 剑圣心流（终极）
    skills.wrath_sword_master_flow = {
        icon = "wilson_beard_5",
        pos = Coord("sword_mastery", 0, -180),
        group = "sword_mastery",
        tags = { "wrath", "sword_mastery", "capstone" },
    }

    ----------------------------------------------------------------------------
    -- 3. 【恶鬼支配】（8 点）
    ----------------------------------------------------------------------------
    -- 3.1 怒火沉淀
    skills.wrath_rage_threshold = {
        icon = "wilson_alchemy_1",
        pos = Coord("oni_dominator", -25, 0),
        group = "oni_dominator",
        tags = { "wrath", "oni_dominator" },
        root = true,
        connects = { "wrath_tenacious_oni", "wrath_taboo_resist" },
    }
    -- 3.2 顽强恶鬼
    skills.wrath_tenacious_oni = {
        icon = "wilson_alchemy_2",
        pos = Coord("oni_dominator", -25, -45),
        group = "oni_dominator",
        tags = { "wrath", "oni_dominator" },
        connects = { "wrath_berserk_body" },
    }
    -- 3.3 狂战之躯
    skills.wrath_berserk_body = {
        icon = "wilson_alchemy_3",
        pos = Coord("oni_dominator", -25, -90),
        group = "oni_dominator",
        tags = { "wrath", "oni_dominator" },
        connects = { "wrath_enma" },
    }
    -- 3.4 禁忌抗衡
    skills.wrath_taboo_resist = {
        icon = "wilson_torch_1",
        pos = Coord("oni_dominator", 25, 0),
        group = "oni_dominator",
        tags = { "wrath", "oni_dominator" },
        connects = { "wrath_blood_instinct" },
    }
    -- 3.5 血战本能
    skills.wrath_blood_instinct = {
        icon = "wilson_torch_2",
        pos = Coord("oni_dominator", 25, -45),
        group = "oni_dominator",
        tags = { "wrath", "oni_dominator" },
        connects = { "wrath_devour_carcass" },
    }
    -- 3.6 残骸吞食
    skills.wrath_devour_carcass = {
        icon = "wilson_torch_3",
        pos = Coord("oni_dominator", 25, -90),
        group = "oni_dominator",
        tags = { "wrath", "oni_dominator" },
        connects = { "wrath_enma_extend" },
    }
    -- 3.7 阎魔续火
    skills.wrath_enma_extend = {
        icon = "wilson_torch_4",
        pos = Coord("oni_dominator", 25, -135),
        group = "oni_dominator",
        tags = { "wrath", "oni_dominator" },
        connects = { "wrath_enma" },
    }
    -- 3.8 解锁：断罪之火·阎魔（终极）
    skills.wrath_enma = {
        icon = "wilson_alchemy_4",
        pos = Coord("oni_dominator", 0, -180),
        group = "oni_dominator",
        tags = { "wrath", "oni_dominator", "capstone" },
    }

    ----------------------------------------------------------------------------
    -- 4. 【阵营偏向】（2 点互斥）
    ----------------------------------------------------------------------------
    skills.wrath_allegiance_shadow_lock_1 = SkillTreeFns.MakeFuelWeaverLock({ pos = Coord("allegiance", -35, 0) })
    skills.wrath_allegiance_shadow_lock_2 = SkillTreeFns.MakeNoLunarLock({ pos = Coord("allegiance", -35, -40), connects = { "wrath_allegiance_shadow" } })
    skills.wrath_allegiance_shadow = {
        icon = "wilson_favor_shadow",
        pos = Coord("allegiance", -35, -80),
        group = "allegiance",
        tags = { "allegiance", "shadow", "shadow_favor" },
        onactivate = function(inst, fromload)
            inst:AddTag("player_shadow_aligned")
            local damagetyperesist = inst.components.damagetyperesist
            if damagetyperesist then
                damagetyperesist:AddResist("shadow_aligned", inst, 0.90, "wrath_allegiance_shadow")
            end
            local damagetypebonus = inst.components.damagetypebonus
            if damagetypebonus then
                damagetypebonus:AddBonus("lunar_aligned", inst, 1.10, "wrath_allegiance_shadow")
            end
        end,
        ondeactivate = function(inst, fromload)
            inst:RemoveTag("player_shadow_aligned")
            local damagetyperesist = inst.components.damagetyperesist
            if damagetyperesist then
                damagetyperesist:RemoveResist("shadow_aligned", inst, "wrath_allegiance_shadow")
            end
            local damagetypebonus = inst.components.damagetypebonus
            if damagetypebonus then
                damagetypebonus:RemoveBonus("lunar_aligned", inst, "wrath_allegiance_shadow")
            end
        end,
    }

    skills.wrath_allegiance_lunar_lock_1 = SkillTreeFns.MakeCelestialChampionLock({ pos = Coord("allegiance", 35, 0) })
    skills.wrath_allegiance_lunar_lock_2 = SkillTreeFns.MakeNoShadowLock({ pos = Coord("allegiance", 35, -40), connects = { "wrath_allegiance_lunar" } })
    skills.wrath_allegiance_lunar = {
        icon = "wilson_favor_lunar",
        pos = Coord("allegiance", 35, -80),
        group = "allegiance",
        tags = { "allegiance", "lunar", "lunar_favor" },
        onactivate = function(inst, fromload)
            inst:AddTag("player_lunar_aligned")
            local damagetyperesist = inst.components.damagetyperesist
            if damagetyperesist then
                damagetyperesist:AddResist("lunar_aligned", inst, 0.90, "wrath_allegiance_lunar")
            end
            local damagetypebonus = inst.components.damagetypebonus
            if damagetypebonus then
                damagetypebonus:AddBonus("shadow_aligned", inst, 1.10, "wrath_allegiance_lunar")
            end
        end,
        ondeactivate = function(inst, fromload)
            inst:RemoveTag("player_lunar_aligned")
            local damagetyperesist = inst.components.damagetyperesist
            if damagetyperesist then
                damagetyperesist:RemoveResist("lunar_aligned", inst, "wrath_allegiance_lunar")
            end
            local damagetypebonus = inst.components.damagetypebonus
            if damagetypebonus then
                damagetypebonus:RemoveBonus("shadow_aligned", inst, "wrath_allegiance_lunar")
            end
        end,
    }

    ----------------------------------------------------------------------------
    -- 标题与描述关联
    ----------------------------------------------------------------------------
    for name, data in pairs(skills) do
        if data.lock_open then
            data.root = true
        else
            data.icon = data.icon or name
            data.title = STRINGS.SKILLTREE.WRATH and STRINGS.SKILLTREE.WRATH[string.upper(name) .. "_TITLE"] or name
            data.desc = STRINGS.SKILLTREE.WRATH and STRINGS.SKILLTREE.WRATH[string.upper(name) .. "_DESC"] or ""
        end
    end

    return {
        SKILLS = skills,
        ORDERS = ORDERS,
    }
end

return BuildSkillData
