local assets = {
    Asset("ANIM", "anim/helheim_beyonder_fx.zip"),
}

local tag = "wakaba"

local TUNE = {
    BASE_DMG = TUNING.BASE_SURVIVOR_ATTACK * 1.5,
    GENERAL_DMG_MIN = TUNING.BASE_SURVIVOR_ATTACK / 2,
    GENERAL_DMG_MAX = TUNING.BASE_SURVIVOR_ATTACK,
    USES = 200,
    RANGE = 10,
}

local function SetFXOwner(inst, owner)
    if inst._fxowner ~= nil and inst._fxowner.components.colouradder ~= nil then
        inst._fxowner.components.colouradder:DetachChild(inst.flame)
    end
    inst._fxowner = owner
    if owner ~= nil then
        inst.flame.entity:SetParent(owner.entity)
        inst.flame.Follower:FollowSymbol(owner.GUID, "swap_object", 0, -30, 0)
        inst.flame.components.highlightchild:SetOwner(owner)
        if owner.components.colouradder ~= nil then
            owner.components.colouradder:AttachChild(inst.flame)
        end
    else
        inst.flame.entity:SetParent(inst.entity)
        inst.flame.Follower:FollowSymbol(inst.GUID)
    end
end

local function DmgFn(inst, attacker, target)
    local dmg = TUNE.BASE_DMG
    if not attacker then
        attacker = inst and inst.components.inventoryitem:GetGrandOwner()
    end
    local abyssredi = 0
    if attacker and attacker.components.sanity then
        local sanity = attacker.components.sanity
        local modifier = math.max(0, -(sanity.current - sanity.max) / TUNING.WAKABA_SANITY)
        dmg = TUNE.GENERAL_DMG_MAX * (1 - (math.min(1, modifier / 4)) ^ .5)
        abyssredi = (TUNE.BASE_DMG - dmg) * (modifier + 1)
        inst.components.abyssdamage.externalbonuses:SetModifier(inst, abyssredi, "dmgfromsan")
    end
    return (target or rawget(_G, "Insight")) and dmg or (dmg + abyssredi)
end

local function OnAttack(inst, attacker, target)
    if not (attacker and attacker:IsValid()) then return end
    target:AddDebuff("erosion", "buff_erosion", {
        attacker = attacker, weapon = inst
    })
    if attacker.components.sanity then
        local sanitydelta = math.max(10,
            attacker.components.sanity:GetPercent() * attacker.components.sanity.current * .1)
        inst._sanityaward_data.value = (inst._sanityaward_data.value or 0) + sanitydelta
        inst.components.timer:StopTimer("sanityaward")
        inst.components.timer:StartTimer("sanityaward", 5)
        inst._sanityaward_data.attacker = attacker
        attacker.components.sanity:DoDelta(-sanitydelta)
    end
    SpawnAt("helheim_beyonder_atk_fx", target)
end

local function Equip(inst, owner)
    owner.AnimState:ClearOverrideSymbol("swap_object")
    owner.AnimState:Show("arm_carry")
    owner.AnimState:Hide("arm_normal")
    SetFXOwner(inst, owner)
end

local function UnEquip(inst, owner)
    owner.AnimState:Hide("arm_carry")
    owner.AnimState:Show("arm_normal")
    SetFXOwner(inst, nil)
end

local function OnTimeDone(inst, data)
    if not data then return end
    if data.name == "sanityaward" and inst._sanityaward_data and inst._sanityaward_data.attacker then
        inst._sanityaward_data.attacker.components.sanity:DoDelta(inst._sanityaward_data.value, 5)
        inst._sanityaward_data.attacker = nil
        inst._sanityaward_data.value = 0
    end
end

local function fn()
    ---@class inst
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    inst.AnimState:SetBank("helheim_beyonder_fx")
    inst.AnimState:SetBuild("helheim_beyonder_fx")
    inst.AnimState:PlayAnimation("idle", true)

    MakeInventoryPhysics(inst)

    inst:AddTag("weapon")
    inst:AddTag("thrown")
    inst:AddTag("lighterweapon")

    MakeInventoryFloatable(inst, "med", 0.05, nil, nil, -9)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    local frame = math.random(inst.AnimState:GetCurrentAnimationNumFrames()) - 1
    inst.flame = SpawnPrefab("helheim_beyonder_equip_fx")
    inst.flame.AnimState:SetFrame(frame)
    SetFXOwner(inst, nil)

    local weapon = inst:AddComponent("weapon")
    weapon:SetRange(TUNE.RANGE)
    weapon:SetDamage(DmgFn)
    weapon:SetOnAttack(OnAttack)

    local abyssdamage = inst:AddComponent("abyssdamage")
    abyssdamage:SetBaseDamage(0)

    local finiteuses = inst:AddComponent("finiteuses")
    finiteuses:SetMaxUses(TUNE.USES)
    finiteuses:SetUses(TUNE.USES)
    finiteuses:SetOnFinished(inst.Remove)

    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")

    local equippable = inst:AddComponent("equippable")
    equippable.restrictedtag = tag
    equippable:SetOnEquip(Equip)
    equippable:SetOnUnequip(UnEquip)

    inst:AddComponent("timer")
    inst._sanityaward_data = { attacker = nil, value = 0 }
    inst:ListenForEvent("timerdone", OnTimeDone)

    MakeHauntableLaunch(inst)

    return inst
end

local function followfx()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddFollower()
    inst.entity:AddNetwork()

    inst:AddTag("FX")

    inst.AnimState:SetBank("helheim_beyonder_fx")
    inst.AnimState:SetBuild("helheim_beyonder_fx")
    inst.AnimState:PlayAnimation("idle", true)

    inst:AddComponent("highlightchild")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("colouradder")

    inst.persists = false

    return inst
end

local function atkfx()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    inst:AddTag("FX")

    inst.AnimState:SetBank("helheim_beyonder_fx")
    inst.AnimState:SetBuild("helheim_beyonder_fx")
    inst.AnimState:PlayAnimation("pre")
    inst.AnimState:PushAnimation("pst")

    inst:AddComponent("highlightchild")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("colouradder")

    inst:ListenForEvent("animqueueover", inst.Remove)

    inst.persists = false

    return inst
end

local function thegrasp(inst)
    inst:SetPrefabName("helheim_beyonder")
    if not TheWorld.ismastersim then
        return
    end
    inst.components.inventoryitem.atlasname = GetInventoryItemAtlas("helheim_beyonder.tex")
    inst.components.inventoryitem:ChangeImageName("helheim_beyonder")
end

return Prefab("helheim_beyonder", fn, assets),
    Prefab("helheim_beyonder_equip_fx", followfx, assets),
    Prefab("helheim_beyonder_atk_fx", atkfx, assets),
    Derive("helheim_beyonder", "thegrasp", thegrasp, assets)
