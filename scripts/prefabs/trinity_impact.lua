local function onequipped(inst, owner)
    owner.AnimState:OverrideSymbol("swap_object", "swap_spear", "swap_spear")
    owner.AnimState:Show("ARM_carry")
    owner.AnimState:Hide("ARM_normal")
end

local function onunequipped(inst, owner)
    owner.AnimState:ClearOverrideSymbol("swap_object")
    owner.AnimState:Hide("ARM_carry")
    owner.AnimState:Show("ARM_normal")
end

local function elematkchance(inst, chance, luck)
    return luck > 0 and chance * (2 - 4 / (4 + luck))
end

local function getnextelem(inst, owner)
    return math.random() < GetEntityLuckChance(owner, .33, elematkchance) and math.random(3) or 0
end

---@param inst weapon_trinity_impact
---@param attacker ent|nil
---@param target ent|nil
local function onattacked(inst, attacker, target)
    if inst.elem == 1 then
        if target ~= nil then
            if target.components.burnable then
                target.components.burnable:Ignite(nil, attacker)
            end
            if target.components.freezable then
                target.components.freezable:Unfreeze()
            end
            if target.components.health then
                target.components.health:DoFireDamage(0, attacker or inst)
            end
        end
    elseif inst.elem == 2 then
        if target ~= nil then
            if target.components.burnable then
                if target.components.burnable:IsBurning() then
                    target.components.burnable:Extinguish()
                elseif target.components.burnable:IsSmoldering() then
                    target.components.burnable:SmotherSmolder()
                end
            end
            if target.components.freezable then
                target.components.freezable:AddColdness(2)
                target.components.freezable:SpawnShatterFX()
            end
            ---@class fx_deerclops_icespike_fx: ent
            ---@field RestartFX function
            local fx = SpawnAt("deerclops_icespike_fx", target)
            fx:ForceFacePoint(inst.Transform:GetWorldPosition())
            fx:RestartFX()
        end
    elseif inst.elem == 3 then
        if attacker and target then
            SpawnElectricHitSparks(attacker, target, true)
        end
        local weapon = inst.components.weapon
        weapon.stimuli = nil
        weapon.electric_damage_mult = nil
        weapon.electric_wet_damage_mult = nil
    end
    inst.elem = getnextelem(inst, attacker)
    if inst.elem == 3 then
        inst.components.weapon:SetElectric(1, 2)
    end
end

local function fn()
    ---@class weapon_trinity_impact: ent
    ---@field elem number
    local inst = CreateEntity()

    inst.entity:AddTransform()

    inst.entity:AddAnimState()
    inst.AnimState:SetBank("spear") --// Prefab: 需要新贴图
    inst.AnimState:SetBuild("swap_spear")
    inst.AnimState:PlayAnimation("idle")

    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst:AddTag("weapon")

    MakeInventoryFloatable(inst, "med", .05)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem:ChangeImageName("spear")

    inst:AddComponent("equippable")
    inst.components.equippable:SetOnEquip(onequipped)
    inst.components.equippable:SetOnUnequip(onunequipped)
    inst.components.equippable.equipslot = EQUIPSLOTS.HANDS

    inst:AddComponent("weapon")
    inst.components.weapon:SetDamage(51)
    inst.components.weapon:SetOnAttack(onattacked)

    inst:AddComponent("inspectable")

    MakeHauntableLaunch(inst)

    onattacked(inst, inst)

    return inst
end

return Prefab("trinity_impact", fn)
