local high_satu_percent = .7
local min_speed_mult = 1 - (1 - high_satu_percent) / 2
local UPDATE_PERIOD = 1

-------------------------------------------------------------------------

local function onmax(self, max, old)
    if max == nil or max == old then return end
    self.inst.replica.satura:SetMax(max)
end

local function oncurrent(self, current, old)
    if current == nil or current == old then return end
    self.inst.replica.satura:SetCurrent(current)
    if self:IsHighsaturated() and not self.inst:HasTag("strongman") then
        self.inst.components.locomotor:SetExternalSpeedMultiplier(self.inst, "oversaturation",
            Lerp(1, min_speed_mult,
                (math.clamp(self:GetPercent(), high_satu_percent, 1) - high_satu_percent) / (1 - high_satu_percent)))
    else
        self.inst.components.locomotor:RemoveExternalSpeedMultiplier(self.inst, "oversaturation")
    end
end

------------------------------------------------------------------------

local function OnTaskTick(inst, self)
    self:DoDec(UPDATE_PERIOD)
end

----------------------------------------------------------------------------------------------------

local Satura = Class(function(self, inst)
        self.inst = inst
        self.max = 50
        self.current = 0

        self.burning = true

        local hunger = inst.components.hunger
        local onhungermax = getsetter(hunger, "max")
        addsetter(hunger, "max", function(t, n)
            if onhungermax then
                onhungermax(t, n)
            end
            self:SetMax(n and n / 2 or 50)
        end)
    end,
    nil,
    {
        max = onmax,
        current = oncurrent,
    })

----------------------------------------------------------------------------------------------------

function Satura:SetMax(amount)
    self.max = amount
    -- self.current = amount
end

function Satura:IsPaused()
    return not self.burning
end

function Satura:IsSaturated()
    return self.current > 0
end

function Satura:IsHighsaturated()
    return self.current >= self.max * high_satu_percent
end

function Satura:IsOversaturated()
    return self.current >= self.max
end

----------------------------------------------------------------------------------------------------

function Satura:Pause()
    self.burning = false

    if self.updatetask ~= nil then
        self.updatetask:Cancel()
        self.updatetask = nil
    end
end

function Satura:Resume()
    self.burning = true

    if self.updatetask == nil then
        self.updatetask = self.inst:DoPeriodicTask(UPDATE_PERIOD, OnTaskTick, nil, self)
    end
end

----------------------------------------------------------------------------------------------------

function Satura:GetPercent()
    return self.current / self.max
end

function Satura:SetPercent(p, overtime)
    self:SetCurrent(p * self.max)
end

----------------------------------------------------------------------------------------------------

function Satura:SetCurrent(current)
    local old = self.current

    self.current = math.clamp(current, 0, self.max)

    self.inst:PushEvent("saturadelta", {
        oldpercent = old / self.max,
        newpercent = self.current / self.max,
        delta = self.current - old
    })
end

function Satura:DoDelta(delta, overtime, ignore_invincible)
    if self.redirect ~= nil then
        self.redirect(self.inst, delta, overtime)

        return
    end

    if not ignore_invincible and
        self.inst.components.health and
        self.inst.components.health:IsInvincible() or
        self.inst.is_teleporting
    then
        return
    end

    self:SetCurrent(self.current + delta)
end

function Satura:DoDec(dt)
    if self:IsPaused() then
        return
    end

    -- if self.current > 0 then
    --     self:DoDelta(-self.saturarate * dt * self.burnrate * self.burnratemodifiers:Get(), true)
    -- end
end

----------------------------------------------------------------------------------------------------

function Satura:LongUpdate(dt)
    self:DoDec(dt)
end

function Satura:TransferComponent(newinst)
    newinst.components.satura:SetPercent(self:GetPercent())
end

----------------------------------------------------------------------------------------------------

function Satura:OnSave()
    return self.current ~= self.max and { satura = self.current } or nil
end

function Satura:OnLoad(data)
    if data.satura ~= nil and self.current ~= data.satura then
        self.current = data.satura
        self:DoDelta(0)
    end
end

----------------------------------------------------------------------------------------------------

function Satura:OnRemoveFromEntity()
    if self.updatetask ~= nil then
        self.updatetask:Cancel()
        self.updatetask = nil
    end
end

function Satura:GetDebugString()
    return string.format(
        "%2.1f/%2.1f | Paused: %s",
        self.current, self.max,
        tostring(self:IsPaused())
    )
end

----------------------------------------------------------------------------------------------------

return Satura
