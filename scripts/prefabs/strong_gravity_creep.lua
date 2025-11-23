local assets =
{
    Asset("ANIM", "anim/antlion_sinkhole.zip"),
}

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddNetwork()
    inst.entity:AddGroundCreepEntity()
    inst.entity:AddFollower()

    inst.entity:AddAnimState()
    inst.AnimState:SetBank("sinkhole")
    inst.AnimState:SetBuild("antlion_sinkhole")
    inst.AnimState:PlayAnimation("cracks_pre1")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst.GroundCreepEntity:SetRadius(3)

    inst.persists = false

    return inst
end

--table.insert(require "fx", {

--})

return Prefab("strong_gravity_creep", fn, assets)
