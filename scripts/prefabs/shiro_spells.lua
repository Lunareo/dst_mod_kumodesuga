local SPELLBOOK_RADIUS = 120

local Spells = require "defs/allspells"
local SHIRO_SPELLS = {
    Spells.ToggleNightVision,
}

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddNetwork()

    inst:AddTag("spell_item")

    local spellbook = inst:AddComponent("spellbook")
    spellbook:SetRadius(SPELLBOOK_RADIUS)
    spellbook:SetFocusRadius(SPELLBOOK_RADIUS) --UIAnimButton don't use focus radius SPELLBOOK_FOCUS_RADIUS)
    spellbook:SetItems(SHIRO_SPELLS)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem:SetOnDroppedFn(inst.Remove)
    inst.components.inventoryitem.keepondeath = true

    inst:AddComponent("equippable")
    inst.components.equippable.equipslot = EQUIPSLOTS.BEARD

    inst.persists = false

    return inst
end

return Prefab("shiro_spells", fn)