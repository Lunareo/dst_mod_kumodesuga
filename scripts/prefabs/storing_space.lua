local params = require "containers".params
params.storing_space = {
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
params.other_space_3x2 = params.sacred_chest
params.other_space_3x3 = params.treasurechest
params.other_space_3x4 = params.dragonflychest

local proxyassets = {
    Asset("ANIM", "anim/quagmire_portal_fx.zip"),
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

local function OnProxyClose(inst)
    inst.AnimState:PushAnimation("portal_pst", false)
    inst:ListenForEvent("animqueueover", inst.Remove)
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

local function MakeSpaceContainer(name)
    return Prefab(name, function()
        local inst = CreateEntity()
        inst.entity:AddTransform()
        inst.entity:AddNetwork()
        inst.entity:SetPristine()
        if not TheWorld.ismastersim then
            return inst
        end

        inst:AddComponent("container")
        inst.components.container:WidgetSetup(name)

        inst:AddComponent("preserver")
        inst.components.preserver:SetPerishRateMultiplier(0)

        return inst
    end)
end

local function proxy()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.Transform:SetScale(.075, .25, .25)

    inst.entity:AddAnimState()
    inst.AnimState:SetBank("quagmire_portal_fx")
    inst.AnimState:SetBuild("quagmire_portal_fx")
    inst.AnimState:PlayAnimation("portal_pre")
    inst.AnimState:PushAnimation("portal_loop", true)

    inst.entity:AddNetwork()

    inst:AddComponent("container_proxy")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst.components.container_proxy:SetMaster(TheWorld:GetPocketDimensionContainer("shadow"))
    local Open = inst.components.container_proxy.Open
    ---@param doer class
    function inst.components.container_proxy:Open(doer)
        if doer._other_space and not next(self.openlist) then
            self:SetMaster(doer._other_space)
            return Open(self, doer)
        end
    end
    inst.components.container_proxy:SetOnCloseFn(OnProxyClose)

    inst.persists = false

    return inst
end

return Prefab("storing_space", containerfn),
    Prefab("storing_space_dtor", dtorfn),
    MakeSpaceContainer("other_space_3x2"),
    MakeSpaceContainer("other_space_3x3"),
    MakeSpaceContainer("other_space_3x4"),
    Prefab("space_proxy", proxy, proxyassets)
