---@diagnostic disable: undefined-field
local assets = {
    Asset("ANIM", "anim/spiderscythe.zip"),
}

local tag = "D_spirit"

local TUNE = {
    BASE_DMG = TUNING.BASE_SURVIVOR_ATTACK * 1.25,
    EROSION_DMG = TUNING.BASE_SURVIVOR_ATTACK * .25,
    USES = 200,
    THRON_DMG = -.5,
    HP_DT = 2.5,
    SP_DT = -1,
    DAPPER = TUNING.CRAZINESS_MED,
    RANGE = 1,
    FIX_RATE = 0.7,
}

local function OnKilledOther(attacker, eventdata)
    if attacker and attacker:IsValid() and attacker:HasTag(tag) and eventdata and eventdata.victim and eventdata.victim.components.health and
        attacker.components.inventory then
        local touch = attacker.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)
        if touch and touch.prefab == "spiderscythe" then
            touch.components.finiteuses:SetUses(math.min(
                touch.components.finiteuses:GetUses() +
                math.ceil(eventdata.victim.components.health:GetMaxWithPenalty() / TUNE.BASE_DMG * TUNE.FIX_RATE),
                touch.components.finiteuses.total))
        end
    end
end

local function Equip(inst, owner)
    owner.AnimState:OverrideSymbol("swap_object", "spiderscythe", "swap_spiderscythe")
    owner.AnimState:Show("arm_carry")
    owner.AnimState:Hide("arm_normal")
    if inst._thron_task then
        inst._thron_task:Cancel()
        inst._thron_task = nil
    end
    inst._thron_task = owner and owner:IsValid() and not owner:HasTag(tag) and owner.components.health and
        inst:DoPeriodicTask(1, function()
            owner.components.health:DoDelta(TUNE.THRON_DMG, nil, "arachnecurse")
        end)
    if inst._owner then
        inst:RemoveEventCallback("killed", OnKilledOther, inst._owner)
    end
    inst._owner = owner
    inst:ListenForEvent("killed", OnKilledOther, owner)
    if owner and owner:HasTag(tag) then
        inst.components.aoetargeting:SetEnabled(true)
    end
end

local function UnEquip(inst, owner)
    owner.AnimState:ClearOverrideSymbol("swap_object")
    owner.AnimState:Hide("arm_carry")
    owner.AnimState:Show("arm_normal")
    if inst._thron_task then
        inst._thron_task:Cancel()
        inst._thron_task = nil
    end
    inst.components.aoetargeting:SetEnabled(false)
end

local function DmgFn(inst, attacker, target)
    return TUNE.BASE_DMG + ((target or rawget(_G, "Insight")) and 0 or TUNE.EROSION_DMG)
end

local function OnAttack(inst, attacker, target)
    if not (attacker and attacker:IsValid()) then return end
    if target and target:IsValid() and target.components.combat then
        target:AddDebuff("erosion", "buff_erosion", {
            attacker = attacker, weapon = inst
        })
    end
    if attacker:HasTag(tag) then
        if attacker.components.health then
            attacker.components.health:DoDelta(TUNE.HP_DT, nil, "hemophagia")
        end
        if attacker.components.hunger then
            attacker.components.hunger:DoDelta(TUNE.SP_DT)
        end
    end
end

local function Dapper(inst, owner)
    return owner and not owner:HasTag(tag) and TUNE.DAPPER or 0
end

local function ReticuleMouseTargetFn(inst, mousepos)
    if mousepos ~= nil then
        local x, y, z = inst.Transform:GetWorldPosition()
        local dx = mousepos.x - x
        local dz = mousepos.z - z
        local l = dx * dx + dz * dz
        if l <= 0 then
            return inst.components.reticule.targetpos
        end
        l = 6.5 / math.sqrt(l)
        return Vector3(x + dx * l, 0, z + dz * l)
    end
end

local function ReticuleUpdatePositionFn(inst, pos, reticule, ease, smoothing, dt)
    local x, y, z = inst.Transform:GetWorldPosition()
    reticule.Transform:SetPosition(x, 0, z)
    local rot = -math.atan2(pos.z - z, pos.x - x) / DEGREES
    if ease and dt ~= nil then
        local rot0 = reticule.Transform:GetRotation()
        local drot = rot - rot0
        rot = Lerp((drot > 180 and rot0 + 360) or (drot < -180 and rot0 - 360) or rot0, rot, dt * smoothing)
    end
    reticule.Transform:SetRotation(rot)
end

local NO_TAGS_PVP = { "INLIMBO", "playerghost", "FX", "NOCLICK", "DECOR", "notarget", "companion", "decoy", "wall" }
local NO_TAGS = shallowcopy(NO_TAGS_PVP)
table.insert(NO_TAGS, "player")

-- 从镰刀AOE拿来的
local function HasFriendlyLeader(target, attacker)
    local target_leader = (target.components.follower ~= nil) and target.components.follower.leader or nil

    if target_leader ~= nil then
        if target_leader.components.inventoryitem then
            target_leader = target_leader.components.inventoryitem:GetGrandOwner()
        end

        local PVP_enabled = TheNet:GetPVPEnabled()
        return (target_leader ~= nil
                and (target_leader:HasTag("player")
                    and not PVP_enabled)) or
            (target.components.domesticatable and target.components.domesticatable:IsDomesticated()
                and not PVP_enabled) or
            (target.components.saltlicker and target.components.saltlicker.salted
                and not PVP_enabled)
    end

    return false
end

