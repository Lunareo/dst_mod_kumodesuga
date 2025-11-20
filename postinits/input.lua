TheInput:AddKeyDownHandler(KEY_Z, function()
    if not (TheInput:GetHUDEntityUnderMouse() == nil and TheFrontEnd:GetActiveScreen() and TheFrontEnd:GetActiveScreen().name == "HUD") then return end
    local spell_item = ThePlayer.components.magiccaster and ThePlayer.components.magiccaster:GetSpell()
    if not (spell_item and spell_item.components.spellbook) then return end
    if ThePlayer.HUD ~= nil and ThePlayer.HUD:GetCurrentOpenSpellBook() then
        ThePlayer.HUD:CloseSpellWheel()
    elseif spell_item.components.spellbook:CanBeUsedBy(ThePlayer) and ThePlayer.replica.inventory:GetActiveItem() == nil then
        spell_item.components.spellbook:OpenSpellBook(ThePlayer)
    end
end)