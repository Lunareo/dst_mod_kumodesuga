local StatusDisplays = require "widgets/statusdisplays"
local MagicBadge = require "widgets/magicbadge"
local TINT = { 255 / 255, 204 / 255, 51 / 255, 1 }
local OVERTINT = { 224 / 255, 100 / 255, 38 / 255, 1 }

modimport "postinits/widgets/hungerbadge"

UTIL.FnExtend(StatusDisplays, "_ctor",
    nil,
    function(rets, self, owner)
        owner:ListenForEvent("saturadelta", function(inst, data)
            local hunger = inst.replica and inst.replica.hunger
            if hunger ~= nil then
                self:SetHungerPercent(hunger:GetPercent())
            end
        end)
        if owner:HasTag("beyond_sanity") then
            self.brain:Hide()
            self.brain.Show = self.brain.Hide
        end
        if owner.CreateMagicBadge then
            self:AddMagic()
        end
    end)

UTIL.FnExtend(StatusDisplays, "SetHungerPercent",
    function(self, pct)
        local satura = self.owner and self.owner.replica and self.owner.replica.satura
        if satura and satura:IsSaturated() then
            self.stomach.anim:GetAnimState():SetMultColour(unpack(OVERTINT))
            self.stomach.marker:Show()
            self.stomach:SetPercent(satura:GetCurrent() / satura:Max(), satura:Max())
            if self.stomach.circleframe ~= nil then
                self.stomach.circleframe:GetAnimState():SetPercent("frame", 0)
                local hunger = self.owner.replica.hunger
                local hungermx = hunger and hunger:Max() or 0
                self.stomach.num:SetString(tostring(math.ceil(satura:GetCurrent() + hungermx)))
            end
            return nil, true
        else
            self.stomach.marker:Hide()
            self.stomach.anim:GetAnimState():SetMultColour(unpack(TINT))
            return
        end
    end)

UTIL.FnExtend(StatusDisplays, "SetGhostMode",
    nil,
    function(rets, self, ghostmode)
        if self.magic ~= nil then
            if ghostmode then
                self.magic:Hide()
            else
                self.magic:Show()
            end
        end
    end)

function StatusDisplays:AddMagic()
    if self.isghostmode then return end
    self.magic = self:AddChild(MagicBadge(self.owner))
    self.magic:SetPosition(self.brain:GetPosition())
    self.owner:ListenForEvent("magicpointdelta", function(inst, data)
        if self.magic ~= nil and data ~= nil and data.max > 0 then
            self.magic:SetPercent(data.current / data.max, data.max)
        end
    end)
    self.owner:DoTaskInTime(0, function (inst)
        if inst.replica.magicpoint ~= nil then
            self.magic:SetPercent(inst.replica.magicpoint:GetPercent(), inst.replica.magicpoint:GetMax())
        end
    end)
end
