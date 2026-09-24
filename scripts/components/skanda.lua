local SourceModifierList = require "util/sourcemodifierlist"

local function onlocomote(inst, data)
    if data and data.dir then
        inst.components.skanda:RunForward()
    else
        inst.components.skanda:Stop()
    end
end

local function ondisable(self, disable, old)
    if disable == old then return end
    self.inst:RemoveEventCallback("locomote", onlocomote)
    if not disable then
        self.inst:ListenForEvent("locomote", onlocomote)
    end
end

---@class components
---@field skanda component_skanda

---@class component_skanda: component_base
---@field inst avatar_shiro
---@field root component_skillscript
---@field name string
---@field isrunning boolean
---@field accelerate function|number
---@field speedmult number
---@field maxspeedmult number
---@field runtime number
---@field externalaccelerate SourceModifierList
---@field disable boolean|nil
---@field _last_accelerate number
local Skanda = Class(function(self, inst, root)
    self.inst = inst
    self.root = root
    self.name = "skanda" -- caution: before applying this component, set name
    self.isrunning = false
    self.accelerate = 0.5
    self.speedmult = 1
    self.maxspeedmult = 3
    self.runtime = 0
    self._last_accelerate = 0
    self._last_alpha = nil
    self.externalaccelerate = SourceModifierList(self.inst)
    self.inst:ListenForEvent("locomote", onlocomote)
    self.inst:ListenForEvent("startstarving", function() self:Enable(false) end)
    self.inst:ListenForEvent("stopstarving", function() self:Enable(true) end)
    makereadonly(self, "name")
end, nil, {
    disable = ondisable,
})

-- reserve for rpc
---@param enable boolean|nil
function Skanda:Enable(enable)
    self.disable = not enable or nil
    if self.disable then
        self:Stop()
    end
end

function Skanda:OnRemoveFromEntity()
    local locomotor = self.inst.components.locomotor
    if locomotor ~= nil then
        locomotor:RemoveExternalSpeedMultiplier(self.inst, self.name)
    end
    local hunger = self.inst.components.hunger
    if hunger ~= nil and hunger.burnratemodifiers ~= nil then
        hunger.burnratemodifiers:RemoveModifier(self.inst, self.name)
    end
    self.inst:RemoveTag("wonkey_run")
    if self.inst.AnimState ~= nil then
        self.inst.AnimState:SetDeltaTimeMultiplier(1)
    end
    self.inst:RemoveEventCallback("locomote", onlocomote)
end

function Skanda:RunForward()
    if self.disable then return end
    self.isrunning = true
    self.inst:StartUpdatingComponent(self)
end

function Skanda:Stop()
    self.isrunning = false
    if self.speedmult > 1 then
        self.inst:StartUpdatingComponent(self)
    end
end

---@param acc function|number
function Skanda:SetAccelerate(acc)
    self.accelerate = acc
end

---@param max number
function Skanda:SetMaxSpeedMult(max)
    self.maxspeedmult = max
end

---@param dt number
function Skanda:OnUpdate(dt)
    local locomotor = self.inst.components.locomotor
    local hunger = self.inst.components.hunger
    local accelerate
    if self.isrunning then
        accelerate = math.max(0, FunctionOrValue(self.accelerate,
            self.runtime, self.speedmult, self.maxspeedmult) * self.externalaccelerate:Get())
        self._last_accelerate = accelerate
        self.runtime = self.runtime + dt
        self.speedmult = math.min(self.maxspeedmult, self.speedmult + accelerate * dt)
    else
        self.runtime = 0
        self.speedmult = math.max(1, self.speedmult - self._last_accelerate * 2 * dt)
    end

    if self.speedmult > 1 then
        local spdsq = math.sqrt(self.speedmult)
        if locomotor ~= nil then
            locomotor:SetExternalSpeedMultiplier(self.inst, self.name, self.speedmult)
        end
        if hunger ~= nil and hunger.burnratemodifiers ~= nil then
            hunger.burnratemodifiers:SetModifier(self.inst, self.speedmult * spdsq, self.name)
        end
        self.inst:AddTag("wonkey_run")
    else
        if locomotor ~= nil then
            locomotor:RemoveExternalSpeedMultiplier(self.inst, self.name)
        end
        if hunger ~= nil and hunger.burnratemodifiers ~= nil then
            hunger.burnratemodifiers:RemoveModifier(self.inst, self.name)
        end
        self.inst:RemoveTag("wonkey_run")
        if not self.isrunning then
            self.inst:StopUpdatingComponent(self)
        end
    end

    -- Final move speed (all locomotor multipliers), not only skanda's own mult.
    local final_speed = 1
    if locomotor ~= nil and locomotor.GetSpeedMultiplier ~= nil then
        final_speed = locomotor:GetSpeedMultiplier() or 1
    else
        final_speed = self.speedmult
    end
    if self.inst.AnimState ~= nil then
        self.inst.AnimState:SetDeltaTimeMultiplier(math.sqrt(math.max(1, final_speed)))
    end
end

function Skanda:GetDebugString()
    return string.format("%.2f / %.2f", self.speedmult, self.maxspeedmult)
end

return Skanda
