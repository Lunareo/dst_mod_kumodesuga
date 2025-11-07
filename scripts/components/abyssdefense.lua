---@class components
---@field abyssdefense component_abyssdefense

local PlanarDefense = require "components/planardefense"

---@class component_abyssdefense: component_planardamage
local AbyssDefense  = Class(PlanarDefense, function(self, inst)
    PlanarDefense._ctor(self, inst)
end)

return AbyssDefense