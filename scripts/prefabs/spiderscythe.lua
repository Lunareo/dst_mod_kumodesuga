---@diagnostic disable: undefined-field
local assets = {
    Asset("ANIM", "anim/spiderscythe.zip"),
}

local TAG_CAN_USE = "D_spirit"

local function Equip(inst, owner)
    owner.AnimState:OverrideSymbol("swap_object", "spiderscythe", "swap_spiderscythe")
    owner.AnimState:Show("arm_carry")
    owner.AnimState:Hide("arm_normal")
    if inst._thron_task then
        inst._thron_task:Cancel()
        inst._thron_task = nil
    end
    inst._thron_task = owner and owner:IsValid() and not owner:HasTag(TAG_CAN_USE) and owner.components.health and
        inst:DoPeriodicTask(1, function() owner.components.health:DoDelta(TUNING.SPIDER_SCYTHE_THN_DMG, nil, "arachnecurse") end)
    inst.components.aoetargeting:SetEnabled(owner:HasTag(TAG_CAN_USE))
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
    return TUNING.SPIDER_SCYTHE_BASE_DMG + ((target or rawget(_G, "Insight")) and 0 or TUNING.SPIDER_SCYTHE_EROSION_DMG)
end

local function OnAttack(inst, attacker, target)
    if not (attacker and attacker:IsValid()) then return end
    if target and target:IsValid() and target.components.combat then
        target:AddDebuff("erosion", "buff_erosion", {
            attacker = attacker, weapon = inst
        })
    end
    if attacker:HasTag(TAG_CAN_USE) then
        if attacker.components.health then
            attacker.components.health:DoDelta(TUNING.SPIDER_SCYTHE_HP_DRAIN_RT, nil, "hemophagia")
        end
        if attacker.components.hunger then
            attacker.components.hunger:DoDelta(TUNING.SPIDER_SCYTHE_SP_COST_RT)
        end
    end
end

local function Dapper(inst, owner)
    return owner and not owner:HasTag(TAG_CAN_USE) and TUNING.SPIDER_SCYTHE_DAPPER or 0
end

local function ReticuleMouseTargetFn(inst, mousepos)
    if mousepos ~= nil then
        local x, y, z = inst.Transform:GetWorldPosition()
        local dx = mousepos.x - x
        local dz = mousepos.z - z
        local l = dx * dx + dz * dz
        if l <= 0 then
            return inst.components.reticule and inst.components.reticule.targetpos or mousepos
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
            if ent.components.combat ~= nil then
                ent.components.combat:GetAttacked(combat.inst, dmg, weapon, stimuli, spdmg)
            end
            ent:AddDebuff("erosion", "buff_erosion", {
                attacker = combat.inst, weapon = weapon
            })
            hitcount = hitcount + 1
        end
    end
    return hitcount
end

local function SpellFn(inst, doer, pos)
    if not (inst and inst:IsValid() and doer and doer:IsValid()) then return end
    inst.components.rechargeable:Discharge(4)
    if inst.components.finiteuses ~= nil then
        inst.components.finiteuses:Use(1)
    end
    if doer.components.inventory ~= nil then
        doer.components.inventory:Unequip(EQUIPSLOTS.HANDS)
    end
    inst:RemoveFromScene()
    local proj = SpawnPrefab("spiderscythe_projectile")
    if proj ~= nil then
        local doerpos = doer:GetPosition()
        proj.Transform:SetPosition(doerpos.x, 1, doerpos.z)
        proj:Launch(doer, pos, inst)
    else
        inst:ReturnToScene()
        if doer.components.inventory ~= nil then
            doer.components.inventory:Equip(inst)
        end
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

local function HarvestPickable(inst, ent, doer)
    if ent.components.pickable.picksound ~= nil then
        doer.SoundEmitter:PlaySound(ent.components.pickable.picksound)
    end

    local success, loot = ent.components.pickable:Pick(TheWorld)

    if loot ~= nil then
        for i, item in ipairs(loot) do
            Launch(item, doer, 1.5)
        end
    end
    return success
end

local function IsEntityInFront(inst, entity, doer_rotation, doer_pos)
    local facing = Vector3(math.cos(-doer_rotation / RADIANS), 0 , math.sin(-doer_rotation / RADIANS))

    return IsWithinAngle(doer_pos, facing, TUNING.VOIDCLOTH_SCYTHE_HARVEST_ANGLE_WIDTH, entity:GetPosition())
