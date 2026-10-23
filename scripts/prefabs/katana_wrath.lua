local assets = {
    Asset("ANIM", "anim/spear.zip"),
    Asset("ANIM", "anim/swap_spear.zip"),
}

local function onequip(inst, owner)
    owner.AnimState:OverrideSymbol("swap_object", "swap_spear", "swap_spear")
    owner.AnimState:Show("ARM_carry")
    owner.AnimState:Hide("ARM_normal")
end

local function onunequip(inst, owner)
    owner.AnimState:Hide("ARM_carry")
    owner.AnimState:Show("ARM_normal")
end

local function OnParry(inst, doer, attacker, damage)
    if doer ~= nil and doer.components.wrathstate ~= nil then
        doer.components.wrathstate:OnParrySuccess(attacker, damage)
    end
end

local function SpellFn(inst, doer, pos)
    if doer == nil or not doer:IsValid() then return end

    local duration = 0.35
    if doer.components.skilltreeupdater ~= nil and doer.components.skilltreeupdater:IsActivated("wrath_parry_window") then
        duration = 0.45
    end

    local angle = pos ~= nil and doer:GetAngleToPoint(pos) or doer.Transform:GetRotation()
    inst.components.parryweapon:EnterParryState(doer, angle, duration)
    inst.components.rechargeable:Discharge(3)
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("spear")
    inst.AnimState:SetBuild("swap_spear")
    inst.AnimState:PlayAnimation("idle")

    inst:AddTag("sharp")
    inst:AddTag("pointy")
    inst:AddTag("weapon")
    inst:AddTag("parryweapon")
    inst:AddTag("rechargeable")

    MakeInventoryFloatable(inst, "med", 0.05, { 1.1, 0.5, 1.1 }, true, -9)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("weapon")
    inst.components.weapon:SetDamage(51)

    inst:AddComponent("finiteuses")
    inst.components.finiteuses:SetMaxUses(200)
    inst.components.finiteuses:SetUses(200)
    inst.components.finiteuses:SetOnFinished(inst.Remove)

    inst:AddComponent("inspectable")
    inst:AddComponent("inventoryitem")

    inst:AddComponent("equippable")
    inst.components.equippable:SetOnEquip(onequip)
    inst.components.equippable:SetOnUnequip(onunequip)

    inst:AddComponent("aoespell")
    inst.components.aoespell:SetSpellFn(SpellFn)

    inst:AddComponent("parryweapon")
    inst.components.parryweapon:SetParryArc(120)
    inst.components.parryweapon:SetOnParryFn(OnParry)

    inst:AddComponent("rechargeable")
    inst.components.rechargeable:SetCooldown(3)

    MakeHauntableLaunch(inst)

    return inst
end

return Prefab("katana_wrath", fn, assets)
