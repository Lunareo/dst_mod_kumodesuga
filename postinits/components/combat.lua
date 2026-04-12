--[=[
#### Critical:
- critrate = (entity critrate modifier
           + weapon critrate
           + for each equippable critrate in inventory equipslots)
           * critical compensation from locked target
           + 0.1 * luck
- critdamagerate = max(entity critdamagerate modifier
                     + weapon critdamagerate
                     + for each equippable critdamagerate in inventory equipslots,
                       0.5)
]=]
local BASECRITRATE = .05
local BASECRITDAMEGERATE = .5

---@class component_combat
local Combat = require "components/combat"

---@class SourceModifierList
local SourceModifierList = require "util/sourcemodifierlist"

UTIL.FnExtend(Combat, "_ctor", function(self, inst)
    self.damagebonuslist = SourceModifierList(inst, 0, SourceModifierList.additive)
    self.critrate = SourceModifierList(inst, 0, SourceModifierList.additive)
    self.critdamagerate = SourceModifierList(inst, 0, SourceModifierList.additive)
    if inst:HasTag("player") then
        self:AddCritRateModifier(inst, BASECRITRATE, "BASECRITRATE")
        self:AddCritDamageRateModifier(inst, BASECRITDAMEGERATE, "BASECRITDAMEGERATE")
    end
end)

UTIL.FnExtend(Combat, "CalcDamage", nil, function(rets, self, target, weapon)
    if rets and rets[1] then
        if rets[1] > 0 then
            rets[1] = math.max(0, rets[1] + self.damagebonuslist:Get())
        end
        rets[1] = rets[1] * (1 + self:CalcCritDamageRate(weapon, target))
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

UTIL.FnExtend(Combat, "GetAttacked", function(self, attacker)
    if attacker.components.combat ~= nil then
        if not attacker.components.combat.critical_flag then
            if attacker.components.combat.cachetarget and attacker.components.combat.cachetarget[1] == self.inst then
                attacker.components.combat.cachetarget[2] = attacker.components.combat.cachetarget[2] * 2
            else
                attacker.components.combat.cachetarget = { self.inst, 2 }
            end
        else
            attacker.components.combat.cachetarget = nil
        end
        attacker.components.combat.critical_flag = nil
    end
end)

---@param source any
---@param m number
---@param key string
function Combat:AddBonusModifier(source, m, key)
    self.damagebonuslist:SetModifier(source, m, key)
end

---@param source any
---@param key string
function Combat:RemoveBonusModifier(source, key)
    self.damagebonuslist:RemoveModifier(source, key)
end

---@param source any
---@param m number
---@param key string
function Combat:AddCritRateModifier(source, m, key)
    self.critrate:SetModifier(source, m, key)
end

---@param source any
---@param key string
function Combat:RemoveCritRateModifier(source, key)
    self.critrate:RemoveModifier(source, key)
end

---@param source any
---@param m number
---@param key string
function Combat:AddCritDamageRateModifier(source, m, key)
    self.critdamagerate:SetModifier(source, m, key)
end

---@param source any
---@param key string
function Combat:RemoveCritDamageRateModifier(source, key)
    self.critdamagerate:RemoveModifier(source, key)
end

---@param weapon ent|nil
---@param target ent|nil
---@return number
function Combat:CalcCritRate(weapon, target)
    local critrate = self.critrate:Get() or BASECRITRATE
    if self.inst.components.inventory ~= nil then
        for _, v in pairs(self.inst.components.inventory.equipslots) do
            if weapon ~= v then
                critrate = critrate +
                    FunctionOrValue((v.components.equippable.critrate or 0), self.inst, weapon, target)
            end
        end
    end
    if weapon ~= nil and weapon.components.equippable ~= nil then
        critrate = critrate + FunctionOrValue((weapon.components.equippable.critrate or 0), self.inst, weapon, target)
    end
    if self.cachetarget ~= nil and self.cachetarget[1] == target then
        critrate = critrate * self.cachetarget[2]
    end
    if self.inst.components.luckuser ~= nil then
        critrate = critrate + (self.inst.components.luckuser:GetLuck() * .1)
    end
    ---@diagnostic disable-next-line: return-type-mismatch
    return critrate
end

---@param weapon ent|nil
---@param target ent|nil
---@return number
function Combat:CalcCritDamageRate(weapon, target)
    local critrate = self:CalcCritRate(weapon, target)
    if math.random() > critrate then return 0 end
    self.critical_flag = true
    local critdamegerate = (self.critdamagerate:Get() or BASECRITDAMEGERATE)
    if self.inst.components.inventory ~= nil then
        for _, v in pairs(self.inst.components.inventory.equipslots) do
            if weapon ~= v then
                critdamegerate = critdamegerate +
                    FunctionOrValue((v.components.equippable.critdamagerate or 0), self.inst, weapon, target)
            end
        end
    end
    if weapon ~= nil and weapon.components.equippable ~= nil then
        critdamegerate = critdamegerate +
            FunctionOrValue((weapon.components.equippable.critdamagerate or 0), self.inst, weapon, target)
    end
    ---@diagnostic disable-next-line: param-type-mismatch
    return math.max(BASECRITDAMEGERATE, critdamegerate)
end
