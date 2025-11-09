local Base = require "skills/base"

local NightVision = Class(Base, function(self, inst, root)
    Base._ctor(self, inst, root)
    self.name = "nightvision"
    self.update = net_bool(self.inst.GUID, "skills.nightvision.update", "skills.nightvision.updatedirty")
    self.activate = net_bool(self.inst.GUID, "skills.nightvision.activate", "skills.nightvision.activatedirty")
    self.inst:ListenForEvent("skills.nightvision.updatedirty", function() self:ToggleNightVision() end)
end)

function NightVision:Activate()
    self.update:set(true)
end

function NightVision:Deactivate()
    self.update:set(false)
end

function NightVision:ToggleNightVision(on)
    on = on or not self.activate:value()
    self.activate:set(on)
end