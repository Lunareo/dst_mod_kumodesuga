---@class components
---@field wrathstate component_wrathstate

---@class component_wrathstate
---@field inst avatar_wrath
local WrathState = Class(function(self, inst)
    self.inst = inst

    -- 战斗时间戳（用于禁忌之声低语）
    self.last_combat_time = GetTime()

    -- 霸体受击抗打断冷却
    self.interrupt_cooldown = 6
    self.last_interrupt_time = 0

    -- 招架反击状态
    self.parry_boost_until = 0
    self.parry_counter_count = 0 -- 连续成功招架计数（用于剑圣心流）

    -- 愤怒状态参数
    self.is_raging = false
    self.rage_lost_control = false
    self.rage_exhausted = false
    self.rage_time_remaining = 0
    self.rage_cooldown = 90
    self.rage_cooldown_task = nil
    self.rage_timer_task = nil
    self.exhaust_timer_task = nil

    -- 阎魔状态参数
    self.is_enma = false
    self.enma_hits_left = 0
    self.enma_time_remaining = 0
    self.enma_extended_time = 0
    self.enma_cooldown = 60
    self.enma_timer_task = nil
    self.enma_cooldown_task = nil

    -- 事件监听
    self._onattacked = function(owner, data) self:OnAttacked(data) end
    self._onhitother = function(owner, data) self:OnHitOther(data) end
    self._onkilled = function(owner, data) self:OnKilled(data) end

    self.inst:ListenForEvent("attacked", self._onattacked)
    self.inst:ListenForEvent("onhitother", self._onhitother)
    self.inst:ListenForEvent("killed", self._onkilled)
end)

function WrathState:OnRemoveFromEntity()
    self.inst:RemoveEventCallback("attacked", self._onattacked)
    self.inst:RemoveEventCallback("onhitother", self._onhitother)
    self.inst:RemoveEventCallback("killed", self._onkilled)
    self:StopRage(true)
    self:StopEnma(true)
end

--------------------------------------------------------------------------------
-- 辅助：技能树判断
--------------------------------------------------------------------------------
function WrathState:HasSkill(skill_name)
    local updater = self.inst.components.skilltreeupdater
    return updater ~= nil and updater:IsActivated("wrath_" .. skill_name)
end

--------------------------------------------------------------------------------
-- 禁忌之声与战斗时间戳
--------------------------------------------------------------------------------
function WrathState:UpdateCombatTime()
    self.last_combat_time = GetTime()
end

---由 sanity.custom_rate_fn 调用
---@return number # 理智流失速率（点/秒，通常为负）
function WrathState:GetSanityRateModifier()
    local rate = 0
    local is_quiet = (GetTime() - self.last_combat_time) >= 30

    -- 禁忌抗衡技能（理智流失减半）
    local mult = self:HasSkill("taboo_resist") and 0.5 or 1.0

    if is_quiet then
        -- 脱战 30 秒后：-4 点/分钟
        rate = rate - (4 / 60) * mult
    else
        -- 常态：-2 点/分钟
        rate = rate - (2 / 60) * mult
    end

    -- 处于愤怒狂暴状态：额外 -6 点/秒
    if self.is_raging then
        rate = rate - 6.0
    end

    return rate
end

--------------------------------------------------------------------------------
-- 鬼人体魄动作霸体（抗受击打断）
--------------------------------------------------------------------------------
function WrathState:GetInterruptCooldown()
    return self:HasSkill("iron_body") and 4 or 6
end

function WrathState:OnAttacked(data)
    self:UpdateCombatTime()

    -- 处于狂暴状态时拥有完全受击霸体
    if self.is_raging then
        if self.inst.sg ~= nil then
            self.inst.sg:AddStateTag("nointerrupt")
        end
        return
    end

    -- 常态受击霸体：每 6 秒（技能后 4 秒）抵消一次打断
    local now = GetTime()
    local cd = self:GetInterruptCooldown()
    if now - self.last_interrupt_time >= cd then
        self.last_interrupt_time = now
        if self.inst.sg ~= nil and not self.inst.sg:HasStateTag("hit") then
            self.inst.sg:AddStateTag("nointerrupt")
        end
    end
end

