---@class components
---@field abyssdefense component_abyssdefense

local PlanarDefense = require "components/planardefense"

---@class component_abyssdefense: component_planardefense
local AbyssDefense  = Class(PlanarDefense, function(self, inst)
    PlanarDefense._ctor(self, inst)
end)

function AbyssDefense:GetDebugString()
    return string.format("%.2f", self:GetDefense())
end

return AbyssDefense