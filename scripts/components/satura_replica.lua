local high_satu_percent = 2 / 3

local function ctor(self)
    while not self.classified do
        local classified = self.inst.player_classified
        if TheWorld.ismastersim then
            self.classified = classified
        elseif classified and self.classified == nil then
            self:AttachClassified(classified)
        end
        Yield()
    end
end

---@class replica_components
---@field satura replica_satura

---@class replica_satura: replica_base
local Satura = Class(function(self, inst)
    self.inst = inst

    StartThread(ctor, inst and inst.GUID, self)
end)

function Satura:AttachClassified(classified)
    self.classified = classified
    self.ondetachclassified = function() self:DetachClassified() end
    self.inst:ListenForEvent("onremove", self.ondetachclassified, classified)
end

function Satura:DetachClassified()
    self.classified = nil
    self.ondetachclassified = nil
end

-------------------------------------------------------------------------

function Satura:SetCurrent(current)
    if self.classified ~= nil then
        self.classified:SetValue("currentsatura", current)
    end
end

function Satura:SetMax(max)
    if self.classified ~= nil then
        self.classified:SetValue("maxsatura", max)
    end
end

function Satura:Max()
    if self.inst.components.satura ~= nil then
        return self.inst.components.satura.max
    elseif self.classified ~= nil then
        return self.classified.maxsatura:value()
    else
        return 50
    end
end

function Satura:GetPercent()
    if self.inst.components.satura ~= nil then
        return self.inst.components.satura:GetPercent()
    elseif self.classified ~= nil then
        return self.classified.currentsatura:value() / self.classified.maxsatura:value()
    else
        return 0
    end
end

function Satura:GetCurrent()
    if self.inst.components.satura ~= nil then
        return self.inst.components.satura.current
    elseif self.classified ~= nil then
        return self.classified.currentsatura:value()
    else
        return 100
    end
end

function Satura:IsSaturated()
    if self.inst.components.satura ~= nil then
        return self.inst.components.satura:IsSaturated()
    else
        return self.classified ~= nil and self.classified.currentsatura:value() > 0
    end
end

function Satura:IsHighsaturated()
    if self.inst.components.satura ~= nil then
        return self.inst.components.satura:IsHighsaturated()
    else
        return self.classified ~= nil and
            self.classified.currentsatura:value() >= self.classified.maxsatura:value() * high_satu_percent
    end
end

function Satura:IsOversaturated()
    if self.inst.components.satura ~= nil then
        return self.inst.components.satura:IsOversaturated()
    else
        return self.classified ~= nil and self.classified.currentsatura:value() >= self.classified.maxsatura:value()
    end
end

return Satura
