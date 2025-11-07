AddComponentAction("EQUIPPED", "spellbook", function(inst, doer, target, actions, right)
    if not (inst and inst:HasTag("spell_item")) then return end
    if doer.HUD ~= nil and doer.HUD:GetCurrentOpenSpellBook() == inst then
        table.insert(actions, ACTIONS.CLOSESPELLBOOK)
    elseif inst.components.spellbook:CanBeUsedBy(doer) and doer.replica.inventory:GetActiveItem() == nil then
        if inst.replica.inventoryitem:IsGrandOwner(doer) then
            table.insert(actions, ACTIONS.USESPELLBOOK)
        end
    end
end)

AddComponentAction("SCENE", "spelluser", function(inst, doer, actions, right)
    local spell_item = doer.replica.inventory:GetEquippedItem(EQUIPSLOTS.BEARD)
    if not (spell_item and spell_item:HasTag("spell_item")) then return end
    if doer.HUD ~= nil and doer.HUD:GetCurrentOpenSpellBook() == spell_item then
        table.insert(actions, ACTIONS.UNSPELL)
    elseif spell_item.components.spellbook:CanBeUsedBy(doer) and doer.replica.inventory:GetActiveItem() == nil then
        if spell_item.replica.inventoryitem:IsGrandOwner(doer) then
            table.insert(actions, ACTIONS.SPELL)
        end
    end
end)

TheInput:AddKeyDownHandler(KEY_Z, function()
    if not (TheInput:GetHUDEntityUnderMouse() == nil and TheFrontEnd:GetActiveScreen() and TheFrontEnd:GetActiveScreen().name == "HUD") then return end
    local spell_item = ThePlayer.replica.inventory:GetEquippedItem(EQUIPSLOTS.BEARD)
    if not (spell_item and spell_item:HasTag("spell_item") and spell_item.components.spellbook) then return end
    if ThePlayer.HUD ~= nil and ThePlayer.HUD:GetCurrentOpenSpellBook() == spell_item then
        ThePlayer.HUD:CloseSpellWheel()
    elseif spell_item.components.spellbook:CanBeUsedBy(ThePlayer) and ThePlayer.replica.inventory:GetActiveItem() == nil then
        spell_item.components.spellbook:OpenSpellBook(ThePlayer)
    end
end)
