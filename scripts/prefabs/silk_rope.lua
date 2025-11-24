local params = require("containers").params
params.silk_rope = {
    widget = {
        slotpos = params.portablespicer.widget.slotpos,
        animbank = params.portablespicer.widget.animbank,
        animbuild = params.portablespicer.widget.animbuild,
        pos = params.portablespicer.widget.pos,
    },
    type = "backpack",
}

local assets = {
    Asset("ANIM", "anim/shiro.zip"),
}

local symbols = {
    arm_lower = "arm_lower",
    arm_upper = "arm_upper",
    swap_body = "torso",
}

local function OnEquip(inst, owner)
    for k, v in pairs(symbols) do
        owner.AnimState:OverrideSymbol(k, "shiro", v)
    end
end

local function OnUnequip(inst, owner)
    for k in pairs(symbols) do
        owner.AnimState:ClearOverrideSymbol(k)
    end
end

local function repearing(inst)
    inst.components.armor:Repair(10)
end

local function fn()
    local inst = CreateEntity()
    inst.entity:AddTransform()
    inst.entity:AddNetwork()
    inst.entity:AddAnimState()
    inst.entity:SetPristine()
    if not TheWorld.ismastersim then
        return inst
    end
    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem:ChangeImageName("winterhat")
    inst:AddComponent("equippable")
    inst.components.equippable.equipslot = EQUIPSLOTS.BODY
    inst.components.equippable:SetOnEquip(OnEquip)
    inst.components.equippable:SetOnUnequip(OnUnequip)
    inst:AddComponent("insulator")
    inst.components.insulator:SetInsulation(180)
    inst:AddComponent("armor")
    inst.components.armor:InitCondition(500, .7)
    inst:AddComponent("inspectable")
    inst:DoPeriodicTask(1, repearing)
    return inst
end

return Prefab("silk_rope", fn, assets)
