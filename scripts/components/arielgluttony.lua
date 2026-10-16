local Combat = require "ariel_combat"
local HasSkill = Combat.HasSkill

---@class component_arielgluttony: component_base
---@field current number
---@field max number
---@field wear number
local Gluttony = Class(function(self, inst)
    self.inst = inst
    self.current = 0
    self.max = TUNING.ARIEL.pool
    self.wear = 0
    self.timers = {}
    self.combatleft = 0
    self.nurture = 0
    self._onhit = function(_, data)
        local weapon = data ~= nil and data.weapon or nil
        local ranged = weapon ~= nil and (weapon:HasTag("rangedweapon")
            or weapon.components.projectile ~= nil
            or (weapon.components.weapon ~= nil and weapon.components.weapon.projectile ~= nil))
        if data ~= nil and Combat.IsEnemy(inst, data.target) and not data.redirected
            and not ranged and data.stimuli ~= "abyss" and not inst.components.rider:IsRiding()
            and (data.damageresolved or data.damage or 0) > 0 then
            self.combatleft = TUNING.ARIEL.combat_window
            self:DoDelta(TUNING.ARIEL.hit_gain * (weapon == nil and self:IsHumility() and 2 or 1))
            if weapon == nil then Combat.Knockback(inst, data.target) end
            if inst.components.arielcommander ~= nil then inst.components.arielcommander:Focus(data.target) end
        end
    end
    self._onattacked = function(_, data)
        if data ~= nil and Combat.IsEnemy(inst, data.attacker) and not data.redirected
            and (data.damageresolved or data.damage or 0) > 0 then
            self.combatleft = TUNING.ARIEL.combat_window
            inst.components.arielcommander:Focus(data.attacker)
        end
    end
    -- 在原版食用结算末端取得营养值：包含新鲜度、吸收率和食物记忆，满饥饿仍可储能。
    self._statsmod = inst.components.eater.custom_stats_mod_fn
    self._foodstats = function(eater, health, hunger, sanity, food, feeder)
        if self._statsmod ~= nil then
            health, hunger, sanity = self._statsmod(eater, health, hunger, sanity, food, feeder)
        end
        self._foodenergy = math.max(0, hunger) * TUNING.ARIEL.food_ratio
        return health, hunger, sanity
    end
    inst.components.eater.custom_stats_mod_fn = self._foodstats
    self._oneat = function(_, data)
        local food = data ~= nil and data.food or nil
        if food == nil then return end
        self:DoDelta(self._foodenergy or 0)
        self._foodenergy = nil
        local name = (food.prefab or "") .. (food.name or "")
        for _, key in ipairs(TUNING.DRUNK_KEYS) do
            if string.find(name, key, 1, true) then
                self.timers.tipsy = TUNING.ARIEL.tipsy_duration
                self:Refresh()
                break
            end
        end
    end
    self._ondeath = function()
        if self:IsHumility() then self.timers.exhaustion = TUNING.ARIEL.exhaustion_duration end
        self.timers.humility = nil
        self:Refresh()
    end
    self._onskill = function() self:Refresh() end
    inst:ListenForEvent("onhitother", self._onhit)
    inst:ListenForEvent("attacked", self._onattacked)
    inst:ListenForEvent("oneat", self._oneat)
    inst:ListenForEvent("death", self._ondeath)
    inst:ListenForEvent("ms_respawnedfromghost", self._onskill)
    inst:ListenForEvent("onactivateskill_server", self._onskill)
    inst:ListenForEvent("ondeactivateskill_server", self._onskill)
    inst:StartUpdatingComponent(self)
end)

function Gluttony:IsHumility() return (self.timers.humility or 0) > 0 end
function Gluttony:IsExhausted() return (self.timers.exhaustion or 0) > 0 end
function Gluttony:IsReady(name) return (self.timers[name] or 0) <= 0 end
function Gluttony:GetTier()
    if self:IsExhausted() or not Combat.IsAlive(self.inst) then return 0 end
    for i = 3, 1, -1 do
        if self.current >= TUNING.ARIEL.thresholds[i] then return i end
    end
    return 0
end

function Gluttony:DoDelta(amount)
    self.current = math.clamp(self.current + amount, 0, self.max)
    self:Refresh()
end

function Gluttony:Cost(amount)
    if not Combat.IsAlive(self.inst) or self:IsExhausted() or self.current < amount then return false end
    self:DoDelta(-amount)
    return true
end

