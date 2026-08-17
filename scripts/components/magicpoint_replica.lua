---@class replica_components
---@field magicpoint replica_magicpoint

local Base = require "components/scorebase_replica"

---@class replica_magicpoint: replica_scorebase
local MagicPoint = Class(Base, function(self, inst)
    Base._ctor(self, inst, "magicpoint")
end)


return MagicPoint