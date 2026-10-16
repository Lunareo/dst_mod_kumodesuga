local function Armoured(inst)
    return inst._arieltier ~= nil and (inst._arieltier:value() == 3 or inst._arielstance:value() == 1)
        and not inst:HasTag("playerghost")
end

local function AddArielAttack(sg)
    local base = sg.states.attack
    local attack = shallowcopy(base)
    attack.name = "ariel_attack"
    attack.timeline = {}
    for i, event in ipairs(base.timeline) do
        attack.timeline[i] = TimeEvent(event.time / 1.5, event.fn)
    end
    attack.onenter = function(inst, ...)
        base.onenter(inst, ...)
        if inst.sg.currentstate ~= attack then return end
        inst.AnimState:SetDeltaTimeMultiplier(1.5)
        if inst.sg.timeout ~= nil then inst.sg:SetTimeout(inst.sg.timeout / 1.5) end
        -- 动画、伤害时间线和冷却使用同一倍率，不影响其他角色或施法状态。
        local combat = inst.components.combat
        if combat ~= nil and combat.laststartattacktime ~= nil then
            combat.laststartattacktime = combat.laststartattacktime - combat.min_attack_period / 3
        elseif inst.replica.combat._laststartattacktime ~= nil then
            inst.replica.combat._laststartattacktime = inst.replica.combat._laststartattacktime
                - inst.replica.combat:MinAttackPeriod() / 3
        end
        if inst.sg.statemem.projectiledelay ~= nil then
            inst.sg.statemem.projectiledelay = inst.sg.statemem.projectiledelay / 1.5
        end
    end
    attack.onexit = function(inst, ...)
        inst.AnimState:SetDeltaTimeMultiplier(1)
        if base.onexit ~= nil then return base.onexit(inst, ...) end
    end
    sg.states.ariel_attack = attack
    local handler = sg.actionhandlers[ACTIONS.ATTACK]
    local deststate = handler.deststate
    handler.deststate = function(inst, action)
        local state = deststate(inst, action)
        if state == "attack" and inst._arielstance ~= nil and inst._arielstance:value() == 1
            and not inst.replica.rider:IsRiding() then return "ariel_attack" end
        return state
    end
end

AddStategraphPostInit("wilson_client", AddArielAttack)
AddStategraphPostInit("wilson", function(sg)
    AddArielAttack(sg)
    for _, event in ipairs({ "attacked", "knockback" }) do
        local handler = sg.events[event]
        local old = handler.fn
        handler.fn = function(inst, data)
            -- 不屏蔽死亡、溺水、坠落或睡眠唤醒等强制状态。
            if Armoured(inst) and not inst.components.health:IsDead()
                and not inst.sg:HasAnyStateTag("sleeping", "drowning", "falling", "frozen") then return end
            return old(inst, data)
        end
    end
    local hit = sg.states.hit
    local enter, exit = hit.onenter, hit.onexit
    hit.onenter = function(inst, ...)
        enter(inst, ...)
        if inst._arieltier ~= nil and inst._arieltier:value() == 2 and inst.sg.currentstate == hit then
            inst.AnimState:SetDeltaTimeMultiplier(2)
            if inst.sg.timeout ~= nil then inst.sg:SetTimeout(inst.sg.timeout / 2) end
        end
    end
    hit.onexit = function(inst, ...)
        if inst._arieltier ~= nil then inst.AnimState:SetDeltaTimeMultiplier(1) end
        if exit ~= nil then return exit(inst, ...) end
    end
end)
