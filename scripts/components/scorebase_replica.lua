---@class replica_scorebase: replica_base
---@field _ctor fun(self:table, inst:ent, name:scoretype)
---@field inst ent
---@field name scoretype
---@field classified ent|nil

-- player_classified may replicate after the player entity (or vice versa),
-- so wait for it instead of dropping the attach on a bad tick order.
---@param self replica_scorebase
local function waitforclassified(self)
    while self.classified == nil do
        if not self.inst:IsValid() then return end
        local classified = self.inst.player_classified
        if TheWorld.ismastersim then
            self.classified = classified
        elseif classified ~= nil then
            self:AttachClassified(classified)
        end
        if self.classified == nil then
            Yield()
        end
    end
    -- Late attach on the master: push the authoritative current/max once,
    -- since assignments made before the attach were skipped.
    if TheWorld.ismastersim then
        local cmp = self.inst.components[self.name]
        if cmp ~= nil then
            self:SetCurrent(cmp:GetCurrent())
            self:SetMax(cmp:GetMax())
        end
    end
end

local ScoreBase = Class(function(self, inst, name)
    self.inst = inst
    self.name = name and string.lower(name) or "scorebase"

    if TheWorld.ismastersim and inst.player_classified ~= nil then
        self.classified = inst.player_classified
    else
        StartThread(waitforclassified, "scorebase_replica_" .. self.name, self)
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
    if self.classified ~= nil then
        self.classified:SetValue("current" .. self.name, current)
    end
end

function ScoreBase:SetMax(max)
    if self.classified ~= nil then
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
