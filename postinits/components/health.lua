---Preserved, need complement before apply
---@class component_health
---@field penaltylist SourceModifierList
local Health = require "components/health"

---@class SourceModifierList
local SourceModifierList = require "util/sourcemodifierlist"

local function rawsetpenalty(self)
    rawget(self, "_").penalty[1] = self.penaltylist:Get()
end

local function onpenalty(self, val)
    if val ~= nil then
        self.penaltylist:SetModifier("self.penalty", val, "self.penalty")
    else
        self.penaltylist:RemoveModifier("self.penalty", "self.penalty")
    end
    rawsetpenalty(self)
end

UTIL.FnExtend(Health, "_ctor", nil, function(_, self, inst)
    self.penaltylist = SourceModifierList(inst, 0, SourceModifierList.additive)
    addsetter(self, "penalty", onpenalty)
    return _
end)

UTIL.FnExtend(Health, "OnSave", nil, function(rets, self, data)
    rets = rets or {}
    rets.penaltylist = {}
    for s, t in pairs(self.penaltylist._modifiers) do
        rets.penaltylist[s] = {}
        for k, m in pairs(t) do
            rets.penaltylist[s][k] = m
        end
    end
    local count = 0
    for _ in pairs(rets.penaltylist) do
        for __ in pairs(rets.penaltylist[_]) do
            count = count + 1
        end
    end
    if count == 0 then
        rets.penaltylist = nil
    end
    return rets
end)

UTIL.FnExtend(Health, "OnLoad", nil, function(_, self, data)
    if data and data.penaltylist then
        for s, t in pairs(data.penaltylist) do
            for k, m in pairs(t) do
                self:AddPenaltyModifier(s, m, k)
            end
        end
    end
    return _
end)

function Health:AddPenaltyModifier(source, m, key)
    local penalty = 
    self.penaltylist:SetModifier(source, m, key)
    rawsetpenalty(self)
end

function Health:RemovePenaltyModifier(source, key)
    self.penaltylist:RemoveModifier(source, key)
    rawsetpenalty(self)
end
