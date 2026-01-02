---@class SourceModifierList
local SourceModifierList = require"util/sourcemodifierlist"

local CombatAware = Class(function(self, inst)
    self.inst = inst
    self.awaresources = SourceModifierList(inst, false, SourceModifierList.boolean)
end)

---@param target ent|nil 
function CombatAware:SetTarget(target)
end

---@param doer ent
function CombatAware:AddAwaredSource(doer)
end

---@param doer ent
function CombatAware:RemoveAwaredSource(doer)
end

return CombatAware