local function Apply(inst, target)
    local combat = target.components.combat
    if combat ~= nil then
        if inst.buff_kind == "war" then
            combat.externaldamagemultipliers:SetModifier(inst, 1.2, "ariel_meal")
        end
        combat.externaldamagetakenmultipliers:SetModifier(inst, inst.buff_kind == "war" and .9 or .8, "ariel_meal")
    end
end

local function Detach(inst, target)
    if target ~= nil and target:IsValid() and target.components.combat ~= nil then
        target.components.combat.externaldamagemultipliers:RemoveModifier(inst, "ariel_meal")
        target.components.combat.externaldamagetakenmultipliers:RemoveModifier(inst, "ariel_meal")
    end
    inst:Remove()
end

local function Extend(inst)
    inst.components.timer:StopTimer("buffover")
    inst.components.timer:StartTimer("buffover", TUNING.ARIEL.meal_duration)
end

local function MakeBuff(kind)
    local function fn()
        local inst = CreateEntity()
        inst.entity:AddTransform()
        inst.entity:Hide()
        inst:AddTag("CLASSIFIED")
        inst.persists = true
        inst.buff_kind = kind
        inst:AddComponent("debuff")
        inst.components.debuff:SetKeepOnDespawn(true)
        inst.components.debuff:SetAttachedFn(function(_, target)
            inst.entity:SetParent(target.entity)
            inst.Transform:SetPosition(0, 0, 0)
            Apply(inst, target)
            Extend(inst)
        end)
        inst.components.debuff:SetDetachedFn(Detach)
        inst.components.debuff:SetExtendedFn(Extend)
        inst:AddComponent("timer")
        inst:ListenForEvent("timerdone", function(_, data)
            if data.name == "buffover" then inst.components.debuff:Stop() end
        end)
        return inst
    end
    return Prefab("buff_ariel_" .. kind, fn)
end

return MakeBuff("war"), MakeBuff("resist")
