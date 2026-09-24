local Combat = require "ariel_combat"
require "components/abyssdamage"

local function fn()
    local inst = CreateEntity()
    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()
    inst.AnimState:SetBank("sinkhole")
    inst.AnimState:SetBuild("antlion_sinkhole")
    inst.AnimState:PlayAnimation("idle")
    inst.AnimState:SetOrientation(ANIM_ORIENTATION.OnGround)
    inst.AnimState:SetLayer(LAYER_BACKGROUND)
    inst.AnimState:SetSortOrder(2)
    inst.AnimState:SetMultColour(.35, .15, .5, .8)
    inst:AddTag("FX")
    inst:AddTag("NOCLICK")
    inst.persists = false
    inst.entity:SetPristine()
    if not TheWorld.ismastersim then return inst end

    local ticks = 0
    local affected = {}
    inst:ListenForEvent("onremove", function()
        for target in pairs(affected) do
            if target:IsValid() and target.components.locomotor ~= nil then
                target.components.locomotor:RemoveExternalSpeedMultiplier(inst, "ariel_gate")
            end
        end
    end)
    inst:DoPeriodicTask(.5, function()
        if not Combat.IsAlive(inst.caster) then
            for target in pairs(affected) do
                if target:IsValid() and target.components.locomotor ~= nil then
                    target.components.locomotor:RemoveExternalSpeedMultiplier(inst, "ariel_gate")
                end
            end
            inst:Remove()
            return
        end
        local current = {}
        for _, target in ipairs(Combat.Enemies(inst.caster, inst:GetPosition(), inst.radius)) do
            current[target] = true
            if target.components.locomotor ~= nil then
                target.components.locomotor:SetExternalSpeedMultiplier(inst, "ariel_gate", .4)
            end
            if not target.components.health:IsInvincible() then
                if not Combat.IsBoss(target) and target.components.health:GetPercent() <= inst.execute_percent then
                    target.components.combat:GetAttacked(inst.caster, 0, nil, "abyss", {
                        abyss = target.components.health.currenthealth * 100,
                    })
                else
                    target.components.combat:GetAttacked(inst.caster, 0, nil, "abyss", {
                        abyss = inst.damage / (TUNING.ARIEL.gate_duration * 2),
                    })
                end
                if not Combat.IsBoss(target) and target.Physics ~= nil and Combat.IsAlive(target) then
                    Combat.StepToward(target, inst:GetPosition(), .3)
                end
            end
        end
        for target in pairs(affected) do
            if not current[target] and target:IsValid() and target.components.locomotor ~= nil then
                target.components.locomotor:RemoveExternalSpeedMultiplier(inst, "ariel_gate")
            end
        end
        affected = current
        ticks = ticks + 1
        if ticks >= TUNING.ARIEL.gate_duration * 2 then inst:Remove() end
    end)
    return inst
end

return Prefab("ariel_gate", fn, { Asset("ANIM", "anim/antlion_sinkhole.zip") })
