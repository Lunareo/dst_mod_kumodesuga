---@class widget_badge
local Badge = require "widgets/badge"
local UIAnim = require "widgets/uianim"

-- Sanity-badge template with a violet gauge.
local MAGIC_TINT = { 148 / 255, 0 / 255, 211 / 255, 1 }

local INCREASE_RATE_SCALE_ANIM =
{
    [RATE_SCALE.INCREASE_HIGH] = "arrow_loop_increase_most",
    [RATE_SCALE.INCREASE_MED] = "arrow_loop_increase_more",
    [RATE_SCALE.INCREASE_LOW] = "arrow_loop_increase",
}

local DECREASE_RATE_SCALE_ANIM =
{
    [RATE_SCALE.DECREASE_HIGH] = "arrow_loop_decrease_most",
    [RATE_SCALE.DECREASE_MED] = "arrow_loop_decrease_more",
    [RATE_SCALE.DECREASE_LOW] = "arrow_loop_decrease",
}

---@class widget_magicbadge: widget_badge
---@field val number # current percent (0..1)
---@field max number
---@field rate number # smoothed absolute points/second estimate
---@field lastval number|nil
---@field lastt0 number
---@field arrowdir string
local MPBadge = Class(Badge, function(self, owner)
    Badge._ctor(self, nil, owner, MAGIC_TINT, "status_sanity", nil, nil, true)

    -- Decorations copied from the sanity badge template.
    self.topperanim = self.underNumber:AddChild(UIAnim())
    self.topperanim:GetAnimState():SetBank("status_meter")
    self.topperanim:GetAnimState():SetBuild("status_meter")
    self.topperanim:GetAnimState():PlayAnimation("anim")
    self.topperanim:GetAnimState():AnimateWhilePaused(false)
    self.topperanim:GetAnimState():SetMultColour(0, 0, 0, 1)
    self.topperanim:SetScale(1, -1, 1)
    self.topperanim:SetClickable(false)
    self.topperanim:GetAnimState():SetPercent("anim", 1)

    self.circleframe:GetAnimState():Hide("frame")
    self.circleframe2 = self.underNumber:AddChild(UIAnim())
    self.circleframe2:GetAnimState():SetBank("status_sanity")
    self.circleframe2:GetAnimState():SetBuild("status_sanity")
    self.circleframe2:GetAnimState():OverrideSymbol("frame_circle", "status_meter", "frame_circle")
    self.circleframe2:GetAnimState():Hide("FX")
    self.circleframe2:GetAnimState():PlayAnimation("frame")
    self.circleframe2:GetAnimState():AnimateWhilePaused(false)

    self.magicarrow = self.underNumber:AddChild(UIAnim())
    self.magicarrow:GetAnimState():SetBank("sanity_arrow")
    self.magicarrow:GetAnimState():SetBuild("sanity_arrow")
    self.magicarrow:GetAnimState():PlayAnimation("neutral")
    self.magicarrow:GetAnimState():AnimateWhilePaused(false)
    self.magicarrow:SetClickable(false)

    self.val = 1
    self.max = 100
    self.rate = 0
    self.lastval = nil
    self.lastt0 = 0
    self.arrowdir = "neutral"

    self:StartUpdating()
end)

---@param val number # percent 0..1
---@param max number|nil
function MPBadge:SetPercent(val, max)
    val = val or 0
    max = max or self.max
    local now = GetTime()
    if self.lastval ~= nil and now > self.lastt0 and self.max > 0 then
        local r = (val - self.lastval) * self.max / (now - self.lastt0)
        self.rate = self.rate * .75 + r * .25
    end
    self.lastval = val
    self.lastt0 = now
    self.val = val
    self.max = max
    Badge.SetPercent(self, val, max)
end

function MPBadge:OnUpdate(dt)
    if TheNet:IsServerPaused() then return end

    -- No delta events while the value sits clamped at min/max,
    -- so let a stale rate estimate decay back to neutral.
    if self.lastt0 ~= nil and GetTime() - self.lastt0 > 1.5 then
        self.rate = self.rate * math.max(0, 1 - 2 * dt)
    end

    local anim = "neutral"
    if self.rate > .01 then
        if self.val < 1 then
            local ratescale =
                (self.rate > 2 and RATE_SCALE.INCREASE_HIGH) or
                (self.rate > .5 and RATE_SCALE.INCREASE_MED) or
                RATE_SCALE.INCREASE_LOW
            anim = INCREASE_RATE_SCALE_ANIM[ratescale]
        end
    elseif self.rate < -.01 then
        if self.val > 0 then
            local ratescale =
                (self.rate < -2 and RATE_SCALE.DECREASE_HIGH) or
                (self.rate < -.5 and RATE_SCALE.DECREASE_MED) or
                RATE_SCALE.DECREASE_LOW
            anim = DECREASE_RATE_SCALE_ANIM[ratescale]
        end
    end

    if self.arrowdir ~= anim then
        self.arrowdir = anim
        self.magicarrow:GetAnimState():PlayAnimation(anim, true)
    end
end

return MPBadge
