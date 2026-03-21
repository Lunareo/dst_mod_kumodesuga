---@class component_combat
---@field damagebonuslist SourceModifierList
local Combat = require "components/combat"

---@class SourceModifierList
local SourceModifierList = require "util/sourcemodifierlist"

UTIL.FnExtend(Combat, "_ctor", function(self)
    self.damagebonuslist = SourceModifierList(self.inst, 0, SourceModifierList.additive)
end)

UTIL.FnExtend(Combat, "CalcDamage", nil, function(rets, self)
    if rets and #rets > 0 and rets[1] > 0 then
        rets[1] = math.max(0, rets[1] + self.damagebonuslist:Get())
    end
    return rets
end)

--[=[
local GetAttacked = Combat.GetAttacked
---@diagnostic disable-next-line: duplicate-set-field
function Combat:GetAttacked(attacker, ...)
    local not_blocked = GetAttacked(self, attacker, ...)
    if attacker ~= nil and attacker.components.skilltreeupdater ~= nil and attacker.components.skilltreeupdater:IsActivated("shiro_evolution_arachne") then
        not_blocked = not_blocked or GetAttacked(self, attacker, ...)
    end
    return not_blocked
end
]=]

function Combat:AddBonusModifier(source, m, key)
    self.damagebonuslist:SetModifier(source, m, key)
end

function Combat:RemoveBonusModifier(source, key)
    self.damagebonuslist:RemoveModifier(source, key)
end