function Gluttony:ApplyWear()
    local health = self.inst.components.health
    -- SetMaxHealth 会补满当前生命；这里只改变上限，不能靠温养或读档获得免费治疗。
    health.maxhealth = TUNING.ARIEL_HEALTH - self.wear
    health:ForceUpdateHUD(true)
    if self.inst._arielwear ~= nil then self.inst._arielwear:set(self.wear) end
end

function Gluttony:CanWear(amount)
    return TUNING.ARIEL_HEALTH - self.wear - amount >= TUNING.ARIEL.min_health
end

function Gluttony:AddWear(amount)
    if not self:CanWear(amount) then return false end
    self.wear = self.wear + amount
    self:ApplyWear()
    return true
end

function Gluttony:Nurture()
    self.nurture = TUNING.ARIEL.nurture_duration
end

function Gluttony:StartHumility()
    local cfg = TUNING.ARIEL
    local wear = self.inst.components.health:GetMaxWithPenalty() * cfg.humility_wear
        * (HasSkill(self.inst, "temperance") and .8 or 1)
    if not self:IsReady("humility_cd") or self:IsExhausted() or not Combat.IsAlive(self.inst)
        or self.inst.components.sanity.current < cfg.humility_sanity or not self:CanWear(wear) then return false end
    self:AddWear(wear)
    self.inst.components.sanity:DoDelta(-cfg.humility_sanity)
    self.timers.humility = cfg.humility_duration + (HasSkill(self.inst, "last_stand") and 5 or 0)
    self.timers.humility_cd = cfg.humility_cooldown
    self:Refresh()
    return true
end

function Gluttony:Refresh()
    local inst, cfg = self.inst, TUNING.ARIEL
    self.max = cfg.pool + (HasSkill(inst, "reservoir") and cfg.pool_bonus or 0)
    self.current = math.min(self.current, self.max)
    local tier = self:GetTier()
    local alive = Combat.IsAlive(inst)
    local humility = alive and self:IsHumility()
    local exhausted = alive and self:IsExhausted()
    local tipsy = alive and not exhausted and not self:IsReady("tipsy")
    local damage = (cfg.damage[tier] or 1) * (humility and 2 or exhausted and .5 or 1)
        * (tipsy and cfg.tipsy_damage or 1)
    if tier > 0 and HasSkill(inst, "satiated") then damage = damage * 1.1 end
    inst.components.combat.externaldamagemultipliers:SetModifier(inst, damage, "ariel")
    inst.components.combat.externaldamagetakenmultipliers:SetModifier(inst, cfg.physical_resist, "ariel")
    inst.components.health.externalabsorbmodifiers:SetModifier(inst, humility and .4 or 0, "ariel_humility")
    inst.components.sanity.externalmodifiers:SetModifier(inst, tipsy and cfg.tipsy_sanity or 0, "ariel_tipsy")
    local riding = inst.components.rider:IsRiding()
    local speed = (not alive or riding) and 1 or cfg.speed * (tier == 3 and 1.1 or 1) * (humility and 1.25 or exhausted and .6 or 1)
    inst.components.locomotor:SetExternalSpeedMultiplier(inst, "ariel", speed)
    self.damage = damage
    inst._arielpool:set(self.current)
    inst._arielmax:set(self.max)
    inst._arieltier:set(tier)
    inst._arielstance:set(humility and 1 or exhausted and 2 or 0)
end

-- 所有入口共享同一权限边界；不能因物品可入背包就跳过活物、打包和容器保护。
function Gluttony:CanDevour(item)
    if not Combat.IsAlive(self.inst) or item == nil or not item:IsValid()
        or item == self.inst or item:HasTag("player") or item:HasTag("irreplaceable")
        or item:HasTag("companion") or item:HasTag("ariel_puppet")
        or item:HasTag("bundle") or item.components.unwrappable ~= nil
        or item:HasTag("smallcreature") or item.components.health ~= nil
        or item.components.workable ~= nil or item:HasTag("structure") then return false end
    if item.components.container ~= nil and not item.components.container:IsEmpty() then return false end
    local projectile = item.components.projectile or item.components.complexprojectile
    if projectile ~= nil and item:HasTag("activeprojectile") then
        if self:IsExhausted() or item:IsInLimbo() or not self.inst:IsNear(item, 3) then return false end
        local attacker = projectile.attacker or projectile.owner
        if attacker ~= nil and attacker.components.combat == nil and attacker.components.inventoryitem ~= nil then
            attacker = attacker.components.inventoryitem:GetGrandOwner()
        end
        return Combat.IsEnemy(self.inst, attacker)
    end
    local inventoryitem = item.components.inventoryitem
    if inventoryitem ~= nil then
        local owner = inventoryitem:GetGrandOwner()
        if owner ~= nil and owner ~= self.inst then return false end
        if owner == nil and (item:IsInLimbo() or not self.inst:IsNear(item, 3)) then return false end
        if item.components.edible ~= nil then return self.inst.components.eater:PrefersToEat(item) end
        return not self:IsExhausted()
    end
    return false
