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

local function updatespells(inst, owner)
    if owner ~= nil then
        inst.components.spellbook:SetItems(require("prefabs/spells_" .. owner.prefab)(owner))
    end
end

local function WatchSkillRefresh_Client(inst, owner)
    if inst._owner then
        inst:RemoveEventCallback("onactivateskill_client", inst._onskillrefresh_client, inst._owner)
        inst:RemoveEventCallback("ondeactivateskill_client", inst._onskillrefresh_client, inst._owner)
    end
    inst._owner = owner
    if owner then
        inst:ListenForEvent("onactivateskill_client", inst._onskillrefresh_client, owner)
        inst:ListenForEvent("ondeactivateskill_client", inst._onskillrefresh_client, owner)
    end
end

local function WatchSkillRefresh_Server(inst, owner)
    if inst._owner then
        inst:RemoveEventCallback("onactivateskill_server", inst._onskillrefresh_server, inst._owner)
        inst:RemoveEventCallback("ondeactivateskill_server", inst._onskillrefresh_server, inst._owner)
    end
    inst._owner = owner
    if owner then
        inst:ListenForEvent("onactivateskill_server", inst._onskillrefresh_server, owner)
        inst:ListenForEvent("ondeactivateskill_server", inst._onskillrefresh_server, owner)
    end
end

local function DoClientUpdateSpells(inst, force)
    --V2C: inst.replica.inventoryitem:IsHeldBy(ThePlayer) won't work for new ember
    --     spawned directly in pocket, because inventory preview won't have been
    --     resolved yet.
    --     Use IsHeld(), and assume it's ours, since this can only go into pockets
    --     and not containers.
    local owner = inst.replica.inventoryitem:IsHeld() and ThePlayer or nil
    if owner ~= inst._owner then
        if owner then
            updatespells(inst, owner)
        end
        WatchSkillRefresh_Client(inst, owner)
    elseif force and owner then
        updatespells(inst, owner)
    end
end

local function topocket(inst, owner)
    if owner ~= inst._owner then
        inst._updatespells:push()
        updatespells(inst, owner)
        WatchSkillRefresh_Server(inst, owner)
    end
end

local function toground(inst)
    if inst._owner then
        WatchSkillRefresh_Server(inst, nil)
        inst._updatespells:push()
    end
end

local function fn()
    ---@class spell_item: ent
    ---@field _updatespells net_event
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

    inst._updatespells = net_event(inst.GUID, "spell_item._updatespells")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        inst._onskillrefresh_client = function(owner) DoClientUpdateSpells(inst, true) end
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

    inst:ListenForEvent("onputininventory", topocket)
    inst:ListenForEvent("ondropped", toground)

    inst.AddEquipTag = AddEquipTag
    inst.RemoveEquipTag = RemoveEquipTag

    inst._onskillrefresh_server = function(owner) updatespells(inst, owner) end

    inst.persists = false

    return inst
end

return Prefab("spell_item", fn)
