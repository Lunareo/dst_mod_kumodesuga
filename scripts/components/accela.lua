---@class component
---@field accela component_accela

local Base = require "components/scorebase"

---@class component_accela: component_scorebase
local Accela = Class(Base, function(self, inst)
    Base._ctor(self, inst, "accela")
end)

return Accela