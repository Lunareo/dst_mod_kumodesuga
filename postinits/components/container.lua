local Container = require("components/container")

UTIL.FnExtend(Container, "CanTakeItemInSlot", function(self, item, slot)
    if self.inst.prefab == "other_space_3x4" and item ~= nil and item:HasTag("heavy") then
        return { true }, true
    end
end)
