---@class component_playeractionpicker
local PlayerActionPicker = require "components/playeractionpicker"

-- Vanilla only calls GetPointSpecialActions when IsPassableAtPoint is true,
-- so TRANSFER never appears over open ocean even with spacemotor.
UTIL.FnExtend(PlayerActionPicker, "GetRightClickActions", nil,
    function(rets, self, position, target, spellbook)
        local actions = rets and rets[1]
        if actions ~= nil and #actions > 0 then
            return rets
        end
        if self.disable_right_click or position == nil then
            return rets
        end
        -- Don't override real entity targets (boats/platforms are ok — they are walkable).
        if target ~= nil
            and not target:HasTag("walkableplatform")
            and not target:HasTag("walkableperipheral")
            and not target:HasTag("ignoremouseover") then
            return rets
        end

        local inventory = self.inst.replica.inventory
        local useitem = inventory and inventory:GetActiveItem() or nil
        local specials = self:GetPointSpecialActions(position, useitem, true)
        if specials ~= nil and #specials > 0 then
            return { specials }
        end
        return rets
    end)