end

function Gluttony:Devour(item)
    if not self:CanDevour(item) then return false end
    if item.components.edible ~= nil then
        return self.inst.components.eater:Eat(item)
    end
    local energy = item.components.equippable ~= nil and 15 or 5
    if item:HasTag("gem") or item:HasTag("bone") or item.prefab == "boneshard" then energy = 25 end
    local finite = item.components.finiteuses or item.components.armor or item.components.fueled
    if finite ~= nil then energy = energy * math.clamp(finite:GetPercent(), 0, 1) end
    if HasSkill(self.inst, "conversion") then energy = energy * 1.25 end
    local portion = item.components.stackable ~= nil and item.components.stackable:Get() or item
    if portion.components.inventoryitem ~= nil then portion.components.inventoryitem:RemoveFromOwner(true) end
    portion:Remove()
    self.inst.components.hunger:DoDelta(TUNING.ARIEL.material_hunger)
    self:DoDelta(energy)
    return true
end

function Gluttony:OnUpdate(dt)
    local was_humility = self:IsHumility()
    for name, remaining in pairs(self.timers) do
        self.timers[name] = remaining > dt and remaining - dt or nil
    end
    if was_humility and not self:IsHumility() then self.timers.exhaustion = TUNING.ARIEL.exhaustion_duration end
    if not Combat.IsAlive(self.inst) then self:Refresh(); return end
    self.combatleft = math.max(0, self.combatleft - dt)
    if self.combatleft == 0 and not self:IsHumility() and not HasSkill(self.inst, "endless") then
        self.current = math.max(0, self.current - TUNING.ARIEL.decay * dt * (self:GetTier() == 3 and 2 or 1))
    end
    if self.nurture > 0 and not self:IsExhausted() then
        local elapsed = math.min(dt, self.nurture)
        self.nurture = self.nurture - elapsed
        self.wear = math.max(0, self.wear - elapsed * TUNING.ARIEL.nurture_amount / TUNING.ARIEL.nurture_duration)
        self:ApplyWear()
    end
    local regen = TUNING.ARIEL.regen[self:GetTier()] or 0
    if regen > 0 then self.inst.components.health:DoDelta(regen * dt, true, "ariel_gluttony") end
    self:Refresh()
end

function Gluttony:OnSave()
    return { version = 1, current = self.current, wear = self.wear, timers = self.timers,
        nurture = self.nurture, combatleft = self.combatleft }
end

function Gluttony:OnLoad(data)
    if data == nil then return end
    self.current = math.clamp(tonumber(data.current) or 0, 0, TUNING.ARIEL.pool + TUNING.ARIEL.pool_bonus)
    self.wear = math.clamp(tonumber(data.wear) or 0, 0, TUNING.ARIEL_HEALTH - TUNING.ARIEL.min_health)
    self.timers = data.timers or {}
    self.nurture = math.clamp(tonumber(data.nurture) or 0, 0, TUNING.ARIEL.nurture_duration)
    self.combatleft = math.clamp(tonumber(data.combatleft) or 0, 0, TUNING.ARIEL.combat_window)
    -- health 的 OnLoad 可能晚于本组件，延迟重算上限但不改变存档的当前血量。
    self.inst:DoTaskInTime(0, function() self:ApplyWear(); self:Refresh() end)
end

function Gluttony:OnRemoveFromEntity()
    self.inst:StopUpdatingComponent(self)
    self.inst:RemoveEventCallback("onhitother", self._onhit)
    self.inst:RemoveEventCallback("attacked", self._onattacked)
    self.inst:RemoveEventCallback("oneat", self._oneat)
    self.inst:RemoveEventCallback("death", self._ondeath)
    self.inst:RemoveEventCallback("ms_respawnedfromghost", self._onskill)
    self.inst:RemoveEventCallback("onactivateskill_server", self._onskill)
    self.inst:RemoveEventCallback("ondeactivateskill_server", self._onskill)
    if self.inst.components.eater.custom_stats_mod_fn == self._foodstats then
        self.inst.components.eater.custom_stats_mod_fn = self._statsmod
    end
end

return Gluttony
