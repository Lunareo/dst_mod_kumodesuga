local Builder = require "components/builder_replica"

local function getglandamount(inst, healthneed)
    local health = (inst.replica.health and inst.replica.health:GetCurrent() or 0)
    local glandneed = math.ceil(math.max(0, healthneed - health) / TUNING.HEALING_MEDSMALL)
    healthneed = healthneed - glandneed * TUNING.HEALING_MEDSMALL
    return healthneed, glandneed
end

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
        local retamount = rets and #rets >= 2 and rets[2] or nil
        local _, glandamount = getglandamount(self.inst, ingredient.amount)
        local enough, gland = self.inst.replica.inventory:Has("spidergland", glandamount, true)
        rets = { enough, (retamount or 0) + gland * TUNING.HEALING_MEDSMALL }
    end
    return rets
end)
