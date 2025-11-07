---@class component
---@field stamina component_stamina

local Base = require "components/scorebase"

---@class component_stamina: component_scorebase
local Stamina = Class(Base, function(self, inst)
    Base._ctor(self, inst, "stamina")
end)

return Stamina