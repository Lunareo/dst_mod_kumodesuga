---@class replica_scorebase: replica_base
---@field _ctor fun(self:table, inst:ent, name:scoretype)
---@field inst ent
---@field name scoretype
local ScoreBase = Class(function(self, inst, name)
    self.inst = inst
    self.name = name and string.lower(name) or "scorebase"

    if TheWorld.ismastersim then
        self.classified = inst.player_classified
    elseif self.classified == nil and inst.player_classified ~= nil then
        self:AttachClassified(inst.player_classified)
    end
end)

function ScoreBase:AttachClassified(classified)
    self.classified = classified
    self.ondetachclassified = function() self:DetachClassified() end
    self.inst:ListenForEvent("onremove", self.ondetachclassified, classified)
end

function ScoreBase:DetachClassified()
    self.classified = nil
    self.ondetachclassified = nil
end

function ScoreBase:SetCurrent(current)
    if self.classified == nil then
        self.classified:SetValue("current" .. self.name, current)
    end
end

function ScoreBase:SetMax(max)
    if self.classified == nil then
        self.classified:SetValue("max" .. self.name, max)
    end
end

function ScoreBase:Max()
    if self.inst.components[self.name] ~= nil then
        return self.inst.components[self.name]:GetMax()
    elseif self.classified ~= nil then
        return self.classified["max" .. self.name]:value()
    else
        return 100
    end
end

function ScoreBase:GetPercent()
    if self.inst.components[self.name] ~= nil then
        return self.inst.components[self.name]:GetPercent()
    elseif self.classified ~= nil then
        return self.classified["current" .. self.name]:value() / self.classified["max" .. self.name]:value()
    else
        return 1
    end
end

function ScoreBase:GetCurrent()
    if self.inst.components[self.name] ~= nil then
        return self.inst.components[self.name]:GetCurrent()
    elseif self.classified ~= nil then
        return self.classified["current" .. self.name]:value()
    else
        return 100
    end
end

return ScoreBase
