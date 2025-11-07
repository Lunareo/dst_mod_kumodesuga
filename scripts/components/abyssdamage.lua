---@class components
---@field abyssdamage component_abyssdamage

local PlanarDamage = require "components/planardamage"

local SpDamageUtil = require "components/spdamageutil"

SpDamageUtil.DefineSpType("abyss", {
    GetDamage = function(ent)
        return ent.components.abyssdamage ~= nil and ent.components.abyssdamage:GetDamage() or 0
    end,
    GetDefense = function(ent)
        return ent.components.abyssdefense ~= nil and ent.components.abyssdefense:GetDefense() or 0
    end,
})

---@class component_abyssdamage: component_planardamage
local AbyssDamage = Class(PlanarDamage, function(self, inst)
    PlanarDamage._ctor(self, inst)
end)

return AbyssDamage