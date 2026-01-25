---@class replica_builder
local Builder = require "components/builder_replica"

UTIL.FnExtend(Builder, "HasCharacterIngredient", function(self, ingredient)
    if not self.classified then return end
    if ingredient.type == CHARACTER_INGREDIENT.MAX_SANITY_VAL then
        local sanity = self.inst.replica.sanity
        if sanity ~= nil then
            local max = sanity:MaxWithPenalty()
            return { (max - ingredient.amount) / sanity:Max() > 1 - TUNING.MAXIMUM_HEALTH_PENALTY, max }, true
        end
    elseif ingredient.type == CHARACTER_INGREDIENT.HUNGER then
        local hunger = self.inst.replica.hunger
        local satura = self.inst.replica.satura
        if hunger ~= nil then
            local cur = hunger:GetCurrent() + (satura and satura:GetCurrent() or 0)
            return { ingredient.amount <= cur, cur }, true
        end
    end
end, function(rets, self, ingredient)
    if self.inst.prefab == "wakaba" and ingredient.type == CHARACTER_INGREDIENT.HEALTH then
        ---@class replica_health
        local health = self.inst.replica.health
        if health ~= nil then
            local cur = health:GetCurrent() / TUNING.WAKABA_HEALTH_SCALE
            rets = { cur > ingredient.amount, cur }
        end
    end
    return rets
end)
