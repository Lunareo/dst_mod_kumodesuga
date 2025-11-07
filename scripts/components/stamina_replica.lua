---@class replica
---@field stamina replica_stamina

local Base = require "components/scorebase_replica"

---@class replica_stamina: replica_scorebase
local Stamina = Class(Base, function(self, inst)
    Base._ctor(self, inst, "stamina")
end)

return Stamina