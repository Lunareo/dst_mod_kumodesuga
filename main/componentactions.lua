AddComponentAction("SCENE", "magiccaster", function(inst, doer, actions, right)
    local spell_item = inst == doer and inst.components.magiccaster:GetSpell()
    if not spell_item then return end
    if inst.HUD ~= nil and inst.HUD:GetCurrentOpenSpellBook() == spell_item then
        table.insert(actions, ACTIONS.UNSPELL)
    elseif spell_item.components.spellbook:CanBeUsedBy(inst) and inst.replica.inventory:GetActiveItem() == nil then
        if spell_item.replica.inventoryitem:IsGrandOwner(inst) then
            table.insert(actions, ACTIONS.SPELL)
        end
    end
end)