--------------------------------------------------------------------------------
-- 招架与反击强化
--------------------------------------------------------------------------------
function WrathState:OnParrySuccess(attacker, damage)
    self:UpdateCombatTime()
    self.parry_boost_until = GetTime() + 2.0
    self.parry_counter_count = self.parry_counter_count + 1

    -- 完美招架（若在最后 0.15 秒成功，打断普通敌人）
    if self:HasSkill("perfect_parry") and attacker and attacker:IsValid() and attacker.sg ~= nil then
        if not attacker:HasTag("epic") and not attacker:HasTag("boss") then
            attacker.sg:GoToState("hit")
        end
    end

    -- 心眼破势（招架强力/Boss攻击后，使目标 3 秒内受到全队物理增伤 10%）
    if self:HasSkill("parry_expose") and attacker and attacker:IsValid() then
        if attacker.components.combat ~= nil then
            attacker:AddTag("wrath_exposed")
            if attacker._wrath_expose_task ~= nil then
                attacker._wrath_expose_task:Cancel()
            end
            attacker._wrath_expose_task = attacker:DoTaskInTime(3, function()
                attacker:RemoveTag("wrath_exposed")
                attacker._wrath_expose_task = nil
            end)
        end
    end

    -- 屏幕微震与反馈
    self.inst:ShakeCamera(CAMERASHAKE.SIDE, 0.1, 0.03, 0.3)
end

function WrathState:GetParryAttackBonus()
    if GetTime() <= self.parry_boost_until then
        -- 基础 +50%，技能强化后 +75%
        return self:HasSkill("quick_counter") and 0.75 or 0.50
    end
    return 0
end

function WrathState:ConsumeParryAttackBonus()
    self.parry_boost_until = 0
end

--------------------------------------------------------------------------------
-- 攻击命中回调 (OnHitOther)
--------------------------------------------------------------------------------
function WrathState:OnHitOther(data)
    self:UpdateCombatTime()
    local target = data and data.target

    -- 1. 消耗招架反击强化并触发反击回馈
    if self:GetParryAttackBonus() > 0 then
        self:ConsumeParryAttackBonus()

        -- 心流回响：反击命中回复 5 MP 与 3 理智
        if self:HasSkill("heart_echo") then
            if self.inst.components.magicpoint ~= nil then
                self.inst.components.magicpoint:DoDelta(5)
            end
            if self.inst.components.sanity ~= nil then
                self.inst.components.sanity:DoDelta(3)
            end
        end

        -- 剑圣心流（终极）：连续两次成功招架后，触发 360° 回旋范围反击并震退杂兵
        if self:HasSkill("sword_master_flow") and self.parry_counter_count >= 2 then
            self.parry_counter_count = 0
            if target and target:IsValid() then
                local x, y, z = self.inst.Transform:GetWorldPosition()
                local ents = TheSim:FindEntities(x, y, z, 3.5, { "_combat" }, { "player", "companion", "INLIMBO" })
                for _, ent in ipairs(ents) do
                    if ent ~= target and ent:IsValid() and self.inst.components.combat:CanTarget(ent) then
                        local weapon = self.inst.components.combat:GetWeapon()
                        local base_dmg = weapon and weapon.components.weapon and weapon.components.weapon.damage or 34
                        ent.components.combat:GetAttacked(self.inst, base_dmg * 1.5, weapon)
                        if ent.Physics ~= nil and not ent:HasTag("epic") and not ent:HasTag("heavyobstacle") then
                            local rot = self.inst:GetAngleToPoint(ent.Transform:GetWorldPosition()) * DEGREES
                            ent.Physics:SetVel(math.cos(rot) * 6, 0, -math.sin(rot) * 6)
                        end
                    end
                end
            end
        end
    end

    -- 2. 阎魔断罪之火位面伤害
    if self.is_enma and target and target:IsValid() and self.enma_hits_left > 0 then
        self.enma_hits_left = self.enma_hits_left - 1

        local is_shadow_or_nightmare = target:HasTag("shadow")
            or target:HasTag("shadow_aligned")
            or target:HasTag("nightmarecreature")
            or target:HasTag("shadowcreature")

        local planar_dmg = is_shadow_or_nightmare and 60 or 40
        if target.components.combat ~= nil then
            local spdmg = { planar = planar_dmg }
            target.components.combat:GetAttacked(self.inst, 0, nil, nil, spdmg)
        end

        -- 阎魔攻击命中特效
        local fx = SpawnPrefab("impact")
        if fx ~= nil then
            fx.Transform:SetPosition(target.Transform:GetWorldPosition())
        end

        if self.enma_hits_left <= 0 then
            self:StopEnma()
        end
    end
end

