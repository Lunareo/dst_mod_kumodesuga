---@class component
---@field magicpoint component_magicpoint

---@type SourceModifierList
local SourceModifierList = require "util/sourcemodifierlist"

local Base = require "components/scorebase"

---@class component_magicpoint: component_scorebase
local MagicPoint = Class(Base, function(self, inst)
    Base._ctor(self, inst, "magicpoint")
    self.rate = .4
    self.dt = 0
    self.ratemodifier = SourceModifierList(self.inst, SourceModifierList.additive)
    self.ratemultipliers = SourceModifierList(self.inst)
end)

function MagicPoint:GetRate()
    return self.rate * self.ratemultipliers:Get() + self.ratemodifier:Get()
end

function MagicPoint:OnUpdate(dt)
    self.dt = self.dt + dt
    if self.dt < 1 then return end
    self.dt = 0

end

return MagicPoint