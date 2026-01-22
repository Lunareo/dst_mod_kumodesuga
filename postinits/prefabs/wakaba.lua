local function healowner(inst, owner)
    if (owner.components.health and owner.components.health:IsHurt())
        and (owner.components.hunger and owner.components.hunger.current > 5) then
        owner.components.health:DoDelta(TUNING.REDAMULET_CONVERSION, false, "redamulet")
        owner.components.hunger:DoDelta(-TUNING.REDAMULET_CONVERSION)
        inst.components.finiteuses:Use(1)
    end
end

AddPrefabPostInit("wakaba", function(inst)
    if not TheWorld.ismastersim then return end
    local Health = inst.components.health
    UTIL.FnExtend(Health, "DoDelta",
        function(self, amount, overtime, cause, ignore_invincible, afflicter, ignore_absorb, ...)
            if amount and amount < 0 and cause == nil and (ignore_invincible or ignore_absorb) then
                return nil, nil, { self, amount, overtime, cause, nil, afflicter, nil, ... }
            end
        end)
    local Sanity = inst.components.sanity
    UTIL.FnExtend(Sanity, "IsSane", function(self, getraw)
        return { not (self:IsInsane(getraw) or self:IsEnlightened(getraw)) }, not getraw
    end)
    UTIL.FnExtend(Sanity, "IsInsane", nil, function(rets, self, getraw)
        return (getraw or 5 >= self.current) and rets or { nil }
    end)
    UTIL.FnExtend(Sanity, "IsEnlightened", nil, function(rets, self, getraw)
        return (getraw or 5 <= self.max - self.current) and rets or { nil }
    end)
    local Inventory = inst.components.inventory
    UTIL.FnExtend(Inventory, "Equip", nil, function(rets, self, item)
        if item and item.prefab == "amulet" then
            if item.task then
                item.task:Cancel()
            end
            item.task = item:DoPeriodicTask(TUNING.REDAMULET_CONVERSION_TIME, healowner, nil, self.inst)
        end
        return rets
    end)
    UTIL.FnExtend(Inventory, "RemoveItem", function(self)
        if self.inst.flag_is_stealing_by_xl then
            return nil, true
        end
    end)
    local Combat = inst.components.combat
    UTIL.FnExtend(Combat, "GetAttacked", function(self, ...)
        local dodge = self.inst and self.inst.components.parryable
        return { true }, dodge and dodge:GetAttacked(...)
    end)
end)
