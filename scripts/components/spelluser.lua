local SpellUser = Class(function(self, inst)
    self.inst = inst
end)

function SpellUser:ActivateSpellItem()
    local spell_item = self.inst.replica.inventory:GetEquippedItem(EQUIPSLOTS.BEARD)
    if spell_item and spell_item:HasTag("spell_item") and spell_item.components.spellbook then
        return spell_item.components.spellbook:OpenSpellBook(self.inst)
    end
end

function SpellUser:DeactivateSpellItem()
    local spell_item = self.inst.replica.inventory:GetEquippedItem(EQUIPSLOTS.BEARD)
    if self.inst.HUD ~= nil and self.inst.HUD:GetCurrentOpenSpellBook() == spell_item then
        self.inst.HUD:CloseSpellWheel()
    end
end

return SpellUser
