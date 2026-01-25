local Builder = require "components/builder"

UTIL.FnExtend(Builder, "HasCharacterIngredient", function(self, ingredient)
    if ingredient.type == CHARACTER_INGREDIENT.MAX_SANITY_VAL then
        local sanity = self.inst.components.sanity
        if sanity ~= nil then
            local max = sanity:GetMaxWithPenalty()
            return { (max - ingredient.amount) / sanity.max > 1 - TUNING.MAXIMUM_HEALTH_PENALTY, max }, true
        end
    elseif ingredient.type == CHARACTER_INGREDIENT.HUNGER then
        local hunger = self.inst.components.hunger
        local satura = self.inst.components.satura
        if hunger ~= nil then
            local cur = hunger.current + (satura and satura.current or 0)
            return { ingredient.amount <= cur, cur }, true
        end
    end
end, function(rets, self, ingredient)
    if self.inst.prefab == "wakaba" and ingredient.type == CHARACTER_INGREDIENT.HEALTH then
        ---@class component_health
        local health = self.inst.components.health
        if health ~= nil then
            local cur = (health.currenthealth or 0) / TUNING.WAKABA_HEALTH_SCALE
            rets = { cur > ingredient.amount, cur }
        end
    end
    return rets
end)

UTIL.FnExtend(Builder, "RemoveIngredients", function(self, ingredients, recname)
    if self.freebuildmode then
        return
    end
    local recipe = GLOBAL.AllRecipes[recname]
    if recipe then
        for _, v in pairs(recipe.character_ingredients) do
            if v.type == CHARACTER_INGREDIENT.HUNGER then
                self.inst.components.hunger:DoDelta(-v.amount)
            end
        end
    end
end)

-- Sourceless real damage restrictor
UTIL.FnExtend(Builder, "_ctor", function(_, inst)
    local Health = inst.components.health
    if not Health then return end
    UTIL.FnExtend(Health, "DoDelta",
        function(self, amount, overtime, cause, ignore_invincible, afflicter, ignore_absorb, ...)
            if amount and amount < 0 and cause == nil then
                return nil, nil, { self, amount, overtime, cause, nil, afflicter, nil, ... }
            end
        end)
end)
