local assets = {
    Asset("ANIM", "anim/helheim_beyonder_fx.zip"),
    Asset("ANIM", "anim/blast_wave.zip"),
}

local tag = "wakaba"
local LAUNCH_OFFSET_Y = .75

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

local function OnProjectileLaunched(inst, attacker, target)
    inst.components.finiteuses:Use(1)
end

local function OnProjHit(inst, attacker, target)
    if not (attacker and attacker:IsValid() and target) then return end
    target:AddDebuff("erosion", "buff_erosion", {
        attacker = attacker, weapon = attacker.components.inventory and attacker.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)
    })
    inst:Remove()
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
    inst:AddTag("rangedweapon")
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
    weapon:SetOnProjectileLaunched(OnProjectileLaunched)
    weapon:SetProjectile("helheim_beyonder_proj")
    weapon:SetRange(TUNING.BEYONDER_RANGE)
    weapon:SetDamage(TUNING.BEYONDER_BASE_DMG)

    inst:AddComponent("abyssdamage")
    inst.components.abyssdamage:SetBaseDamage(TUNING.BEYONDER_EROSION_DMG)

    local finiteuses = inst:AddComponent("finiteuses")
    finiteuses:SetMaxUses(TUNING.BEYONDER_USES)
    finiteuses:SetUses(TUNING.BEYONDER_USES)
    finiteuses:SetOnFinished(inst.Remove)

    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")

    local equippable = inst:AddComponent("equippable")
    equippable.restrictedtag = tag
    equippable:SetOnEquip(Equip)
    equippable:SetOnUnequip(UnEquip)

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

local function proj()
    local inst = CreateEntity()
    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    MakeProjectilePhysics(inst)

    inst.AnimState:SetBank("blast_wave")
    inst.AnimState:SetBuild("blast_wave")
    inst.AnimState:PlayAnimation("idle", true)
    inst.AnimState:SetOrientation(ANIM_ORIENTATION.OnGround)

    inst:AddTag("weapon")
    inst:AddTag("projectile")
    inst:AddTag("NOCLICK")
    inst:AddTag("NOBLOCK")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst.persists = false

    inst:AddComponent("weapon")
    inst.components.weapon:SetDamage(TUNING.BEYONDER_BASE_DMG)

    inst:AddComponent("abyssdamage")
    inst.components.abyssdamage:SetBaseDamage(TUNING.BEYONDER_EROSION_DMG)

    inst:AddComponent("projectile")
    inst.components.projectile:SetSpeed(50)
    inst.components.projectile:SetHoming(false)
    inst.components.projectile:SetOnHitFn(OnProjHit)
    inst.components.projectile:SetHitDist(1.5)
    inst.components.projectile:SetLaunchOffset(Vector3(0, LAUNCH_OFFSET_Y, 0))
    inst.components.projectile:SetOnMissFn(inst.Remove)
    inst.components.projectile.range = 30
    inst.components.projectile.has_damage_set = true

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

return Prefab("helheim_beyonder",             fn,       assets),
       Prefab("helheim_beyonder_equip_fx",    followfx, assets),
       Prefab("helheim_beyonder_proj",        proj,     assets),
       Derive("helheim_beyonder", "thegrasp", thegrasp, assets)
