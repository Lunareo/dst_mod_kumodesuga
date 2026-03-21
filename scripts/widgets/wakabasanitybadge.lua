local SanityBadge = require "widgets/sanitybadge"

---@class widget_wakabasanitybadge: widget_sanitybadge
local WSanityBadge = Class(SanityBadge, function (self, owner)
    SanityBadge._ctor(self, owner)

    if self.sanityarrow ~= nil then
        self.sanityarrow:GetAnimState():SetBuild("")
    end

    if self.num ~= nil then
        self.num.Show = function() end
        self.num:Hide()
    end
end)

function WSanityBadge:SetPercent(val, max, penaltypercent)
    local sanity = self.owner and self.owner.replica.sanity
    val = sanity and sanity:IsInsane() and 0 or sanity:IsEnlightened() and 1 or .5 
    return SanityBadge.SetPercent(self, val, max, penaltypercent)
end

function WSanityBadge:PulseGreen()
end

function WSanityBadge:PulseRed()
    return SanityBadge._base.PulseRed(self)
end

function WSanityBadge:OnUpdate(dt)
    SanityBadge.OnUpdate(self, dt)
    local sanity = self.owner and self.owner.replica.sanity
    if sanity then
        if sanity:IsInsane() or sanity:IsEnlightened() then
            self:Show()
        else
            self:Hide()
        end
    end
end

return WSanityBadge