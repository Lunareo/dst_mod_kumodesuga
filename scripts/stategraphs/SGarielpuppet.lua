local states = {
    State {
        name = "idle", tags = { "idle", "canrotate" },
        onenter = function(inst)
            inst.Physics:Stop()
            inst.AnimState:PlayAnimation("idle_loop", true)
        end,
    },
    State {
        name = "walk", tags = { "moving", "canrotate" },
        onenter = function(inst)
            inst.components.locomotor:WalkForward()
            inst.AnimState:PlayAnimation("walk_loop", true)
        end,
    },
    State {
        name = "attack", tags = { "attack", "busy" },
        onenter = function(inst)
            inst.Physics:Stop()
            inst.sg.statemem.target = inst.components.combat.target
            inst.components.combat:StartAttack()
            if inst.sg.statemem.target ~= nil then inst:ForceFacePoint(inst.sg.statemem.target:GetPosition()) end
            inst.AnimState:PlayAnimation("atk")
            inst.sg:SetTimeout(inst.ariel_attackperiod)
        end,
        timeline = {
            TimeEvent(6 * FRAMES, function(inst) inst:Strike(inst.sg.statemem.target) end),
            TimeEvent(10 * FRAMES, function(inst)
                if inst.ariel_kind == 3 then inst:Strike(inst.sg.statemem.target) end
            end),
        },
        ontimeout = function(inst) inst.sg:GoToState("idle") end,
    },
    State {
        name = "hit", tags = { "busy", "hit" },
        onenter = function(inst)
            inst.Physics:Stop()
            inst.AnimState:PlayAnimation("hit")
            inst.sg:SetTimeout(.3)
        end,
        ontimeout = function(inst) inst.sg:GoToState("idle") end,
    },
    State {
        name = "death", tags = { "busy", "dead" },
        onenter = function(inst)
            inst.Physics:Stop()
            inst.AnimState:PlayAnimation("death")
            inst.components.lootdropper:DropLoot()
            RemovePhysicsColliders(inst)
            inst:DoTaskInTime(3, inst.Remove)
        end,
    },
}
return StateGraph("arielpuppet", states, {
    EventHandler("locomote", function(inst)
        if not inst.sg:HasStateTag("busy") then
            local moving = inst.components.locomotor:WantsToMoveForward()
            if moving ~= inst.sg:HasStateTag("moving") then inst.sg:GoToState(moving and "walk" or "idle") end
        end
    end),
    EventHandler("doattack", function(inst)
        if not inst.sg:HasStateTag("busy") then inst.sg:GoToState("attack") end
    end),
    EventHandler("attacked", function(inst)
        if not inst.sg:HasStateTag("dead") and inst.ariel_kind ~= 4 then inst.sg:GoToState("hit") end
    end),
    EventHandler("death", function(inst) inst.sg:GoToState("death") end),
}, "idle")
