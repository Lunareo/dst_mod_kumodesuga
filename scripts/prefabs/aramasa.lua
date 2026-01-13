local assets = {
    Asset("ANIM", "anim/aramasa.zip"),
}

local function onequip(inst, owner)
    owner.AnimState:OverrideSymbol("hand", "aramasa", "swap_hand")
    owner.AnimState:ClearOverrideSymbol("swap_object")
    owner.AnimState:Hide("ARM_carry")
    owner.AnimState:Show("ARM_normal")
end

local function onunequip(inst, owner)
    owner.AnimState:ClearOverrideSymbol("hand")
    owner.AnimState:Hide("ARM_carry")
    owner.AnimState:Show("ARM_normal")
end

local function oncharged(inst)
    inst:RemoveTag("punch")
    inst.components.finiteuses:SetPercent(1)
end

local function ondischarged(inst)
    inst:AddTag("punch")
    --inst.components.finiteuses:SetPercent(inst.components.rechargeable:GetPercent())
end

local function onfinished(inst)
    inst.components.rechargeable:Discharge(10)
end

local function damagefn(inst, attacker, target)
    if not inst:HasTag("punch") then
        return TUNING.SPEAR_DAMAGE / 4
    elseif attacker ~= nil and attacker:IsValid() and attacker.components.combat then
        return attacker.components.combat.defaultdamage
    else
        return 0
    end
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("aramasa")
    inst.AnimState:SetBuild("aramasa")
    inst.AnimState:PlayAnimation("idle")

    inst:AddTag("sharp")
    inst:AddTag("pointy")

    inst:AddTag("weapon")
    inst:AddTag("aramasa")

    MakeInventoryFloatable(inst, "med", 0.05, { 1.1, 0.5, 1.1 }, true, -9)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("weapon")
    inst.components.weapon:SetDamage(damagefn)
    -------

    inst:AddComponent("finiteuses")
    inst.components.finiteuses:SetMaxUses(TUNING.SPEAR_USES)
    inst.components.finiteuses:SetUses(TUNING.SPEAR_USES)

    inst.components.finiteuses:SetOnFinished(onfinished)

    inst:AddComponent("inspectable")

    inst:AddComponent("rechargeable")
    inst.components.rechargeable:SetMaxCharge(10)
    inst.components.rechargeable:SetOnChargedFn(oncharged)
    inst.components.rechargeable:SetOnDischargedFn(ondischarged)

    inst:AddComponent("inventoryitem")

    inst:AddComponent("equippable")
    inst.components.equippable:SetOnEquip(onequip)
    inst.components.equippable:SetOnUnequip(onunequip)

    MakeHauntableLaunch(inst)

    return inst
end

return Prefab("aramasa", fn, assets)
