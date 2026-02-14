---@type table<string, integer[]>
local ORDERS_LIST = {
    evolution = { 3, 70 },
    dominator = { 3, 186 },
    allegiance = { 184, 206 },
    constmagic = { -160, 206 }
}

---@type { [1]: string, [2]: integer[] }[]
local ORDERS = {}

for group, pos in pairs(ORDERS_LIST) do
    table.insert(ORDERS, { group, pos })
end

---@param group string
---@param dx integer
---@param dy integer
---@return integer[]
local function Coord(group, dx, dy)
    return { ORDERS_LIST[group][1] + dx, ORDERS_LIST[group][2] - 30 + dy }
end

local function OnSpaceMagicUpdate(inst, fromload)
    local count = inst.components.skilltreeupdater:CountSkillTag("spacemagic")
    if count == 0 then
        if inst._other_space ~= nil then
            inst._other_space.components.container:DropEverything(inst:GetPosition())
            inst:RemoveChild(inst._other_space)
            inst._other_space:Remove()
            inst._other_space = nil
        end
    else
        local old = inst._other_space
        inst._other_space = SpawnPrefab("other_space_3x" .. tostring(1 + math.clamp(count, 1, 3)))
        inst:AddChild(inst._other_space)
        if old ~= nil then
            inst:RemoveChild(old)
            for i = 1, old.components.container:GetNumSlots() do
                local item = old.components.container:RemoveItemBySlot(i)
                if item ~= nil then
                    inst._other_space.components.container:GiveItem(item, i)
                end
            end
            old.components.container:DropEverything(inst:GetPosition())
            if old.components.container:IsOpenedBy(inst) then
                local proxy = inst.components.inventory:GetOpenContainerProxyFor(old)
                if proxy ~= nil then
                    local new_proxy = SpawnAt(proxy.prefab, proxy)
                    proxy.components.container_proxy:Close()
                    new_proxy.components.container_proxy:Open(inst)
                end
            end
            old:Remove()
        end
    end
end

