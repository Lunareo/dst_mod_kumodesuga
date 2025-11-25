---@class component_combat
---@field externalbonusmodifier SourceModifierList
local Combat = require "components/combat"

---@class SourceModifierList
local SourceModifierList = require "util/sourcemodifierlist"

local function rawsetbonus(self)
    rawget(self, "_").damagebonus[1] = self.externalbonusmodifier:Get()
end

local function ondamagebonus(self, val)
    if val ~= nil then
        self.externalbonusmodifier:SetModifier("self.damagebonus", val, "self.damagebonus")
    else
        self.externalbonusmodifier:RemoveModifier("self.damagebonus", "self.damagebonus")
    end
    rawsetbonus(self)
end

UTIL.FnExtend(Combat, "_ctor", function(self)
    self.externalbonusmodifier = SourceModifierList(self.inst, 0, SourceModifierList.additive)
    addsetter(self, "damagebonus", ondamagebonus)
end)

function Combat:AddBonusModifier(source, m, key)
    self.externalbonusmodifier:SetModifier(source, m, key)
    rawsetbonus(self)
end

function Combat:RemoveBonusModifier(source, key)
    self.externalbonusmodifier:RemoveModifier(source, key)
    rawsetbonus(self)
end