local function AoEValidFn(target, attacker)
    if target:HasTag("playerghost") then
        return false
    end

    if target:HasTag("monster") and not TheNet:GetPVPEnabled() and
        ((target.components.follower and target.components.follower.leader ~= nil and
            target.components.follower.leader:HasTag("player")) or target.bedazzled) then
        return false
    end

    if HasFriendlyLeader(target, attacker) then
        return false
    end

    return true
end

local AREAATTACK_MUST_TAGS = { "_combat" }
local function AreaAttackPlus(combat, target, range, weapon, validfn, stimuli, excludetags)
    local hitcount = 0
    local x, y, z = target.Transform:GetWorldPosition()
    local ents = TheSim:FindEntities(x, y, z, range, AREAATTACK_MUST_TAGS, excludetags)
    for i, ent in ipairs(ents) do
        if ent ~= target and
            ent ~= combat.inst and
            combat:IsValidTarget(ent) and
            (validfn == nil or validfn(ent, combat.inst)) then
            combat.inst:PushEvent("onareaattackother", { target = ent, weapon = weapon, stimuli = stimuli })
            local dmg, spdmg = combat:CalcDamage(ent, weapon, combat.areahitdamagepercent)
            ent.components.combat:GetAttacked(combat.inst, dmg, weapon, stimuli, spdmg)
            ent:AddDebuff("erosion", "buff_erosion", {
                attacker = combat.inst, weapon = weapon
            })
            hitcount = hitcount + 1
        end
    end
    return hitcount
end

local function DoAoE(inst, attacker, target)
    if attacker.components.combat then
        local range = TUNING.VOIDCLOTH_SCYTHE_HARVEST_RADIUS
        local weapon = inst
        local excludetags = TheNet:GetPVPEnabled() and NO_TAGS_PVP or NO_TAGS
        local hitcount = AreaAttackPlus(attacker.components.combat, target, range, weapon, AoEValidFn, nil, excludetags)
        inst.components.finiteuses:Use(hitcount + 1)
    end
end

local function SpellFn(inst, doer, pos)
    local virtual = CreateEntity()
    local doerpos = doer:GetPosition()
    local vpos = pos - doerpos
    vpos = vpos * ((TUNE.RANGE + 2) / vpos:Length()) + doerpos
    virtual.entity:AddTransform():SetPosition(vpos:Get())
    DoAoE(inst, doer, virtual)
    virtual:Remove()
    if inst and inst:IsValid() then
        inst.components.rechargeable:Discharge(3)
    end
end

local function DisplayNameFn(inst)
    if inst.replica.inventoryitem and ThePlayer and ThePlayer:HasTag("shiro") and inst.replica.inventoryitem:IsHeldBy(ThePlayer) then
        return STRINGS.NAMES.SPIDERSCYTHE_SHIRO
    end
end

local function OnDischarged(inst)
    inst.components.aoetargeting:SetEnabled(false)
end

local function OnCharged(inst)
    inst.components.aoetargeting:SetEnabled(true)
end

local function fn()
    ---@class inst:ent
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("spiderscythe")
    inst.AnimState:SetBuild("spiderscythe")
    inst.AnimState:PlayAnimation("idle", true)

    inst:AddTag("weapon")
    inst:AddTag("lighterweapon")

    MakeInventoryFloatable(inst, "med", 0.05)

    local aoetargeting = inst:AddComponent("aoetargeting")
    aoetargeting:SetAlwaysValid(true)
    aoetargeting:SetEnabled(false)
    aoetargeting:SetAllowRiding(false)
    aoetargeting.reticule.reticuleprefab = "reticulearc"
    aoetargeting.reticule.pingprefab = "reticulearcping"
    aoetargeting.reticule.mousetargetfn = ReticuleMouseTargetFn
    aoetargeting.reticule.updatepositionfn = ReticuleUpdatePositionFn
    aoetargeting.reticule.validcolour = { 1, .75, 0, 1 }
    aoetargeting.reticule.invalidcolour = { .5, 0, 0, 1 }
    aoetargeting.reticule.ease = true
    aoetargeting.reticule.mouseenabled = true

    inst.displaynamefn = DisplayNameFn

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("finiteuses")
    inst.components.finiteuses:SetMaxUses(TUNE.USES)
    inst.components.finiteuses:SetUses(TUNE.USES)
    inst.components.finiteuses:SetOnFinished(inst.Remove)

    inst:AddComponent("equippable")
    inst.components.equippable:SetOnEquip(Equip)
    inst.components.equippable:SetOnUnequip(UnEquip)
    inst.components.equippable:SetDappernessFn(Dapper)

    inst:AddComponent("weapon")
    inst.components.weapon:SetDamage(DmgFn)
    inst.components.weapon:SetRange(TUNE.RANGE, TUNE.RANGE + 1)
    inst.components.weapon:SetOnAttack(OnAttack)

    inst:AddComponent("erosiondamage")
    inst.components.erosiondamage:SetBaseDamage(TUNE.EROSION_DMG)

    inst:AddComponent("aoespell")
    inst.components.aoespell:SetSpellFn(SpellFn)

    inst:AddComponent("rechargeable")
    inst.components.rechargeable:SetOnDischargedFn(OnDischarged)
    inst.components.rechargeable:SetOnChargedFn(OnCharged)

    inst:AddComponent("inventoryitem")
    inst:AddComponent("inspectable")

    MakeHauntableLaunch(inst)
    return inst
end

local function arachne(inst)
    inst:SetPrefabName("spiderscythe")
    if not TheWorld.ismastersim then
        return
    end
    inst.components.inventoryitem.atlasname = GetInventoryItemAtlas("spiderscythe.tex")
    inst.components.inventoryitem:ChangeImageName("spiderscythe")
end

return Prefab("spiderscythe", fn, assets),
    Derive("spiderscythe", "nightmare_touch", arachne, assets)
