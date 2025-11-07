---@class replica
---@field magicpoint replica_magicpoint

local Base = require "components/scorebase_replica"

---@class replica_magicpoint: replica_scorebase
local Magicpoint = Class(Base, function(self, inst)
    Base._ctor(self, inst, "magicpoint")
end)

return Magicpoint