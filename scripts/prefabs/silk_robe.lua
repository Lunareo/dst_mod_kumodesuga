local params = require("containers").params
params.silk_robe = {
    widget = {
        slotpos = {
            Vector3(0, 20, 0),
            Vector3(0, -52, 0),
        },
        animbank = "ui_cookpot_1x2",
        animbuild = "ui_cookpot_1x2",
        pos = Vector3(-50, 0, 0),
    },
    issidewidget = true,
    type = "pack",
    openlimit = 1,
}

local assets = {
    Asset("ANIM", "anim/shiro.zip"),
    Asset("ANIM", "anim/silk_robe.zip"),
}

local symbols = {
    "arm_lower",
    "arm_upper",
    "torso",
}

local function OnEquip(inst, owner)
    for _, v in ipairs(symbols) do
        owner.AnimState:OverrideSymbol(v, "shiro", v)
    end
    owner.AnimState:Hide("SKIRT")
    inst.components.container:Open(owner)
end

local function OnUnequip(inst, owner)
    for _, v in ipairs(symbols) do
        owner.AnimState:ClearOverrideSymbol(v)
    end
    owner.AnimState:Show("SKIRT")
    inst.components.container:Close(owner)
end

local function repearing(inst)
    inst.components.armor:Repair(7)
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddNetwork()
    inst.entity:AddAnimState()
    inst.AnimState:SetBank("silk_robe")
    inst.AnimState:SetBuild("silk_robe")
    inst.AnimState:PlayAnimation("idle")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("container")
    inst.components.container:WidgetSetup("silk_robe")

    inst:AddComponent("equippable")
    inst.components.equippable.equipslot = EQUIPSLOTS.BODY
    inst.components.equippable:SetOnEquip(OnEquip)
    inst.components.equippable:SetOnUnequip(OnUnequip)

    inst:AddComponent("insulator")
    inst.components.insulator:SetInsulation(180)

    inst:AddComponent("armor")
    inst.components.armor:InitCondition(700, .7)

    inst:AddComponent("inventoryitem")
    inst:AddComponent("inspectable")

    inst:DoPeriodicTask(3, repearing)

    return inst
end

return Prefab("silk_robe", fn, assets)
