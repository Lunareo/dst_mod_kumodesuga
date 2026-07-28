local SourceModifierList = require "util/sourcemodifierlist"

-- Final speed mult → character alpha:
--   <= 1.5 (150%): full opacity
--   >= 3.0 (300%): minimum opacity 50%
--   between: linear lerp
local ALPHA_SPEED_START = 1.5
local ALPHA_SPEED_END = 3.0
local ALPHA_MIN = 0.5
local ALPHA_MAX = 1.0

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

---@param speed number
---@return number
local function SpeedToAlpha(speed)
    if speed == nil or speed <= ALPHA_SPEED_START then
        return ALPHA_MAX
    end
    if speed >= ALPHA_SPEED_END then
        return ALPHA_MIN
    end
    local t = (speed - ALPHA_SPEED_START) / (ALPHA_SPEED_END - ALPHA_SPEED_START)
    return ALPHA_MAX - t * (ALPHA_MAX - ALPHA_MIN)
end

---@param self component_skanda
---@param alpha number
local function SetSkandaAlpha(self, alpha)
    local inst = self.inst
    if inst == nil or not inst:IsValid() or inst.AnimState == nil then
        return
    end
    alpha = math.clamp(alpha, ALPHA_MIN, ALPHA_MAX)
    -- Skip redundant SetMultColour (AnimState replicates from server).
    local quantized = math.floor(alpha * 100 + 0.5) / 100
    if self._last_alpha ~= nil and math.abs(self._last_alpha - quantized) < 0.005 then
        return
    end
    self._last_alpha = quantized
    inst.AnimState:SetMultColour(1, 1, 1, quantized)
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
---@field _last_alpha number|nil
local Skanda = Class(function(self, inst, root)
    self.inst = inst
    self.root = root
    self.name = "skanda" -- caution: before applying this component, set name
    self.isrunning = false
    self.accelerate = 0.5
    self.speedmult = 1
    self.maxspeedmult = 3
    self.runtime = 0
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
    SetSkandaAlpha(self, ALPHA_MAX)
end

function Skanda:RunForward()
    if self.disable then return end
    self.isrunning = true
    self.inst:StartUpdatingComponent(self)
end

function Skanda:Stop()
    self.isrunning = false
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
    if self.isrunning then
        self.runtime = self.runtime + dt
        self.speedmult = math.min(self.maxspeedmult,
            self.speedmult +
            FunctionOrValue(self.accelerate, self.runtime, self.speedmult, self.maxspeedmult) *
            self.externalaccelerate:Get() * dt)
        local spdsq = math.sqrt(math.max(1, self.speedmult))
        if self.inst.AnimState ~= nil then
            self.inst.AnimState:SetDeltaTimeMultiplier(spdsq)
        end
        if locomotor ~= nil then
            locomotor:SetExternalSpeedMultiplier(self.inst, self.name, self.speedmult)
        end
        if hunger ~= nil and hunger.burnratemodifiers ~= nil then
            hunger.burnratemodifiers:SetModifier(self.inst, self.speedmult * spdsq, self.name)
        end
        self.inst:AddTag("wonkey_run")
    else
        self.runtime = 0
        self.speedmult = 1
        if self.inst.AnimState ~= nil then
            self.inst.AnimState:SetDeltaTimeMultiplier(1)
        end
        if locomotor ~= nil then
            locomotor:RemoveExternalSpeedMultiplier(self.inst, self.name)
        end
        if hunger ~= nil and hunger.burnratemodifiers ~= nil then
            hunger.burnratemodifiers:RemoveModifier(self.inst, self.name)
        end
        self.inst:RemoveTag("wonkey_run")
        self.inst:StopUpdatingComponent(self)
    end

    -- Final move speed (all locomotor multipliers), not only skanda's own mult.
    local final_speed = 1
    if locomotor ~= nil and locomotor.GetSpeedMultiplier ~= nil then
        final_speed = locomotor:GetSpeedMultiplier() or 1
    else
        final_speed = self.speedmult
    end
    if not self.isrunning then
        final_speed = 1
    end
    SetSkandaAlpha(self, SpeedToAlpha(final_speed))
end

function Skanda:GetDebugString()
    return string.format("%.2f / %.2f", self.speedmult, self.maxspeedmult)
end

return Skanda