--------------------------------------------------------------------------------
-- 击杀回调 (OnKilled)
--------------------------------------------------------------------------------
function WrathState:OnKilled(data)
    local victim = data and data.victim
    if victim == nil or not victim:IsValid() then return end

    -- 阎魔续火：击杀非暗影生物延长 1.5 秒持续时间（最多延长 6 秒）
    if self.is_enma and self:HasSkill("enma_extend") then
        local is_shadow = victim:HasTag("shadow") or victim:HasTag("shadowcreature")
        if not is_shadow and self.enma_extended_time < 6 then
            local add_time = math.min(1.5, 6 - self.enma_extended_time)
            self.enma_extended_time = self.enma_extended_time + add_time
            self.enma_time_remaining = self.enma_time_remaining + add_time
        end
    end

    -- 残骸吞食：击杀大型或首领生物吞食回复 30 饥饿与 10% 移速
    if self:HasSkill("devour_carcass") then
        if victim:HasTag("epic") or victim:HasTag("largecreature") then
            if self.inst.components.hunger ~= nil then
                self.inst.components.hunger:DoDelta(30)
            end
            if self.inst.components.locomotor ~= nil then
                self.inst.components.locomotor:SetExternalSpeedMultiplier(self.inst, "wrath_devour", 1.10)
                self.inst:DoTaskInTime(480 * 0.5, function()
                    if self.inst:IsValid() and self.inst.components.locomotor ~= nil then
                        self.inst.components.locomotor:RemoveExternalSpeedMultiplier(self.inst, "wrath_devour")
                    end
                end)
            end
        end
    end
end

--------------------------------------------------------------------------------
-- 支配者技能：愤怒 (Wrath / Rage)
--------------------------------------------------------------------------------
function WrathState:CanRage()
    if self.is_raging or self.rage_exhausted or self.rage_cooldown_task ~= nil then
        return false
    end
    if self.inst:HasTag("playerghost") then
        return false
    end
    if self.inst.components.rider and self.inst.components.rider:IsRiding() then
        return false
    end
    local min_sanity = self:HasSkill("rage_threshold") and 30 or 40
    return self.inst.components.sanity and self.inst.components.sanity.current >= min_sanity
end

function WrathState:StartRage()
    if not self:CanRage() then return false end

    self.is_raging = true
    self.rage_lost_control = false
    self.rage_time_remaining = 20

    -- 启动扣除 10 理智
    self.inst.components.sanity:DoDelta(-10)

    -- 物理伤害倍率 * 2
    self.inst.components.combat.damagemultipliers:SetModifier(self.inst, 2.0, "wrath_rage")

    -- 移动速度 +15%
    self.inst.components.locomotor:SetExternalSpeedMultiplier(self.inst, "wrath_rage", 1.15)

    -- 耗粮 2.5 倍
    self.inst.components.hunger.burnratemultipliers:SetModifier(self.inst, 2.5, "wrath_rage")

    -- 狂战之躯技能：+10% 物理减伤
    if self:HasSkill("berserk_body") then
        self.inst.components.health.externalabsorbmodifiers:SetModifier(self.inst, 0.10, "wrath_berserk")
    end

    -- 暂停 MP 回复
    if self.inst.components.magicpoint ~= nil then
        self.inst.components.magicpoint:AddConsumptionSrc(self.inst, -self.inst.components.magicpoint.rate, "wrath_rage")
    end

    -- 周期更新：检查时间与理智触底失控
    if self.rage_timer_task ~= nil then self.rage_timer_task:Cancel() end
    self.rage_timer_task = self.inst:DoPeriodicTask(1, function()
        self:OnRageTick()
    end)

    self.inst:PushEvent("wrath_ragestarted")
    return true
end

function WrathState:OnRageTick()
    if not self.is_raging then return end

    self.rage_time_remaining = self.rage_time_remaining - 1

    -- 血战本能技能：血量越低，攻速加成越高（最高 +20% 攻速 = 攻击周期乘 0.8）
    if self:HasSkill("blood_instinct") and self.inst.components.health ~= nil then
        local health_pct = self.inst.components.health:GetPercent()
        local atk_period_mult = 1.0 - (1.0 - health_pct) * 0.20
        self.inst.components.combat.min_attack_period = 0.4 * atk_period_mult
    else
        self.inst.components.combat.min_attack_period = 0.4 -- 基础攻速大幅提升
    end

    -- 检查理智归零失控
    if not self.rage_lost_control and self.inst.components.sanity and self.inst.components.sanity.current <= 0 then
        self:EnterRageLostControl()
        return
    end

    if self.rage_time_remaining <= 0 then
        self:StopRage(false)
    end
end

function WrathState:EnterRageLostControl()
    self.rage_lost_control = true
    self.rage_time_remaining = 5 -- 5 秒失控尾段
    self.inst:AddTag("rage_lost_control")
    self.inst:PushEvent("wrath_ragelostcontrol")
end

