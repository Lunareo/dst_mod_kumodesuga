---@class component_playeractionpicker
local PlayerActionPicker = require "components/playeractionpicker"

local function IsShiroAltHeld(inst)
    if inst == nil or not inst:HasTag("shiro") then
        return false
    end
    local pc = inst.components.playercontroller
    return pc ~= nil and pc:IsControlPressed(CONTROL_FORCE_INSPECT)
end

local function IsCastAction(act)
    return act ~= nil and act.action == ACTIONS.CASTAOE
end

local function FilterOutCastActions(actions)
    if actions == nil or #actions == 0 then
        return actions
    end
    local filtered
    for i, act in ipairs(actions) do
        if IsCastAction(act) then
            if filtered == nil then
                filtered = {}
                for j = 1, i - 1 do
                    filtered[j] = actions[j]
                end
            end
        elseif filtered ~= nil then
            filtered[#filtered + 1] = act
        end
    end
    return filtered or actions
end

-- 1) shiro + Alt: strip hand-equip CASTAOE so transfer can surface.
-- 2) When no rmb action (e.g. open ocean), still allow point specials (TRANSFER).
UTIL.FnExtend(PlayerActionPicker, "GetRightClickActions", nil,
    function(rets, self, position, target, spellbook)
        local actions = rets and rets[1]
        local shiro_alt = IsShiroAltHeld(self.inst)

        if shiro_alt then
            actions = FilterOutCastActions(actions)
            -- Prefer point specials (TRANSFER) over remaining empty / cast-only result.
            if actions == nil or #actions == 0 then
                if not self.disable_right_click and position ~= nil
                    and (target == nil
                        or target:HasTag("walkableplatform")
                        or target:HasTag("walkableperipheral")
                        or target:HasTag("ignoremouseover")) then
                    local inventory = self.inst.replica.inventory
                    local useitem = inventory and inventory:GetActiveItem() or nil
                    local specials = self:GetPointSpecialActions(position, useitem, true)
                    if specials ~= nil and #specials > 0 then
                        return { specials }
                    end
                end
            end
            return { actions or {} }
        end

        -- Non-shiro / no Alt: ocean fallback for TRANSFER still needs Alt (checked inside pointspecial).
        if actions ~= nil and #actions > 0 then
            return rets
        end
        if self.disable_right_click or position == nil then
            return rets
        end
        local pc = self.inst.components.playercontroller
        if pc == nil or not pc:IsControlPressed(CONTROL_FORCE_INSPECT) then
            return rets
        end
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
