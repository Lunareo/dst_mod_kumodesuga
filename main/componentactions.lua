AddComponentAction("SCENE", "magiccaster", function(inst, doer, actions, right)
    local spell_item = doer.components.magiccaster:GetSpell()
    if not spell_item then return end
    if doer.HUD ~= nil and doer.HUD:GetCurrentOpenSpellBook() == spell_item then
        table.insert(actions, ACTIONS.UNSPELL)
    elseif spell_item.components.spellbook:CanBeUsedBy(doer) and doer.replica.inventory:GetActiveItem() == nil then
        if spell_item.replica.inventoryitem:IsGrandOwner(doer) then
            table.insert(actions, ACTIONS.SPELL)
        end
    end
end)