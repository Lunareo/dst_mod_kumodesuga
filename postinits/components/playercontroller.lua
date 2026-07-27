---@class component_playercontroller
local PlayerController = require "components/playercontroller"

local function IsShiroAltHeld(self)
    return self.inst:HasTag("shiro") and self:IsControlPressed(CONTROL_FORCE_INSPECT)
end

-- shiro + Alt: do not start hand-equip AOE targeting / charging.
UTIL.FnExtend(PlayerController, "TryAOETargeting",
    function(self)
        if IsShiroAltHeld(self) then
            return { false }, true
        end
    end)

UTIL.FnExtend(PlayerController, "TryAOECharging",
    function(self)
        if IsShiroAltHeld(self) then
            return { false }, true
        end
    end)

-- shiro + Alt: strip CASTAOE from ground use so transfer can surface.
UTIL.FnExtend(PlayerController, "GetGroundUseAction", nil,
    function(rets, self, position, spellbook)
        if not IsShiroAltHeld(self) then
            return rets
        end
        local lmb = rets and rets[1] or nil
        local rmb = rets and rets[2] or nil
        if lmb ~= nil and lmb.action == ACTIONS.CASTAOE then
            lmb = nil
        end
        if rmb ~= nil and rmb.action == ACTIONS.CASTAOE then
            rmb = nil
        end
        return { lmb, rmb }
    end)

-- Vanilla requires IsPassableAtPoint, which rejects open ocean even when
-- pointspecialactionsfn offers TRANSFER (e.g. with spacemotor / boats).
UTIL.FnExtend(PlayerController, "GetGroundUseSpecialAction",
    function(self, position, right)
        -- TRANSFER only while Alt (FORCE_INSPECT) is held.
        if not self:IsControlPressed(CONTROL_FORCE_INSPECT) then
            return
        end

        position = position or
            (self.reticule ~= nil and self.reticule.targetpos) or
            (self.terraformer ~= nil and self.terraformer:GetPosition()) or
            self:GetPlacerPosition() or
            self.inst:GetPosition()

        if CanEntitySeePoint(self.inst, position:Get()) then
            local act = self.inst.components.playeractionpicker:GetPointSpecialActions(position, nil, right)[1]
            if act ~= nil and act.action == ACTIONS.TRANSFER then
                return { act }, true
            end
        end
        -- Fall through to vanilla for other point specials.
    end)

UTIL.FnExtend(PlayerController, "OnRemoteLeftClick",
    function(self, actioncode, position, target, isreleased, controlmodscode, noforce, mod_name, spellbook, spell_id)
        if self.ismastersim and self:IsEnabled() and self.handler == nil and spellbook == self.inst then
            self.inst.components.combat:SetTarget(nil)

            self.remote_controls[CONTROL_PRIMARY] = 0
            self:DecodeControlMods(controlmodscode)
            SetClientRequestedAction(actioncode, mod_name)
            local lmb, rmb
            if spellbook ~= nil then
                if spellbook.components.spellbook ~= nil and
                    spellbook.components.spellbook:SelectSpell(spell_id) then
                    lmb, rmb = self.inst.components.playeractionpicker:DoGetMouseActions(position, target, spellbook)
                end
            elseif spell_id == nil then
                lmb, rmb = self.inst.components.playeractionpicker:DoGetMouseActions(position, target)
            end
            local dblclickact
            if CanEntitySeeTarget(self.inst, self.inst) then
                dblclickact = self.inst.components.playeractionpicker:GetDoubleClickActions(position)[1]
            end

            ClearClientRequestedAction()
            if isreleased then self.remote_controls[CONTROL_PRIMARY] = nil end
            self:ClearControlMods()
            lmb = (actioncode == ACTIONS.LOOKAT.code and (lmb == nil or lmb.action == ACTIONS.WALKTO) and mod_name == nil and BufferedAction(self.inst, target, ACTIONS.LOOKAT, nil, position)) or
                (lmb == nil and actioncode == ACTIONS.WALKTO.code and mod_name == nil and BufferedAction(self.inst, nil, ACTIONS.WALKTO, nil, position)) or
                (lmb ~= nil and lmb.action.code == actioncode and lmb.action.mod_name == mod_name and lmb) or
                (rmb ~= nil and rmb.action.code == actioncode and rmb.action.mod_name == mod_name and rmb) or
                (dblclickact and dblclickact.action.code == actioncode and dblclickact.action.mod_name == mod_name and dblclickact) or
                nil
            if lmb ~= nil then
                if lmb.action.canforce and not noforce then
                    lmb:SetActionPoint(self:GetRemotePredictPosition() or self.inst:GetPosition())
                    lmb.forced = true
                end
                self:DoAction(lmb, spellbook)
                if dblclickact and lmb ~= dblclickact and self.locomotor.bufferedaction == lmb and
                    self:GetRemoteDirectVector() then
                    self.locomotor:Clear()
                end
            end
            return nil, true
        end
    end)
