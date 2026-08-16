---@class component
---@field magicpoint component_magicpoint

---@type SourceModifierList
local SourceModifierList = require "util/sourcemodifierlist"

local Base = require "components/scorebase"

local UPDATE_PERIOD = 1

-- Sentinel so a registered source with no fallback stays distinguishable
-- from a removed one (fb entries double as "registered" markers).
local NO_FALLBACK = function() end

---@param self component_magicpoint
---@param new number
---@param old number
local function oncurrent(self, new, old)
    if new == old then return end
    local replica = self.inst.replica and self.inst.replica.magicpoint
    if replica ~= nil then
        replica:SetCurrent(new)
    end
end

---@param self component_magicpoint
---@param new number
---@param old number
local function onmax(self, new, old)
    if new == old then return end
    local replica = self.inst.replica and self.inst.replica.magicpoint
    if replica ~= nil then
        replica:SetMax(new)
    end
end

---@param inst ent
---@param self component_magicpoint
local function OnTaskTick(inst, self)
    self:OnUpdate(UPDATE_PERIOD)
end

---@class component_magicpoint: component_scorebase
---@field rate number # base regen per second
---@field fb table # source -> key -> fallback (consumption source registry)
---@field tasks table # source -> key -> pending delayed-start task
---@field dt number
---@field updatetask thread|nil
---@field ratemodifier SourceModifierList # additive sum of consumption sources
---@field ratemultipliers SourceModifierList # global consumption coefficient
local MagicPoint = Class(Base, function(self, inst)
    -- ScoreBase's property setters are not inherited by subclasses, reinstall
    -- them so current/max assignments keep the replica/classified in sync.
    addsetter(self, "current", oncurrent)
    addsetter(self, "max", onmax)

    Base._ctor(self, inst, "magicpoint")
    self.rate = .4
    self.fb = {}
    self.tasks = {}
    self.dt = 0
    self.ratemodifier = SourceModifierList(self.inst, 0, SourceModifierList.additive)
    self.ratemultipliers = SourceModifierList(self.inst)
    self.updatetask = self.inst:DoPeriodicTask(UPDATE_PERIOD, OnTaskTick, nil, self)
end, {})

---Net regen/consumption per second: base rate plus consumption sources,
---scaled by the global consumption coefficient.
---@return number
function MagicPoint:GetRate()
    return (self.rate + self.ratemodifier:Get()) * self.ratemultipliers:Get()
end

---@param amt number
function MagicPoint:Cost(amt)
    self:DoDelta(-amt)
end

---Register a consumption source.
---With `delay > 0` the modifier only starts applying `delay` seconds later;
---removing the source before then cancels the pending start.
---@param cmp any # source key (usually a component or buff instance)
---@param modifier number # consumption per second (usually negative)
---@param key string|nil
---@param fallback fun(cmp:any)|nil # called as fallback(cmp) on removal
---@param delay number|nil # seconds before the consumption starts
function MagicPoint:AddConsumptionSrc(cmp, modifier, key, fallback, delay)
    key = key or "key"
    self:RemoveConsumptionSrc(cmp, key)
    self.fb[cmp] = self.fb[cmp] or {}
    self.fb[cmp][key] = fallback or NO_FALLBACK
    if delay ~= nil and delay > 0 then
        self.tasks[cmp] = self.tasks[cmp] or {}
        self.tasks[cmp][key] = self.inst:DoTaskInTime(delay, function()
            self.tasks[cmp][key] = nil
            -- The source may have been removed while waiting out the delay.
            if self.fb[cmp] ~= nil and self.fb[cmp][key] ~= nil then
                self:SetModifier(cmp, modifier, key)
            end
        end)
    else
        self:SetModifier(cmp, modifier, key)
    end
end

---@param cmp any
---@param key string|nil
---@param soft boolean|nil # skip the fallback when true
function MagicPoint:RemoveConsumptionSrc(cmp, key, soft)
    key = key or "key"
    local fallbacks = self.fb[cmp]
    if fallbacks ~= nil then
        local fallback = fallbacks[key]
        if fallback ~= nil and fallback ~= NO_FALLBACK and not soft then
            fallback(cmp)
        end
        fallbacks[key] = nil
    end
    local tasks = self.tasks[cmp]
    if tasks ~= nil and tasks[key] ~= nil then
        tasks[key]:Cancel()
        tasks[key] = nil
    end
    self:RemoveModifier(cmp, key)
end

function MagicPoint:RemoveAllConsuptionSrcs()
    for cmp, list in pairs(self.fb) do
        for key in pairs(list) do
            self:RemoveConsumptionSrc(cmp, key)
        end
    end
end

---@param source any
---@param modifier number
---@param key string|nil
function MagicPoint:SetModifier(source, modifier, key)
    self.ratemodifier:SetModifier(source, modifier, key)
end

---@param source any
---@param key string|nil
function MagicPoint:RemoveModifier(source, key)
    self.ratemodifier:RemoveModifier(source, key)
end

---Set the global consumption coefficient (scales the whole rate).
---@param source any
---@param multiplier number
---@param key string|nil
function MagicPoint:SetMultiplier(source, multiplier, key)
    self.ratemultipliers:SetModifier(source, multiplier, key)
end

---@param source any
---@param key string|nil
function MagicPoint:RemoveMultiplier(source, key)
    self.ratemultipliers:RemoveModifier(source, key)
end

---@param dt number
function MagicPoint:OnUpdate(dt)
    if self.inst:HasTag("playerghost") then return end
    self.dt = self.dt + dt
    if self.dt < UPDATE_PERIOD then return end
    local period = self.dt
    self.dt = 0
    self:DoDelta(self:GetRate() * period)
end

---@param dt number
function MagicPoint:LongUpdate(dt)
    self:OnUpdate(dt)
end

function MagicPoint:OnRemoveFromEntity()
    if self.updatetask ~= nil then
        self.updatetask:Cancel()
        self.updatetask = nil
    end
    for _, tasks in pairs(self.tasks) do
        for _, task in pairs(tasks) do
            task:Cancel()
        end
    end
    self.tasks = {}
end

---@return string
function MagicPoint:GetDebugString()
    return string.format("%s | rate %.2f/s", Base.GetDebugString(self), self:GetRate())
end

return MagicPoint
