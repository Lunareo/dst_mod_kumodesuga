---@class replica
---@field accela replica_accela

local Base = require "components/scorebase_replica"

---@class replica_accela: replica_scorebase
local Accela = Class(Base, function(self, inst)
    Base._ctor(self, inst, "accela")
end)

return Accela