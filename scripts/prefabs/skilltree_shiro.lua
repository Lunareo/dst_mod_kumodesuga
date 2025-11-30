---@type table<string, table<number, number>>[]
local ORDERS =
{
    { "evolution",     { 0, 0 } },
    { "endurance",     { 0, 0 } },
    { "magicultimate", { 0, 0 } },
    { "perception",    { 0, 0 } }, -- vision schizobulia
    { "allegiance",    { 204, 176 + 30 } },
}

local function BuildSkillData(SkillTreeFns)
    ---@type table<string, skill_def>
    local skills =
    {
        --- evolution
        shiro_evolution_1 = { -- small spider
            icon     = "wilson_alchemy_1",
            pos      = { -62, 176 },
            group    = "evolution",
            tags     = { "evolution" },
            root     = true,
            connects = {
                "shiro_evolution_2",
            },
        },
        shiro_evolution_2 = { -- small poisonous spider
            icon     = "wilson_alchemy_1",
            pos      = { 12, 176 },
            group    = "evolution",
            tags     = { "evolution" },
            connects = {
                "shiro_evolution_3",
            },
        },
        shiro_evolution_3 = { -- death's scythe
            icon     = "wilson_alchemy_1",
            pos      = { 82, 176 },
            group    = "evolution",
            tags     = { "evolution" },
            connects = {
                "shiro_evolution_4",
            },
        },
        shiro_evolution_4 = { -- death's shadow
            icon     = "wilson_alchemy_1",
            pos      = { 152, 176 },
            group    = "evolution",
            tags     = { "evolution" },
            connects = {
                "shiro_evolution_5",
            },
        },
        shiro_evolution_5 = { -- undying spider queen, undying
            icon     = "wilson_alchemy_1",
            pos      = { 212, 176 },
            group    = "evolution",
            tags     = { "evolution" },
            connects = {
                "shiro_evolution_6",
            },
        },
        shiro_evolution_6 = { -- apotheosis
            icon  = "wilson_alchemy_1",
            pos   = { 272, 176 },
            group = "evolution",
            tags  = { "evolution" },
        },
        --- endurance
        --- magicultimate
        --- allegiance
        shiro_allegiance_lock_1 = {
            pos = { 204, 176 + 30 },
            group = "allegiance",
            root = true,
            lock_open = function(prefabname, activatedskills, readonly)
                return SkillTreeFns.CountSkills(prefabname, activatedskills) >= 12
            end,
            connects = {
                "shiro_allegiance_shadow",
            },
        },
    }
    for name, data in pairs(skills) do
        data.title = data.title or STRINGS.SKILLTREE.SHIRO[string.upper(name) .. "_TITLE"]
        data.desc = data.desc or STRINGS.SKILLTREE.SHIRO[string.upper(name) .. "_DESC"]
    end

    return {
        SKILLS = skills,
        ORDERS = ORDERS,
    }
end

return BuildSkillData
