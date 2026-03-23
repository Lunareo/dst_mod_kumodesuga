---@class components
---@field erosiondefense component_erosiondefense

local PlanarDefense = require "components/planardefense"

---@class component_erosiondefense: component_planardefense
local ErosionDefense  = Class(PlanarDefense, function(self, inst)
    PlanarDefense._ctor(self, inst)
end)

return ErosionDefense