local PlayerController = require "components/playercontroller"
UTIL.FnExtend(PlayerController, "OnControl", function(self, control, down)
    if not (ThePlayer and TheInput and TheFrontEnd) then return end

    if IsPaused() then return end

    local isenabled, ishudblocking = self:IsEnabled()
    if not isenabled and not ishudblocking then return end

    if not (TheInput:GetHUDEntityUnderMouse() == nil and TheFrontEnd:GetActiveScreen() and TheFrontEnd:GetActiveScreen().name == "HUD") then return end

    if control == CONTROL_CHARACTER_COMMAND_WHEEL and down then
        local spell_item = ThePlayer.components.magiccaster and ThePlayer.components.magiccaster:GetSpell()
        if not (spell_item and spell_item.components.spellbook) then return end
        if ThePlayer.HUD ~= nil and ThePlayer.HUD:GetCurrentOpenSpellBook() then
            ThePlayer.HUD:CloseSpellWheel()
        elseif spell_item.components.spellbook:CanBeUsedBy(ThePlayer) and ThePlayer.replica.inventory:GetActiveItem() == nil then
            spell_item.components.spellbook:OpenSpellBook(ThePlayer)
        end
    end
end)
