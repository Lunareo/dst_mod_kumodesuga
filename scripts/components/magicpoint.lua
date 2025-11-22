---@class component
---@field magicpoint component_magicpoint

---@type SourceModifierList
local SourceModifierList = require "util/sourcemodifierlist"

local Base = require "components/scorebase"

---@class component_magicpoint: component_scorebase
---@field rate number
---@field fb table
---@field ratemodifier SourceModifierList
---@field ratemultipliers SourceModifierList
local MagicPoint = Class(Base, function(self, inst)
    Base._ctor(self, inst, "magicpoint")
    self.rate = .4
    self.fb = {}
    self.dt = 0
    self.ratemodifier = SourceModifierList(self.inst, SourceModifierList.additive)
    self.ratemultipliers = SourceModifierList(self.inst)
end)

function MagicPoint:GetRate()
    return self.rate * self.ratemultipliers:Get() + self.ratemodifier:Get()
end

function MagicPoint:Cost(amt)
    self:DoDelta(-amt)
end

function MagicPoint:AddConsumptionSrc(cmp, modifier, key, fallback)
    key = key or "key"
    self:RemoveConsumptionSrc(cmp, key)
    self.fb[cmp] = self.fb[cmp] or {}
    self.fb[cmp][key] = fallback
    self:SetModifier(cmp, modifier, key)
end

function MagicPoint:RemoveConsumptionSrc(cmp, key, soft)
    self.fb[cmp] = self.fb[cmp] or {}
    if self.fb[cmp][key] and not soft then
        self.fb[cmp][key](cmp)
    end
    self.fb[cmp][key] = nil
    self:RemoveModifier(cmp, key)
end

function MagicPoint:RemoveAllConsuptionSrcs()
    for cmp, list in pairs(self.fb) do
        for key in pairs(list) do
            self:RemoveConsumptionSrc(cmp, key)
        end
    end
end

function MagicPoint:SetModifier(source, modifier, key)
    self.ratemodifier:SetModifier(source, modifier, key)
end

function MagicPoint:RemoveModifier(source, key)
    self.ratemodifier:RemoveModifier(source, key)
end

function MagicPoint:SetMultiplier(source, multiplier, key)
    self.ratemultipliers:SetModifier(source, multiplier, key)
end

function MagicPoint:RemoveMultiplier(source, key)
    self.ratemultipliers:RemoveModifier(source, key)
end

function MagicPoint:OnUpdate(dt)
    self.dt = self.dt + dt
    if self.dt < 1 then return end
    self.dt = 0
    self:DoDelta(self:GetRate())
end

return MagicPoint