local SPELLBOOK_RADIUS = 120

local function ReticuleTargetAllowWaterFn()
    local player = ThePlayer
    local ground = TheWorld.Map
    local pos = Vector3(0, 0, 0)
    --Cast range is 8, leave room for error
    --4 is the aoe range
    for r = 7, 0, -.25 do
        pos.x, pos.y, pos.z = player.entity:LocalToWorldSpace(r, 0, 0)
        if ground:IsPassableAtPoint(pos.x, 0, pos.z, true) and not ground:IsGroundTargetBlocked(pos) then
            return pos
        end
    end
    return pos
end

local function AddEquipTag(inst, tag)
    inst:AddTag(tag)
    local owner = inst.components.inventoryitem:GetGrandOwner()
    if owner and owner.components.inventory and inst == owner.components.inventory:GetEquippedItem(EQUIPSLOTS.SPELL) then
        owner.components.inventory:Equip(inst)
    end
end

local function RemoveEquipTag(inst, tag)
    inst:RemoveTag(tag)
    local owner = inst.components.inventoryitem:GetGrandOwner()
    if owner and owner.components.inventory and inst == owner.components.inventory:GetEquippedItem(EQUIPSLOTS.SPELL) then
        owner.components.inventory:Equip(inst)
    end
end

local function fn()
    ---@class spell_item: ent
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddNetwork()

    inst:AddTag("throw_line")

    local aoetargeting = inst:AddComponent("aoetargeting")
    aoetargeting:SetAllowWater(true)
    aoetargeting:SetRange(1)
    aoetargeting.reticule.targetfn = ReticuleTargetAllowWaterFn
    aoetargeting.reticule.validcolour = { 1, 1, 1, 1 }
    aoetargeting.reticule.invalidcolour = { .5, .5, .5, .9 }
    aoetargeting.reticule.ease = true
    aoetargeting.reticule.mouseenabled = true
    aoetargeting.reticule.twinstickmode = 1
    aoetargeting.reticule.twinstickrange = TUNING.WINONA_REMOTE_RANGE

    inst:AddComponent("spellbook")
    inst.components.spellbook:SetRadius(SPELLBOOK_RADIUS)
    inst.components.spellbook:SetFocusRadius(SPELLBOOK_RADIUS) --UIAnimButton don't use focus radius SPELLBOOK_FOCUS_RADIUS)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("aoespell")

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.canbepickedup = false
    inst.components.inventoryitem.cangoincontainer = false
    inst.components.inventoryitem.canonlygoinpocket = true
    inst.components.inventoryitem.keepondeath = true

    inst:AddComponent("equippable")
    inst.components.equippable.equipslot = EQUIPSLOTS.SPELL

    inst.AddEquipTag = AddEquipTag
    inst.RemoveEquipTag = RemoveEquipTag

    inst.persists = false

    return inst
end

return Prefab("spell_item", fn)
