local SourceModifierList = require "util/sourcemodifierlist"

local function onlocomote(inst, data)
    if data and data.dir then
        inst.components.rusher:RunForward()
    else
        inst.components.rusher:Stop()
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
---@field rusher component_rusher

---@class component_rusher: component_base
---@field root component_skillscript
---@field name string
---@field isrunning boolean
---@field accelerate function|number
---@field speedmult number
---@field maxspeedmult number
---@field runtime number
---@field externalaccelerate SourceModifierList
---@field disable boolean|nil
local Rusher = Class(function(self, inst, root)
    self.inst = inst
    self.root = root
    self.name = "rusher" -- caution: before applying this component, set name
    self.isrunning = false
    self.accelerate = 0.5
    self.speedmult = 1
    self.maxspeedmult = 3
    self.runtime = 0
    self.externalaccelerate = SourceModifierList(self.inst)
    self.inst:ListenForEvent("locomote", onlocomote)
    makereadonly(self, "name")
end, nil, {
    disable = ondisable,
})

-- reserve for rpc
---@param enable boolean|nil
function Rusher:Enable(enable)
    self.disable = not enable or nil
end

function Rusher:RunForward()
    if self.disable then return end
    self.isrunning = true
    self.inst:StartUpdatingComponent(self)
end

function Rusher:Stop()
    self.isrunning = false
end

---@param acc function|number
function Rusher:SetAccelerate(acc)
    self.accelerate = acc
end

---@param max number
function Rusher:SetMaxSpeedMult(max)
    self.maxspeedmult = max
end

---@param dt number
function Rusher:OnUpdate(dt) -- won't check whether components are exist or not, just use them
    if self.isrunning then
        self.runtime = self.runtime + dt
        self.speedmult = math.min(self.maxspeedmult,
            self.speedmult + FunctionOrValue(self.accelerate, self.runtime, self.speedmult, self.maxspeedmult) * self.externalaccelerate:Get() * dt)
        local spdsq = math.sqrt(math.max(1, self.speedmult))
        self.inst.AnimState:SetDeltaTimeMultiplier(spdsq)
        self.inst.components.locomotor:SetExternalSpeedMultiplier(self, self.name, self.speedmult)
        self.inst.components.hunger.burnratemodifiers:SetModifier(self, self.speedmult * spdsq, self.name)
        self.inst:AddTag("wonkey_run")
    else
        self.runtime = 0
        self.speedmult = 1
        self.inst.AnimState:SetDeltaTimeMultiplier(1)
        self.inst.components.locomotor:RemoveExternalSpeedMultiplier(self, self.name)
        self.inst.components.hunger.burnratemodifiers:RemoveModifier(self, self.name)
        self.inst:RemoveTag("wonkey_run")
        self.inst:StopUpdatingComponent(self)
    end
end

function Rusher:GetDebugString()
    return string.format("%.2f / %.2f", self.speedmult, self.maxspeedmult)
end

return Rusher
