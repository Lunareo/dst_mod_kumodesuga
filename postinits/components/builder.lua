local Builder = require "components/builder"

local function getglandamount(inst, healthneed)
    local health = (inst.components.health and inst.components.health.currenthealth or 0)
    local glandneed = math.ceil(math.max(0, healthneed - health) / TUNING.HEALING_MEDSMALL)
    healthneed = healthneed - glandneed * TUNING.HEALING_MEDSMALL
    return healthneed, glandneed
end

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
        local retamount = rets and #rets >= 2 and rets[2] or nil
        local _, glandamount = getglandamount(self.inst, ingredient.amount)
        local enough, gland = self.inst.components.inventory:Has("spidergland", glandamount, true)
        rets = { enough, (retamount or 0) + gland * TUNING.HEALING_MEDSMALL }
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
            elseif self.inst.prefab == "wakaba" and v.type == CHARACTER_INGREDIENT.HEALTH then
                local amount, glandamount = getglandamount(self.inst, v.amount)
                self._glandashealth = glandamount
                local oldamount = v.amount
                v.amount = amount
                StartThread(function()
                    Yield()
                    v.amount = oldamount
                end)
            end
        end
    end
end, function(rets, self, ingredients, recname)
    if self.freebuildmode or not self._glandashealth then
        return
    end
    self.inst.components.inventory:ConsumeByName("spidergland", self._glandashealth)
    self._glandashealth = nil
end)

-- Sourceless real damage restrictor
UTIL.FnExtend(Builder, "_ctor", function(_, inst)
    local Health = inst.components.health
    if not Health then return end
    UTIL.FnExtend(Health, "DoDelta",
        function(self, amount, overtime, cause, ignore_invincible, afflicter, ignore_absorb, ...)
            if amount and amount < 0 and cause == nil then
                return nil, nil, { self, cause, overtime, cause, nil, afflicter, nil, ... }
            end
        end)
end)
