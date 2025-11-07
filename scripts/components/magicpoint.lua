---@class component
---@field magicpoint component_magicpoint

local Base = require "components/scorebase"

---@class component_magicpoint: component_scorebase
local Magicpoint = Class(Base, function(self, inst)
    Base._ctor(self, inst, "magicpoint")
end)

return Magicpoint