end

local HARVEST_MUSTTAGS  = {"pickable"}
local HARVEST_CANTTAGS  = { "INLIMBO", "FX", "intense" }

local function DoScythe(inst, target, doer)
    if target.components.pickable ~= nil then
        local doer_pos = doer:GetPosition()
        local x, y, z = doer_pos:Get()

        local doer_rotation = doer.Transform:GetRotation()

        local harvestedcount = 0
        local ents = TheSim:FindEntities(x, y, z, TUNING.VOIDCLOTH_SCYTHE_HARVEST_RADIUS, HARVEST_MUSTTAGS, HARVEST_CANTTAGS, HARVESTABLE_PLANT_TARGET_TAGS)
        for _, ent in pairs(ents) do
            if ent:IsValid() and ent.components.pickable ~= nil then
                if inst:IsEntityInFront(ent, doer_rotation, doer_pos) then
                    if inst:HarvestPickable(ent, doer) then
                        harvestedcount = harvestedcount + 1
                    end
                end
            end
        end
        if harvestedcount > 0 then
            doer:PushEvent("picksomethingfromaoe", {harvestedcount = harvestedcount,})
        end
    end
end

local function fn()
    ---@class spiderscythe: ent
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
    inst:AddTag("scythe")

    MakeInventoryFloatable(inst, "med", 0.05)

    local aoetargeting = inst:AddComponent("aoetargeting")
    aoetargeting:SetAlwaysValid(true)
    aoetargeting:SetEnabled(false)
    aoetargeting:SetAllowRiding(false)
    aoetargeting.reticule.reticuleprefab = "reticuleline"
    aoetargeting.reticule.pingprefab = "reticulelineping"
    aoetargeting:SetRange(10)
    aoetargeting:SetDeployRadius(0)

    inst.displaynamefn = DisplayNameFn

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("finiteuses")
    inst.components.finiteuses:SetMaxUses(TUNING.SPIDER_SCYTHE_USES)
    inst.components.finiteuses:SetUses(TUNING.SPIDER_SCYTHE_USES)
    inst.components.finiteuses:SetOnFinished(inst.Remove)
    inst.components.finiteuses:SetConsumption(ACTIONS.MINE, 1)
    inst.components.finiteuses:SetConsumption(ACTIONS.SCYTHE, 1)

    inst:AddComponent("tool")
    inst.components.tool:SetAction(ACTIONS.MINE)
    inst.components.tool:SetAction(ACTIONS.SCYTHE)
    if ACTIONS.HACK ~= nil then
        inst.components.tool:SetAction(ACTIONS.HACK)
    end

    inst:AddComponent("equippable")
    inst.components.equippable:SetOnEquip(Equip)
    inst.components.equippable:SetOnUnequip(UnEquip)
    inst.components.equippable:SetDappernessFn(Dapper)
    inst.components.equippable.critrate = .05
    inst.components.equippable.critdamagerate = .3

    inst:AddComponent("weapon")
    inst.components.weapon:SetDamage(DmgFn)
    inst.components.weapon:SetRange(TUNING.SPIDER_SCYTHE_ATK_RANGE, TUNING.SPIDER_SCYTHE_ATK_RANGE + 1)
    inst.components.weapon:SetOnAttack(OnAttack)

    inst:AddComponent("erosiondamage")
    inst.components.erosiondamage:SetBaseDamage(TUNING.SPIDER_SCYTHE_EROSION_DMG)

    inst:AddComponent("aoespell")
    inst.components.aoespell:SetSpellFn(SpellFn)

    inst:AddComponent("rechargeable")
    inst.components.rechargeable:SetOnDischargedFn(OnDischarged)
    inst.components.rechargeable:SetOnChargedFn(OnCharged)

    inst:AddComponent("inventoryitem")
    inst:AddComponent("inspectable")

    inst:DoPeriodicTask(6, function()
        if inst.components.finiteuses ~= nil then
            local cur = inst.components.finiteuses:GetUses()
            local max_uses = inst.components.finiteuses.total or TUNING.SPIDER_SCYTHE_USES
            if cur < max_uses then
                inst.components.finiteuses:SetUses(math.min(cur + 1, max_uses))
            end
        end
    end)

    MakeHauntableLaunch(inst)

    inst.DoScythe = DoScythe
    inst.IsEntityInFront = IsEntityInFront
    inst.HarvestPickable = HarvestPickable

    return inst
end

