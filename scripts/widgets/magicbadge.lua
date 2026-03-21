---@class widget_badge
local Badge = require "widgets/badge"
local UIAnim = require "widgets/uianim"

local MPTINIT = { 0 / 255, 0 / 255, 255 / 255, 1 }

local MPBadge = Class(Badge, function(self, owner)
    Badge._ctor(self, nil, owner, MPTINIT, "status_magicpoint", nil, nil, true)

    self.val = 100
    self.max = 100
    self.penaltypercent = 0

    self:StartUpdating()
end)

function MPBadge:SetPercent(val, max, penaltypercent)

end

function MPBadge:OnUpdate(dt)
    if TheNet:IsServerPaused() then return end
end

return MPBadge
