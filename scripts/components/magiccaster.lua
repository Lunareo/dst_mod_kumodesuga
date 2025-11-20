local SPELLBOOK_RADIUS = 120

---@class components
---@field magiccaster component_magiccaster

---@class component_magiccaster: component_base
---@field spell net_entity
local MagicCaster = Class(function(self, inst)
    self.inst = inst
    self.spell = net_entity(inst.GUID, "magiccaster.spell", "magiccaster.spelldirty")
    self:AttachSpell()
    self.inst:ListenForEvent("magiccaster.spelldirty", function() self:SetUpSpell() end)
end, nil, {})

function MagicCaster:TurnOnSpell()
    local spell = self:GetSpell()
    if spell == nil then return end
    return spell.components.spellbook:OpenSpellBook(self.inst)
end

function MagicCaster:TurnOffSpell()
    if self.inst.HUD ~= nil and self.inst.HUD:GetCurrentOpenSpellBook() == self:GetSpell() then
        self.inst.HUD:CloseSpellWheel()
    end
end

function MagicCaster:GetSpell()
    return self.spell:value()
end

function MagicCaster:AttachSpell()
    if not TheWorld.ismastersim or self.spell:value() ~= nil or self.inst.components.inventory == nil then return end
    self.inst:DoTaskInTime(0, function()
        self.spell:set(self.inst.components.inventory:GetItemInSlot(EQUIPSLOTS.SPELL) or SpawnPrefab("spell_item"))
        self.inst.components.inventory:Equip(self.spell:value(), nil, true)
    end)
end

function MagicCaster:SetUpSpell(custom_spells)
    local spell = self:GetSpell()
    if spell == nil then return end
    spell.components.spellbook:SetRadius(SPELLBOOK_RADIUS)
    spell.components.spellbook:SetFocusRadius(SPELLBOOK_RADIUS) --UIAnimButton don't use focus radius SPELLBOOK_FOCUS_RADIUS)
    spell.components.spellbook:SetItems(custom_spells or require("prefabs/spells_" .. self.inst.prefab))
end

return MagicCaster
