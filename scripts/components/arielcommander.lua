local Combat = require "ariel_combat"
local HasSkill = Combat.HasSkill

---@class component_arielcommander: component_base
local Commander = Class(function(self, inst)
    self.inst = inst
    self.puppets = {}
    self.spiders = {}
    self.guard = nil
    self._night = function(_, night)
        if night then self:DismissSpiders() end
    end
    inst:WatchWorldState("isnight", self._night)
    self.task = inst:DoPeriodicTask(1, function() self:Tick() end)
end)

function Commander:CountSpiders()
    local n = 0
    for spider in pairs(self.spiders) do
        if spider:IsValid() and not spider:HasTag("spiderqueen") then n = n + 1 end
    end
    return n
end

function Commander:Recruit(target)
    if not Combat.IsAlive(self.inst) or not Combat.IsAlive(target) or not self.inst:IsNear(target, 4)
        or not (target:HasTag("spider") or target:HasTag("spiderqueen")) then return false end
    local follower = target.components.follower
    if follower ~= nil and follower:GetLeader() ~= nil then return false end
    if target.components.combat ~= nil and target.components.combat.target == self.inst then return false end
    local cfg = TUNING.ARIEL
    local queen = target:HasTag("spiderqueen")
    local gluttony = self.inst.components.arielgluttony
    if queen then
        if not gluttony:IsReady("queen_cd") then return false end
        for spider in pairs(self.spiders) do if spider:HasTag("spiderqueen") then return false end end
    elseif self:CountSpiders() >= cfg.spider_limit * (HasSkill(self.inst, "legion") and 2 or 1) then
        return false
    end
    if follower == nil then target:AddComponent("follower"); follower = target.components.follower end
    self.inst.components.leader:AddFollower(target)
    local duration = queen and cfg.queen_duration * (HasSkill(self.inst, "queen") and 2 or 1) or TUNING.TOTAL_DAY_TIME
    follower:AddLoyaltyTime(duration)
    self.spiders[target] = { time = duration, far = 0 }
    if queen then
        -- 女王原脑没有 Follow，受统御时替换为跟随战斗脑；解除后立即归还原脑。
        target:SetBrain(require "brains/arielpuppetbrain")
        gluttony.timers.queen_cd = cfg.queen_cooldown
    end
    return true
end

function Commander:Release(spider)
    local state = self.spiders[spider]
    self.spiders[spider] = nil
    if not spider:IsValid() then return end
    if spider.components.follower ~= nil and spider.components.follower:GetLeader() == self.inst then
        self.inst.components.leader:RemoveFollower(spider)
    end
    if spider:HasTag("spiderqueen") then spider:SetBrain(require "brains/spiderqueenbrain") end
    if state ~= nil then spider._ariel_guard = nil end
end

function Commander:DismissSpiders()
    local list = {}
    for spider in pairs(self.spiders) do list[#list + 1] = spider end
    for _, spider in ipairs(list) do self:Release(spider) end
end

function Commander:Summon(kind)
    if kind < 1 or kind > 4 or kind ~= math.floor(kind) or not Combat.IsAlive(self.inst) then return false end
    local existing = self.puppets[kind]
    local cfg, gluttony = TUNING.ARIEL, self.inst.components.arielgluttony
    local inv = self.inst.components.inventory
    if existing ~= nil and existing:IsValid() then return false end
    if not gluttony:IsReady("puppet_" .. kind) or self.inst.components.hunger.current < cfg.summon_hunger
        or not inv:Has("ariel_puppetsilk", 1) then return false end
    local puppet = SpawnPrefab("ariel_puppet_" .. kind)
    if puppet == nil then return false end
    inv:ConsumeByName("ariel_puppetsilk", 1)
    self.inst.components.hunger:DoDelta(-cfg.summon_hunger)
    gluttony.timers["puppet_" .. kind] = cfg.summon_cooldown
    self:AttachPuppet(kind, puppet)
    return true
end

function Commander:AttachPuppet(kind, puppet)
    self.puppets[kind] = puppet
    puppet.Transform:SetPosition(self.inst.Transform:GetWorldPosition())
    self.inst.components.leader:AddFollower(puppet)
    puppet.components.follower.keepdeadleader = true
    puppet._ariel_guard = self.guard
    puppet.components.combat.externaldamagemultipliers:SetModifier(self.inst,
        HasSkill(self.inst, "puppeteer") and 1.25 or 1, "ariel_puppeteer")
end

function Commander:Focus(target)
    if not Combat.IsEnemy(self.inst, target) then return false end
    for _, puppet in pairs(self.puppets) do
        if Combat.IsAlive(puppet) and puppet:IsNear(target, 25) then puppet.components.combat:SetTarget(target) end
    end
    for spider in pairs(self.spiders) do
        if Combat.IsAlive(spider) and spider:IsNear(target, 25) then spider.components.combat:SetTarget(target) end
    end
    return true
end

function Commander:SetGuard(pos)
    self.guard = pos ~= nil and Vector3(pos.x, 0, pos.z) or nil
    for _, puppet in pairs(self.puppets) do
        if puppet:IsValid() then
            puppet._ariel_guard = self.guard
            puppet.components.combat:SetTarget(nil)
        end
    end
    return true
end

function Commander:Tick()
    local cfg = TUNING.ARIEL
    for spider, state in pairs(self.spiders) do
        state.time = state.time - 1
        state.far = spider:IsValid() and not self.inst:IsNear(spider, cfg.leash_distance) and state.far + 1 or 0
        if not Combat.IsAlive(spider) or state.time <= 0 or state.far >= 10
            or spider.components.follower:GetLeader() ~= self.inst then self:Release(spider) end
    end
    local count = 0
    for kind, puppet in pairs(self.puppets) do
        if not Combat.IsAlive(puppet) then
            self.puppets[kind] = nil
        else
            count = count + 1
            puppet.components.combat.externaldamagemultipliers:SetModifier(self.inst,
                HasSkill(self.inst, "puppeteer") and 1.25 or 1, "ariel_puppeteer")
        end
    end
    if Combat.IsAlive(self.inst) and count > 0 then self.inst.components.hunger:DoDelta(-count * cfg.puppet_hunger, true) end
end

function Commander:OnSave()
    local records = {}
    -- 操偶不另存世界实体，随玩家记录保存；断线/换分片不会留下另一份可重复领取的物资。
    for kind, puppet in pairs(self.puppets) do
        if Combat.IsAlive(puppet) then records[kind] = puppet:GetSaveRecord() end
    end
    return { version = 1, puppets = records, guard = self.guard ~= nil and { self.guard.x, self.guard.z } or nil }
end

function Commander:OnLoad(data)
    if data == nil then return end
    self.inst:DoTaskInTime(0, function()
        if data.guard ~= nil and self.inst.migration == nil then self.guard = Vector3(data.guard[1], 0, data.guard[2]) end
        for kind, record in pairs(data.puppets or {}) do
            kind = tonumber(kind)
            if kind ~= nil and kind >= 1 and kind <= 4 and record.prefab == "ariel_puppet_" .. kind then
                local puppet = SpawnSaveRecord(record)
                if puppet ~= nil then self:AttachPuppet(kind, puppet) end
            end
        end
    end)
end

function Commander:OnRemoveFromEntity()
    if self.task ~= nil then self.task:Cancel() end
    self.inst:StopWatchingWorldState("isnight", self._night)
    self:DismissSpiders()
    for _, puppet in pairs(self.puppets) do
        if puppet:IsValid() then puppet:Remove() end
    end
end
Commander.OnRemoveEntity = Commander.OnRemoveFromEntity

return Commander
