local function CASTAOE_dest_post(inst, action)
    if action.invobject ~= nil then
        if action.invobject:HasTag("scythe") then
            return { "scythe" }, true
        elseif action.invobject:HasTag("spell_item") then
            return { "channelcast_oh_idle" }, true
        end
    end
end

local function ATTACK_dest_post(rets, inst, action)
    if #rets > 0 and rets[1] == "attack" then
        local weapon = inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)
        if weapon and weapon:HasTag("aramasa") then
            rets[1] = "aramasa_pre"
        end
    end
    return rets
end

AddStategraphPostInit("wilson", function(sg)
    UTIL.FnExtend(sg.actionhandlers[ACTIONS.CASTAOE], "deststate", CASTAOE_dest_post)
    UTIL.FnExtend(sg.actionhandlers[ACTIONS.ATTACK], "deststate", nil, ATTACK_dest_post)
end)

AddStategraphPostInit("wilson_client", function(sg)
    UTIL.FnExtend(sg.actionhandlers[ACTIONS.CASTAOE], "deststate", CASTAOE_dest_post)
end)

local function IsWeaponEquipped(inst, weapon)
    return weapon ~= nil
        and weapon.components.equippable ~= nil
        and weapon.components.equippable:IsEquipped()
        and weapon.components.inventoryitem ~= nil
        and weapon.components.inventoryitem:IsHeldBy(inst)
end

local function ValidateAramasa(inst)
    return IsWeaponEquipped(inst, inst.sg.statemem.weapon) and inst.sg.statemem.weapon:HasTag("aramasa")
end

local function DoAramasa(inst, nosound)
    if ValidateAramasa(inst) then
        inst.components.combat:DoAttack(inst.sg.statemem.target, inst.sg.statemem.weapon)
        if not nosound then
            inst.SoundEmitter:PlaySound("dontstarve/wilson/attack_weapon")
        end
    end
end

local states = {
    State {
        name = "aramasa_pre",
        tags = { "thrusting", "doing", "busy", "nointerrupt", "nomorph", "pausepredict" },
        onenter = function(inst)
            inst.components.locomotor:Stop()
            inst.AnimState:PlayAnimation("multithrust_yell")

            if inst.bufferedaction ~= nil and inst.bufferedaction.target ~= nil and inst.bufferedaction.target:IsValid() then
                inst.sg.statemem.target = inst.bufferedaction.target
                inst.components.combat:SetTarget(inst.sg.statemem.target)
                inst:ForceFacePoint(inst.sg.statemem.target.Transform:GetWorldPosition())
            end

            if inst.components.playercontroller ~= nil then
                inst.components.playercontroller:RemotePausePrediction()
            end
        end,
        events =
        {
            EventHandler("animover", function(inst)
                if inst.AnimState:AnimDone() then
                    inst.sg.statemem.thrusting = true
                    inst.sg:GoToState("aramasa", inst.sg.statemem.target)
                end
            end),
        },

        onexit = function(inst)
            if not inst.sg.statemem.thrusting then
                inst.components.combat:SetTarget(nil)
            end
        end,
    },
    State {
        name = "aramasa",
        tags = { "thrusting", "doing", "busy", "nointerrupt", "nomorph", "pausepredict" },
        onenter = function(inst, target)
            inst.components.locomotor:Stop()
            inst.AnimState:PlayAnimation("multithrust")
            inst.Transform:SetEightFaced()

            if target ~= nil and target:IsValid() then
                inst.sg.statemem.target = target
                inst:ForceFacePoint(target.Transform:GetWorldPosition())
            end

            inst.sg:SetTimeout(30 * FRAMES)
        end,
        timeline =
        {
            TimeEvent(7 * FRAMES, function(inst)
                inst.SoundEmitter:PlaySound("dontstarve/wilson/attack_weapon")
            end),
            TimeEvent(9 * FRAMES, function(inst)
                inst.SoundEmitter:PlaySound("dontstarve/wilson/attack_weapon")
            end),
            TimeEvent(11 * FRAMES, function(inst)
                inst.sg.statemem.weapon = inst.components.combat:GetWeapon()
                DoAramasa(inst)
            end),
            TimeEvent(13 * FRAMES, DoAramasa),
            TimeEvent(14 * FRAMES, DoAramasa),
            TimeEvent(15 * FRAMES, DoAramasa),
            TimeEvent(16 * FRAMES, DoAramasa),
            TimeEvent(17 * FRAMES, DoAramasa),
            TimeEvent(18 * FRAMES, function(inst)
                DoAramasa(inst, true)
            end),
            TimeEvent(19 * FRAMES, function(inst)
                inst.sg:RemoveStateTag("nointerrupt")
                DoAramasa(inst, true)
            end),
        },

        ontimeout = function(inst)
            inst.sg:GoToState("idle", true)
        end,

        events =
        {
            EventHandler("animover", function(inst)
                if inst.AnimState:AnimDone() then
                    inst.sg:GoToState("idle")
                end
            end),
        },

        onexit = function(inst)
            inst.components.combat:SetTarget(nil)
            inst.Transform:SetFourFaced()
        end,

    },
}

for _, state in ipairs(states) do
    AddStategraphState("wilson", state)
end
