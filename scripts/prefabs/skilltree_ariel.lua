local function Refresh(inst)
    if inst.components.arielgluttony ~= nil then inst.components.arielgluttony:Refresh() end
end

return function(skilldefs)
    local skills = {}
    local branches = {
        { "gluttony", -150, { "reservoir", "conversion", "satiated", "dash", "endless" } },
        { "command", 0, { "puppeteer", "queen", "nest", "legion" } },
        { "abyss", 150, { "abyss", "temperance", "last_stand", "sovereign" } },
    }
    local orders = {}
    for _, branch in ipairs(branches) do
        orders[#orders + 1] = { branch[1], { branch[2], 195 } }
        for i, short in ipairs(branch[3]) do
            local name = "ariel_" .. short
            skills[name] = {
                title = STRINGS.SKILLTREE.ARIEL[string.upper(short) .. "_TITLE"],
                desc = STRINGS.SKILLTREE.ARIEL[string.upper(short) .. "_DESC"],
                icon = "wilson_favor_shadow",
                pos = { branch[2], 155 - (i - 1) * 45 },
                group = branch[1],
                tags = { "ariel", branch[1] },
                root = i == 1 or nil,
                defaultfocus = short == "reservoir" or nil,
                connects = branch[3][i + 1] ~= nil and { "ariel_" .. branch[3][i + 1] } or nil,
                onactivate = Refresh,
                ondeactivate = Refresh,
            }
        end
    end
    return {
        SKILLS = skills,
        ORDERS = orders,
        BACKGROUND_SETTINGS = {},
        CUSTOM_FUNCTIONS = skilldefs and skilldefs.CUSTOM_FUNCTIONS and skilldefs.CUSTOM_FUNCTIONS.wilson or {},
    }
end
