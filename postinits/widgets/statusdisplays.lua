local StatusDisplays = require "widgets/statusdisplays"
local TINT = { 255 / 255, 204 / 255, 51 / 255, 1 }
local OVERTINT = { 224 / 255, 100 / 255, 38 / 255, 1 }

modimport "postinits/widgets/hungerbadge"

UTIL.FnExtend(StatusDisplays, "_ctor",
    nil,
    function(rets, self, owner)
        owner:ListenForEvent("saturadelta", function(inst, data)
            self:SetHungerPercent(inst.replica.hunger:GetPercent())
        end)
    end)
UTIL.FnExtend(StatusDisplays, "SetHungerPercent",
    function(self, pct)
        local satura = self.owner and self.owner.replica.satura
        if satura and satura:IsSaturated() then
            self.stomach.anim:GetAnimState():SetMultColour(unpack(OVERTINT))
            self.stomach.marker:Show()
            self.stomach:SetPercent(satura:GetCurrent() / satura:Max(), satura:Max())
            if self.stomach.circleframe ~= nil then
                self.stomach.circleframe:GetAnimState():SetPercent("frame", 0)
                self.stomach.num:SetString(tostring(math.ceil(satura:GetCurrent() + self.owner.replica.hunger:Max())))
            end
            return nil, true
        else
            self.stomach.marker:Hide()
            self.stomach.anim:GetAnimState():SetMultColour(unpack(TINT))
            return
        end
    end)
