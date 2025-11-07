---@class components
---@field erosiondamage component_erosiondamage

local PlanarDamage = require "components/planardamage"

local SpDamageUtil = require "components/spdamageutil"

SpDamageUtil.DefineSpType("erosion", {
    GetDamage = function(ent)
        return ent.components.erosiondamage ~= nil and ent.components.erosiondamage:GetDamage() or 0
    end,
    GetDefense = function(ent)
        return ent.components.erosiondefense ~= nil and ent.components.erosiondefense:GetDefense() or 0
    end,
})

---@class component_erosiondamage: component_planardamage
local ErosionDamage = Class(PlanarDamage, function(self, inst)
    PlanarDamage._ctor(self, inst)
end)

return ErosionDamage
