AddComponentPostInit("drownable",
    ---@param self component_drownable
    function(self)
        UTIL.FnExtend(self, "ShouldX_InternalCheck", function(self, ...)
            if self.inst.components.skilltreeupdater and self.inst.components.skilltreeupdater:IsActivated("spacemotor") then
                return { false }, true
            end
        end)
    end)
