local SKILL_UTIL = require "prefabs/playerskillutil"

AddComponentPostInit("drownable",
    ---@param self component_drownable
    function(self)
        UTIL.FnExtend(self, "ShouldX_InternalCheck", function(self, ...)
            local player = self.inst
            if player.components.skilltreeupdater and player.components.skilltreeupdater:IsActivated("spacemotor") then
                if SKILL_UTIL.IsActivate(player, "spacemotor") and player.components.magicpoint and player.components.magicpoint.current > 0 then
                    return { false }, true
                end
            end
        end)
    end)
