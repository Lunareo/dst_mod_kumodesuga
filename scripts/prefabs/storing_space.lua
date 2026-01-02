local containers = require "containers"
containers.params.storing_space = {
    widget = {
        animbank = "ui_chest_3x1",
        animbuild = "ui_chest_3x1",
        slotpos = {
            Vector3(-(64 + 12), 0, 0),
            Vector3(0, 0, 0),
            Vector3(64 + 12, 0, 0),
        },
        slotbg = {},
        pos = Vector3(-82, 89, 0),
    },
    type = "side_inv_behind",
}

local function OnDropped(inst)
    inst.components.container:DropEverything()
    inst:Remove()
end

local function ModiSpaceState(player, isconstruct)
    player:AddOrRemoveTag("__storing_space", not isconstruct)
    player:AddOrRemoveTag("_storing_space", isconstruct)
    -- local cur = inst.components.sanity:GetPercentWithPenalty()
    if isconstruct then
        player.components.sanity:AddSanityPenaltyVal("spcont", 100)
    else
        player.components.sanity:RemoveSanityPenaltyVal("spcont")
    end
    -- inst.components.sanity:SetPercent(cur)
end

local function OnEquip(inst, owner)
    if not (owner and owner:IsValid() and owner:HasTag("player") and owner.components.sanity) then return end
    inst.components.container:Open(owner)
    ModiSpaceState(owner, true)
    inst:ListenForEvent("respawnfromghost", function() inst.components.container:Open(owner) end, owner)
end

local function OnBuilt(inst, builder)
    local spcont = builder.components.inventory and builder.components.inventory:GetEquippedItem(EQUIPSLOTS.BEARD)
    if spcont and spcont.prefab == "storing_space" then
        OnDropped(spcont)
    end
    ModiSpaceState(builder)
    inst:Remove()
end

local function containerfn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddNetwork()

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem:SetOnDroppedFn(OnDropped)
    inst.components.inventoryitem.keepondeath = true

    inst:AddComponent("equippable")
    inst.components.equippable.equipslot = EQUIPSLOTS.BEARD
    inst.components.equippable:SetOnEquip(OnEquip)

    inst:AddComponent("container")
    inst.components.container:WidgetSetup("storing_space")
    inst.components.container.skipopensnd = true
    inst.components.container.skipclosesnd = true
    inst.components.container.stay_open_on_hide = true

    inst:AddComponent("preserver")
    inst.components.preserver:SetPerishRateMultiplier(0)

    return inst
end

local function dtorfn()
    ---@class inst:ent
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddNetwork()

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst.OnBuiltFn = OnBuilt

    return inst
end

local function pstfn(inst)
    inst:SetPrefabName("storing_space")
end

return Prefab("storing_space", containerfn),
    Prefab("storing_space_dtor", dtorfn),
    Derive("storing_space", "space_container", pstfn)