---@alias scoretype string
---| '"scorebase"'

---@type SourceModifierList
local SourceModifierList = require "util/sourcemodifierlist"

local function onrename(self, new, old)
    assert(old == nil or new == old, string.format("Class symbol %s could not be renamed!", self.name))
end

local function oncurrent(self, new, old)
    if new == old then return end
    self.inst.replica[self.name]:SetCurrent(new)
end

local function onmax(self, new, old)
    if new == old then return end
    self.inst.replica[self.name]:SetMax(new)
end

---@class component_scorebase: component_base
---@field _ctor fun(self:table, inst:ent, name:scoretype)
---@field inst ent
---@field name scoretype
---@field current number
---@field max number
---@field maxmodifier SourceModifierList
---@field updatemodifier SourceModifierList
---@field maxmultipliers SourceModifierList
---@field updatemultipliers SourceModifierList
---@field save_max boolean|nil
local ScoreBase = Class(function(self, inst, name)
    self.inst = inst
    self.name = name and string.lower(name) or "scorebase"
    self.current = 0 -- consider self["current" .. name]
    self.max = 100
    self.save_max = nil
    self.maxmodifier = SourceModifierList(self.inst, 0, SourceModifierList.additive)
    self.maxmultipliers = SourceModifierList(self.inst)
    self.updatemodifier = SourceModifierList(self.inst, 0, SourceModifierList.additive)
    self.updatemultipliers = SourceModifierList(self.inst)
end, nil, {
    name = onrename,
    current = oncurrent,
    max = onmax,
})

function ScoreBase:OnSave()
    return
    {
        current = self.current,
        max = self.save_max and self.max or nil,
    }
end

function ScoreBase:OnLoad(data)
    if data == nil then
        return
    end
    if data.current ~= nil then
        self.current = data.current
    end
    if data.max ~= nil then
        self.max = data.max
    end
end

function ScoreBase:SetPercent(percent)
    self.current = percent * self.max
end

function ScoreBase:GetPercent()
    return self.current / self.max
end

function ScoreBase:SetCurrent(current)
    self.current = current
end

function ScoreBase:GetCurrent()
    return self.current
end

function ScoreBase:SetMax(max)
    self.max = max * self.maxmultipliers:Get() + self.maxmodifier:Get()
end

function ScoreBase:GetMax(native)
    return native and (self.max - self.maxmodifier:Get()) / self.maxmultipliers:Get() or self.max
end

function ScoreBase:SetVal(val)

end

function ScoreBase:DoDelta(delta)
    self.current = math.min(self.max, math.max(0, self.current + delta))
end

function ScoreBase:OnUpdate(dt)

end

function ScoreBase:GetDebugString()
    return string.format("Score: %d/%d", self.current, self.max)
end

return ScoreBase