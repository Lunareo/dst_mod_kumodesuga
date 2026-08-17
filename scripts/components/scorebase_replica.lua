---@class replica_scorebase: replica_base
---@field _ctor fun(self:table, inst:ent, name:scoretype)
---@field inst ent
---@field name scoretype
---@field classified ent|nil
---@field ondetachclassified fun()|nil

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
        local components = self.inst.components
        local cmp = components ~= nil and components[self.name] or nil
        if cmp ~= nil then
            self:SetCurrent(cmp:GetCurrent())
            self:SetMax(cmp:GetMax())
        end
    end
end

local function GetClassifiedValue(self, key, default)
    local classified = self.classified
    local netvar = classified ~= nil and classified[key] or nil
    return netvar ~= nil and netvar:value() or default
end

local function GetComponent(self)
    local components = self.inst.components
    return components ~= nil and components[self.name] or nil
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
    if self.classified == classified then
        return
    end
    if self.classified ~= nil then
        self:DetachClassified()
    end

    self.classified = classified
    self.ondetachclassified = function() self:DetachClassified() end
    self.inst:ListenForEvent("onremove", self.ondetachclassified, classified)
end

function ScoreBase:DetachClassified()
    if self.classified ~= nil and self.ondetachclassified ~= nil then
        self.inst:RemoveEventCallback("onremove", self.ondetachclassified, self.classified)
    end
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

function ScoreBase:GetMax()
    local cmp = GetComponent(self)
    if cmp ~= nil then
        return cmp:GetMax()
    end
    return GetClassifiedValue(self, "max" .. self.name, 100)
end

-- Keep the vanilla-style name for existing call sites.
function ScoreBase:Max()
    return self:GetMax()
end

function ScoreBase:GetPercent()
    local cmp = GetComponent(self)
    if cmp ~= nil then
        return cmp:GetPercent()
    end

    local max = self:GetMax()
    return max > 0 and GetClassifiedValue(self, "current" .. self.name, 0) / max or 0
end

function ScoreBase:GetCurrent()
    local cmp = GetComponent(self)
    if cmp ~= nil then
        return cmp:GetCurrent()
    end
    return GetClassifiedValue(self, "current" .. self.name, 0)
end

return ScoreBase
