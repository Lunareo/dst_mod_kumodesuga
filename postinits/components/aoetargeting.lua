---@class component_aoetargeting
local AoeTargeting = require "components/aoetargeting"
UTIL.FnExtend(AoeTargeting, "StartTargeting", function(self)
    if self.inst.components.reticule ~= nil then
        self.inst:RemoveComponent("reticule")
    end
end)