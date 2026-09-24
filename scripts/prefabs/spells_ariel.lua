local Abilities = require "ariel_abilities"
local names = {
    "devour", "dash", "gate", "humility",
    "puppet_1", "puppet_2", "puppet_3", "puppet_4",
    "guard", "follow", "focus", "massage", "joke",
}
local icons = {
    devour = "eye_of_curse",
    dash = "eye_of_freeze",
    gate = "eye_of_destroy",
    humility = "eye_of_destroy",
}

return function(owner)
    local items = {}
    for _, id in ipairs(names) do
        local name = id
        local icon = icons[name] or "eye_of_curse"
        items[#items + 1] = {
            label = STRINGS.ARIEL.SPELLS[string.upper(name)],
            bank = "spell_icons_shiro",
            build = "spell_icons_shiro",
            anims = {
                idle = { anim = icon },
                focus = { anim = icon .. "_focus", loop = true },
                down = { anim = icon },
                disabled = { anim = icon .. "_disabled" },
            },
            widget_scale = .45,
            onselect = function(inst)
                inst.components.spellbook:SetSpellName(STRINGS.ARIEL.SPELLS[string.upper(name)])
                inst.components.spellbook:SetSpellAction(nil)
                local range = (name == "devour" or name == "massage") and 3 or TUNING.ARIEL.gate_range
                inst.components.aoetargeting:SetRange(range)
                inst.components.aoetargeting:SetDeployRadius(0)
                inst.components.aoetargeting:SetAllowWater(false)
                inst.components.aoetargeting.reticule.reticuleprefab = "reticuleaoe"
                inst.components.aoetargeting.reticule.pingprefab = "reticuleaoeping"
                if TheWorld.ismastersim then
                    inst.components.aoespell:SetSpellFn(function(_, doer, pos)
                        return Abilities.Cast(doer, name, pos)
                    end)
                    inst.components.spellbook:SetSpellFn(nil)
                end
            end,
            execute = function(inst)
                if ThePlayer ~= nil and ThePlayer.components.playercontroller ~= nil then
                    ThePlayer.components.playercontroller:StartAOETargetingUsing(inst)
                end
            end,
        }
    end
    return items
end