----------------------------------------------------------------------------------------
-- Thrown Scythe Projectile (脱手回旋飞刃)
----------------------------------------------------------------------------------------

local function proj_fn()
    ---@class scythe_proj: ent
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    inst.AnimState:SetBank("spiderscythe")
    inst.AnimState:SetBuild("spiderscythe")
    inst.AnimState:PlayAnimation("idle", true)
    inst.AnimState:SetScale(1.1, 1.1, 1.1)

    inst:AddTag("FX")
    inst:AddTag("NOCLICK")
    inst:AddTag("projectile")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst.persists = false

    local function CatchWeapon(self)
        local doer = self._doer
        local weapon = self._weapon
        if weapon ~= nil and weapon:IsValid() then
            weapon:ReturnToScene()
            if doer ~= nil and doer:IsValid() and not doer:HasTag("playerghost") and doer.components.inventory ~= nil then
                doer.SoundEmitter:PlaySound("dontstarve/wilson/boomerang_return")
                if doer.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS) == nil then
                    doer.components.inventory:Equip(weapon)
                else
                    doer.components.inventory:GiveItem(weapon)
                end
            else
                weapon.Transform:SetPosition(self.Transform:GetWorldPosition())
            end
        end
        self:Remove()
    end

    function inst:Launch(doer, targetpos, weapon)
        self._doer = doer
        self._weapon = weapon
        local startpos = doer:GetPosition()
        local dir = (targetpos - startpos):Normalize()
        if dir:LengthSq() <= 0 then
            dir = Vector3(1, 0, 0)
        end
        self._dir = dir
        self._dist = 0
        self._max_dist = 10
        self._returning = false
        self._hit_targets = {}

        self:StartUpdatingComponent(self)
    end

    function inst:OnUpdate(dt)
        local cur_rot = self.Transform:GetRotation()
        self.Transform:SetRotation(cur_rot + 35)

        local pos = self:GetPosition()
        local doer = self._doer
        local weapon = self._weapon

        if not (doer and doer:IsValid()) then
            CatchWeapon(self)
            return
        end

        local speed = 22
        if not self._returning then
            local next_pos = pos + self._dir * (speed * dt)
            self.Transform:SetPosition(next_pos.x, 1, next_pos.z)
            self._dist = self._dist + speed * dt
            if self._dist >= self._max_dist then
                self._returning = true
                self._hit_targets = {}
            end
        else
            local doer_pos = doer:GetPosition()
            local to_doer = doer_pos - pos
            local dist_to_doer = to_doer:Length()
            if dist_to_doer <= 1.5 then
                CatchWeapon(self)
                return
            end
            local return_dir = to_doer:Normalize()
            local next_pos = pos + return_dir * (speed * dt)
            self.Transform:SetPosition(next_pos.x, 1, next_pos.z)
        end

        local p = self:GetPosition()
        local ents = TheSim:FindEntities(p.x, 0, p.z, 2, { "_combat" }, { "INLIMBO", "player", "companion", "playerghost", "wall" })
        for _, ent in ipairs(ents) do
            if ent ~= doer and ent:IsValid() and not self._hit_targets[ent] then
                if not (ent.components.follower and ent.components.follower:GetLeader() and ent.components.follower:GetLeader():HasTag("player")) then
                    self._hit_targets[ent] = true
                    if ent.components.combat ~= nil then
                        ent.components.combat:GetAttacked(doer, TUNING.SPIDER_SCYTHE_BASE_DMG, weapon, "erosion", { erosion = TUNING.SPIDER_SCYTHE_EROSION_DMG })
                    end
                    ent:AddDebuff("erosion", "buff_erosion", { attacker = doer, weapon = weapon })
                    if doer:HasTag(TAG_CAN_USE) then
                        if doer.components.health then
                            doer.components.health:DoDelta(TUNING.SPIDER_SCYTHE_HP_DRAIN_RT, nil, "hemophagia")
                        end
                        if doer.components.hunger then
                            doer.components.hunger:DoDelta(TUNING.SPIDER_SCYTHE_SP_COST_RT)
                        end
                    end
                    SpawnAt("impact", ent)
                end
            end
        end
    end

    inst.OnEntitySleep = function(inst)
        CatchWeapon(inst)
    end

    return inst
end

return Prefab("spiderscythe", fn, assets, { "spiderscythe_projectile" }),
    Prefab("spiderscythe_projectile", proj_fn, assets)
