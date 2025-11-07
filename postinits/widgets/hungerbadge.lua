local UIAnim = require "widgets/uianim"
local HungerBadge = require "widgets/hungerbadge"
-- local TINT = { 255 / 255, 204 / 255, 51 / 255, 1 }
--local OVERTINT = WEBCOLOURS.ORANGE
UTIL.FnExtend(HungerBadge, "_ctor",
    nil,
    function(rets, self, owner)
        self.marker = self:AddChild(UIAnim())
        self.marker:GetAnimState():SetBank("status_wet_wx")
        self.marker:GetAnimState():SetBuild("status_wet_wx")
        self.marker:GetAnimState():AnimateWhilePaused(false)
        self.marker:SetClickable(true)
        self.marker:GetAnimState():SetPercent("anim", .3)
        -- self.marker:SetScale(1, 1, 1)
    end)
