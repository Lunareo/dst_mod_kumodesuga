---@class component_aoetargeting
local AoeTargeting = require "components/aoetargeting"
UTIL.FnExtend(AoeTargeting, "StartTargeting", function(self)
    if self.inst.components.reticule ~= nil then
        self.inst:RemoveComponent("reticule")
    end
    if self.inst == ThePlayer and self.inst.components.spellbook ~= nil then
        if ThePlayer.components.playercontroller ~= nil then
            ThePlayer:AddComponent("reticule")
            for k, v in pairs(self.reticule) do
                ThePlayer.components.reticule[k] = v
            end
            ThePlayer.components.playercontroller:RefreshReticule(ThePlayer)
        end
        return nil, true
    end
end)