---@param SkillTreeFns SkillTreeFns
local function BuildSkillData(SkillTreeFns)
    ---@type table<string, skill_def>
    local skills =
    {
        --reincarnation = {
        --    pos = Coord(),
        --    group = "reincarnation",
        --    tags = { "reincarnation" },
        --    root = true,
        --    connects = { "skanda" }
        --},
        spacemotor = {
            pos = Coord("constmagic", -40, 0),
            group = "constmagic",
            tags = { "constmagic", "spacemotor" },
            root = true,
        },
        skanda = {
            pos = Coord("constmagic", 0, 0),
            group = "constmagic",
            tags = { "constmagic", "skanda" },
            root = true,
            onactivate = function(inst, fromload)
                inst:AddComponent("skanda")
            end,
            ondeactivate = function(inst, fromload)
                inst:RemoveComponent("skanda")
            end
        },
        vision_enhance = {
            pos = Coord("constmagic", 0, -40),
            group = "constmagic",
            tags = { "constmagic", "vision", },
            root = true,
            connects = { "vision_overlook" },
            onactivate = function(inst, fromload)
                if inst.components.nightvision ~= nil then
                    inst.components.nightvision:ToggleUpdate(true)
                end
            end,
            ondeactivate = function(inst, fromload)
                if inst.components.nightvision ~= nil then
                    inst.components.nightvision:ToggleUpdate(false)
                end
            end,
        },
        vision_overlook = {
            pos = Coord("constmagic", 0, -80),
            group = "constmagic",
            tags = { "constmagic", "vision", },
        },
        spacemagic_1 = {
            pos = Coord("constmagic", 40, 0),
            group = "constmagic",
            tags = { "constmagic", "spacemagic" },
            root = true,
            connects = { "spacemagic_2" },
            onactivate = OnSpaceMagicUpdate,
            ondeactivate = OnSpaceMagicUpdate,
        },
        spacemagic_2 = {
            pos = Coord("constmagic", 40, -40),
            group = "constmagic",
            tags = { "constmagic", "spacemagic" },
            connects = { "spacemagic_3" },
            onactivate = OnSpaceMagicUpdate,
            ondeactivate = OnSpaceMagicUpdate,
        },
        spacemagic_3 = {
            pos = Coord("constmagic", 40, -80),
            group = "constmagic",
            tags = { "constmagic", "spacemagic" },
            onactivate = OnSpaceMagicUpdate,
            ondeactivate = OnSpaceMagicUpdate,
        },
        dominator_lock = {
            pos = Coord("dominator", 0, 0),
            group = "dominator",
            tags = { "dominator", "lock" },
            root = true,
            lock_open = function(prefabname, activatedskills, readonly)
                return SkillTreeFns.CountSkills(prefabname, activatedskills) >= 12
            end,
            connects = { "arrogans", "desidiae", "pati", "sapiens" },
        },
        arrogans = {
            pos = Coord("dominator", -60, -20),
            group = "dominator",
            tags = { "dominator", "arrogans" },
        },
        desidiae = {
            pos = Coord("dominator", -20, -40),
            group = "dominator",
            tags = { "dominator", "desidiae" },
        },
        pati = {
            pos = Coord("dominator", 20, -40),
            group = "dominator",
            tags = { "dominator", "pati" },
        },
        sapiens = {
            pos = Coord("dominator", 60, -20),
            group = "dominator",
            tags = { "dominator", "sapiens" },
        },
        shiro_evolution_tiny_spider_meter = {
            pos = Coord("evolution", 0, 0),
            infographic = true,
            root = true,
            defaultfocus = true,
            group = "evolution",
            tags = { "evolution", "lock" },
        },
        shiro_evolution_death_scythe_lock = {
            pos = Coord("evolution", -40, 0),
            group = "evolution",
            tags = { "evolution", "lock" },
            lock_open = function(prefabname, activatedskills, readonly)
                return SkillTreeFns.CountTags(prefabname, "huge_spider", activatedskills) <= 0
            end,
            connects = { "shiro_evolution_death_scythe" },
        },
        shiro_evolution_death_scythe = {
            pos = Coord("evolution", -80, -5),
            group = "evolution",
            tags = { "evolution", "small_spider" },
            connects = { "shiro_evolution_undying_queen" },
            onactivate = function(inst, fromload)
                if inst.components.erosiondamage == nil then
                    inst:AddComponent("erosiondamage")
                end
                inst.components.erosiondamage:AddBonus(inst, 5, "death_scythe")
            end,
            ondeactivate = function(inst, fromload)
                if inst.components.erosiondamage then
                    inst.components.erosiondamage:RemoveBonus(inst, "death_scythe")
                end
            end,
        },
        shiro_evolution_undying_queen = {
            pos = Coord("evolution", -120, -15),
            group = "evolution",
            tags = { "evolution", "small_spider" },
            connects = { "shiro_evolution_arachne" },
        },
        shiro_evolution_arachne = {
            pos = Coord("evolution", -160, -30),
            group = "evolution",
            tags = { "evolution", "small_spider", "arachne" },
        },
        shiro_evolution_advance_spider_lock = {
            pos = Coord("evolution", 40, 0),
            group = "evolution",
            tags = { "evolution", "huge_spider", "lock" },
            connects = { "shiro_evolution_advance_spider" },
            lock_open = function(prefabname, activatedskills, readonly)
                return SkillTreeFns.CountTags(prefabname, "small_spider", activatedskills) <= 0
            end,
        },
        shiro_evolution_advance_spider = {
            pos = Coord("evolution", 80, -5),
            group = "evolution",
            tags = { "evolution", "huge_spider" },
            connects = { "shiro_evolution_mega_spider" },
        },
        shiro_evolution_mega_spider = {
            pos = Coord("evolution", 120, -15),
            group = "evolution",
            tags = { "evolution", "huge_spider" },
            connects = { "shiro_evolution_queen_spider" },
        },
        shiro_evolution_queen_spider = {
            pos = Coord("evolution", 160, -30),
            group = "evolution",
            tags = { "evolution", "huge_spider", "queenspider" },
        },
        evil_eyes_1 = {
            pos = Coord("constmagic", 80, 0),
            group = "constmagic",
            tags = { "constmagic", "evil_eyes" },
        },
        evil_eyes_2 = {
            pos = Coord("constmagic", 80, -40),
            group = "constmagic",
            tags = { "constmagic", "evil_eyes" },
        },
        evil_eyes_3 = {
            pos = Coord("constmagic", 80, -80),
            group = "constmagic",
            tags = { "constmagic", "evil_eyes" },
        },
        shiro_allegiance_shadow_lock_1 = SkillTreeFns.MakeFuelWeaverLock({ pos = Coord("allegiance", -20, 0) }),
        shiro_allegiance_shadow_lock_2 = SkillTreeFns.MakeNoLunarLock({ pos = Coord("allegiance", -20, -40), connects = { "shiro_allegiance_shadow" } }),
        shiro_allegiance_shadow = {
            icon = "wilson_favor_shadow",
            pos = Coord("allegiance", -20, -80),
            group = "allegiance",
            tags = { "allegiance", "shadow", "shadow_favor" },
        },
        shiro_allegiance_lunar_lock_1 = SkillTreeFns.MakeCelestialChampionLock({ pos = Coord("allegiance", 20, 0) }),
        shiro_allegiance_lunar_lock_2 = SkillTreeFns.MakeNoShadowLock({ pos = Coord("allegiance", 20, -40), connects = { "shiro_allegiance_lunar" } }),
        shiro_allegiance_lunar = {
            icon = "wilson_favor_lunar",
            pos = Coord("allegiance", 20, -80),
            group = "allegiance",
            tags = { "allegiance", "lunar", "lunar_favor" },
        },
    }
    for name, data in pairs(skills) do
        if data.lock_open then
            data.root = true
        else
            if not data.icon then
                data.icon = "wilson_alchemy_1"
            end
            data.title = data.title or STRINGS.SKILLTREE.SHIRO[string.upper(name) .. "_TITLE"]
        end
        data.desc = data.desc or STRINGS.SKILLTREE.SHIRO[string.upper(name) .. "_DESC"]
    end

    return {
        SKILLS = skills,
        ORDERS = ORDERS,
    }
end

return BuildSkillData
