---@class component_combat
---@field damagebonuslist SourceModifierList
local Combat = require "components/combat"

---@class SourceModifierList
local SourceModifierList = require "util/sourcemodifierlist"

--[[
local function rawsetbonus(self)
    rawget(self, "_").damagebonus[1] = self.damagebonuslist:Get()
end

local function ondamagebonus(self, val)
    if val ~= nil then
        self.damagebonuslist:SetModifier("self.damagebonus", val, "self.damagebonus")
    else
        self.damagebonuslist:RemoveModifier("self.damagebonus", "self.damagebonus")
    end
    rawsetbonus(self)
end
]]

UTIL.FnExtend(Combat, "_ctor", function(self)
    self.damagebonuslist = SourceModifierList(self.inst, 0, SourceModifierList.additive)
    --addsetter(self, "damagebonus", ondamagebonus)
end)

UTIL.FnExtend(Combat, "CalcDamage", nil, function(rets, self)
    if rets and #rets > 0 and rets[1] > 0 then
        rets[1] = math.max(0, rets[1] + self.damagebonuslist:Get())
    end
    return rets
end)

function Combat:AddBonusModifier(source, m, key)
    self.damagebonuslist:SetModifier(source, m, key)
    --rawsetbonus(self)
end

function Combat:RemoveBonusModifier(source, key)
    self.damagebonuslist:RemoveModifier(source, key)
    --rawsetbonus(self)
end