function WrathState:StopRage(silent)
    if not self.is_raging then return end
    self.is_raging = false

    if self.rage_timer_task ~= nil then
        self.rage_timer_task:Cancel()
        self.rage_timer_task = nil
    end

    -- 清理狂暴修饰符
    self.inst.components.combat.damagemultipliers:RemoveModifier(self.inst, "wrath_rage")
    self.inst.components.combat.min_attack_period = nil
    self.inst.components.locomotor:RemoveExternalSpeedMultiplier(self.inst, "wrath_rage")
    self.inst.components.hunger.burnratemultipliers:RemoveModifier(self.inst, "wrath_rage")
    self.inst.components.health.externalabsorbmodifiers:RemoveModifier(self.inst, "wrath_berserk")

    if self.inst.components.magicpoint ~= nil then
        self.inst.components.magicpoint:RemoveConsumptionSrc(self.inst, "wrath_rage")
    end

    self.inst:RemoveTag("rage_lost_control")

    if not silent then
        -- 进入虚脱期（若经历了失控或正常结束）
        self:EnterExhaustion()

        -- 启动冷却（基础 90 秒，技能减少至 75 秒）
        local cd = self:HasSkill("rage_threshold") and 75 or 90
        if self.rage_cooldown_task ~= nil then self.rage_cooldown_task:Cancel() end
        self.rage_cooldown_task = self.inst:DoTaskInTime(cd, function()
            self.rage_cooldown_task = nil
        end)
    end

    self.inst:PushEvent("wrath_ragestopped")
end

function WrathState:EnterExhaustion()
    self.rage_exhausted = true
    -- 虚脱时间：默认 10 秒，技能减半至 5 秒
    local dur = self:HasSkill("tenacious_oni") and 5 or 10

    self.inst.components.combat.damagemultipliers:SetModifier(self.inst, 0.75, "wrath_exhaust")
    self.inst.components.locomotor:SetExternalSpeedMultiplier(self.inst, "wrath_exhaust", 0.85)

    if self.exhaust_timer_task ~= nil then self.exhaust_timer_task:Cancel() end
    self.exhaust_timer_task = self.inst:DoTaskInTime(dur, function()
        self.rage_exhausted = false
        self.inst.components.combat.damagemultipliers:RemoveModifier(self.inst, "wrath_exhaust")
        self.inst.components.locomotor:RemoveExternalSpeedMultiplier(self.inst, "wrath_exhaust")
        self.exhaust_timer_task = nil
    end)
end

--------------------------------------------------------------------------------
-- 终极技能：断罪之火·阎魔 (Enma)
--------------------------------------------------------------------------------
function WrathState:CanEnma()
    if self.is_enma or self.enma_cooldown_task ~= nil then
        return false
    end
    if not self:HasSkill("enma") then
        return false
    end
    if self.inst:HasTag("playerghost") then
        return false
    end
    return self.inst.components.sanity and self.inst.components.sanity.current >= 20
end

function WrathState:StartEnma()
    if not self:CanEnma() then return false end

    self.is_enma = true
    self.enma_hits_left = 5
    self.enma_time_remaining = 10
    self.enma_extended_time = 0

    self.inst.components.sanity:DoDelta(-20)

    if self.enma_timer_task ~= nil then self.enma_timer_task:Cancel() end
    self.enma_timer_task = self.inst:DoPeriodicTask(1, function()
        self.enma_time_remaining = self.enma_time_remaining - 1
        if self.enma_time_remaining <= 0 or self.enma_hits_left <= 0 then
            self:StopEnma(false)
        end
    end)

    self.inst:PushEvent("wrath_enmastarted")
    return true
end

function WrathState:StopEnma(silent)
    if not self.is_enma then return end
    self.is_enma = false

    if self.enma_timer_task ~= nil then
        self.enma_timer_task:Cancel()
        self.enma_timer_task = nil
    end

    if not silent then
        if self.enma_cooldown_task ~= nil then self.enma_cooldown_task:Cancel() end
        self.enma_cooldown_task = self.inst:DoTaskInTime(60, function()
            self.enma_cooldown_task = nil
        end)
    end

    self.inst:PushEvent("wrath_enmastopped")
end

--------------------------------------------------------------------------------
-- 存盘与加载
--------------------------------------------------------------------------------
function WrathState:OnSave()
    return {
        last_combat_time = self.last_combat_time,
        is_raging = self.is_raging,
        rage_time_remaining = self.rage_time_remaining,
        is_enma = self.is_enma,
        enma_hits_left = self.enma_hits_left,
        enma_time_remaining = self.enma_time_remaining,
    }
end

function WrathState:OnLoad(data)
    if data ~= nil then
        self.last_combat_time = data.last_combat_time or GetTime()
        if data.is_raging and data.rage_time_remaining and data.rage_time_remaining > 0 then
            self:StartRage()
            self.rage_time_remaining = data.rage_time_remaining
        end
        if data.is_enma and data.enma_time_remaining and data.enma_time_remaining > 0 then
            self:StartEnma()
            self.enma_time_remaining = data.enma_time_remaining
            self.enma_hits_left = data.enma_hits_left or 5
        end
    end
end

return WrathState
