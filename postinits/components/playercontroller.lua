---@class component_playercontroller
local PlayerController = require "components/playercontroller"

--UTIL.FnExtend(PlayerController, "GetMapActions", nil, function(rets, self, pos, ...)
--    rets = rets or {}
--    if self.inst.components.skilltreeupdater:IsActivated("spacemagic_3") and
--        self.inst:CanSeePointOnMiniMap(pos:Get()) and
--        TheWorld.Map:IsAboveGroundAtPoint(pos:Get()) then
--        rets[2] = BufferedAction(self.inst, nil, ACTIONS.TRANSFER_MAP, nil, pos)
--    end
--    return rets
--end)

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
