local Combat = require "ariel_combat"
local Brain = require "brains/arielpuppetbrain"
local assets = {
    Asset("ANIM", "anim/shiro.zip"),
    Asset("ANIM", "anim/player_basic.zip"),
    Asset("ANIM", "anim/player_actions.zip"),
    Asset("ANIM", "anim/player_attacks.zip"),
}
local stats = {
    { damage = 50, period = 1.8, range = 2 },
    { damage = 35, period = 1.2, range = 4 },
    { damage = 20, period = .8, range = 2 },
    { damage = 25, period = 1.5, range = 2 },
}

local function Owner(inst)
    return inst.components.follower:GetLeader()
end

local function Strike(inst, target)
    local owner = Owner(inst)
    if not Combat.IsAlive(owner) or not Combat.IsEnemy(owner, target)
        or not inst:IsNear(target, stats[inst.ariel_kind].range + 1) then return end
    inst.components.combat:DoAttack(target)
    if inst.ariel_kind == 1 then
        Combat.Knockback(inst, target)
        for _, other in ipairs(Combat.Enemies(owner, target:GetPosition(), 2)) do
            if other ~= target then
                other.components.combat:GetAttacked(inst, stats[1].damage * .5 * inst.components.combat.externaldamagemultipliers:Get())
                Combat.Knockback(inst, other)
            end
        end
    elseif inst.ariel_kind == 2 then
        local origin = inst:GetPosition()
        local axis = (target:GetPosition() - origin):GetNormalized()
        for _, other in ipairs(Combat.Enemies(owner, origin, 5)) do
            local delta = other:GetPosition() - origin
            local along = delta.x * axis.x + delta.z * axis.z
            local across = math.abs(delta.x * axis.z - delta.z * axis.x)
            if other ~= target and along > 0 and across < .8 then
                other.components.combat:GetAttacked(inst, stats[2].damage * .5 * inst.components.combat.externaldamagemultipliers:Get())
            end
        end
    end
end

local function MakePuppet(kind)
    local function fn()
        local inst = CreateEntity()
        inst.entity:AddTransform()
        inst.entity:AddAnimState()
        inst.entity:AddSoundEmitter()
        inst.entity:AddNetwork()
        MakeCharacterPhysics(inst, 50, .4)
        inst.Transform:SetFourFaced()
        inst.AnimState:SetBank("wilson")
        inst.AnimState:SetBuild("shiro")
        inst.AnimState:PlayAnimation("idle_loop", true)
        inst.AnimState:Hide("ARM_carry")
        inst.AnimState:Show("ARM_normal")
        inst.Transform:SetScale(.8, .8, .8)
        local colors = { { 1, .75, .75 }, { .75, .85, 1 }, { .85, 1, .75 }, { .9, .8, 1 } }
        local color = colors[kind]
        inst.AnimState:SetMultColour(color[1], color[2], color[3], 1)
        inst:AddTag("companion")
        inst:AddTag("ariel_puppet")
        inst:AddTag("scarytoprey")
        inst:AddTag("NOBLOCK")
        inst.entity:SetPristine()
        if not TheWorld.ismastersim then return inst end

        inst.persists = false -- 唯一保存入口在主人的 arielcommander 中。
        inst.ariel_kind = kind
        inst.ariel_attackperiod = stats[kind].period
        inst.Strike = Strike
        inst:AddComponent("inspectable")
        inst:AddComponent("locomotor")
        inst.components.locomotor.walkspeed = 5
        inst.components.locomotor.runspeed = 7
        inst:AddComponent("health")
        inst.components.health:SetMaxHealth(TUNING.ARIEL.puppet_health * (kind == 4 and 2 or 1))
        inst:AddComponent("combat")
        inst.components.combat:SetDefaultDamage(stats[kind].damage)
        inst.components.combat:SetAttackPeriod(stats[kind].period)
        inst.components.combat:SetRange(stats[kind].range)
        if kind == 4 then inst.components.combat.externaldamagetakenmultipliers:SetModifier(inst, .5, "shield") end
        inst:AddComponent("follower")
        inst:AddComponent("lootdropper")
        inst.components.lootdropper:SetLoot({ "silk" })
        inst:ListenForEvent("attacked", function(_, data)
            local owner = Owner(inst)
            if owner ~= nil and data ~= nil and Combat.IsEnemy(owner, data.attacker) then inst.components.combat:SetTarget(data.attacker) end
        end)
        inst.components.combat:SetKeepTargetFunction(function(_, target)
            local owner = Owner(inst)
            return Combat.IsAlive(owner) and Combat.IsEnemy(owner, target)
        end)
        inst.components.combat:SetRetargetFunction(2, function()
            local owner = Owner(inst)
            if owner == nil or not Combat.IsAlive(owner) then return end
            local targets = Combat.Enemies(owner, inst:GetPosition(), 8)
            for _, target in ipairs(targets) do
                local victim = target.components.combat.target
                if inst._ariel_guard ~= nil or (victim ~= nil and (victim:HasTag("player") or victim:HasTag("ariel_puppet"))) then return target end
            end
        end)
        if kind == 4 then
            inst:DoPeriodicTask(3, function()
                local owner = Owner(inst)
                if owner == nil or not Combat.IsAlive(inst) then return end
                for _, target in ipairs(Combat.Enemies(owner, inst:GetPosition(), 6)) do
                    local victim = target.components.combat.target
                    if victim ~= nil and (victim:HasTag("player") or victim:HasTag("ariel_puppet")) then
                        target.components.combat:SetTarget(inst)
                    end
                end
            end)
        end
        inst:SetBrain(Brain)
        inst:SetStateGraph("SGarielpuppet")
        return inst
    end
    return Prefab("ariel_puppet_" .. kind, fn, assets, { "silk" })
end
return MakePuppet(1), MakePuppet(2), MakePuppet(3), MakePuppet(4)
