local assets         = {
    Asset("ANIM", "anim/reticuleaoe.zip"),
    Asset("ANIM", "anim/shiro_targeting.zip"),
}
local prefabs        = { "reticulemultitargetsub" }

local CREATURES_MUST = { "_combat" }
local CREATURES_CAN  = { "monster", "smallcreature", "largecreature", "animal", "bigbernie", "character" }
local CREATURES_CANT = { "INLIMBO", "flight", "player", "ghost", "invisible", "noattack", "notarget" }

local function onremove(inst)
    if inst._targets then
        for _, v in ipairs(inst._targets) do
            v:Remove()
        end
    end
    inst._targets = nil
end

local function OnUpdateNearestTarget(inst, dt)
    if not inst._targets then
        inst._targets = { SpawnAt("reticulemultitargetsub", inst) }
    end
    local target = FindClosestEntity(inst, 4, nil, CREATURES_MUST, CREATURES_CANT)
    if target then
        inst.AnimState:PlayAnimation("_")
        inst._targets[1]:ReturnToScene()
        inst._targets[1].Transform:SetPosition(target.Transform:GetWorldPosition())
    else
        inst.AnimState:PlayAnimation("idle_target_1")
        inst._targets[1]:RemoveFromScene()
    end
end

local function OnUpdateNearestQuart(inst, dt)
    if not inst._targets then
        inst._targets = { SpawnAt("reticuleround2quatersub", inst) }
    end
    local x, _, z = inst.Transform:GetWorldPosition()
    x, z = Round2Quarter(x), Round2Quarter(z)
    inst._targets[1].Transform:SetPosition(x, 0, z)
end

local function fn_absorb()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()

    inst:AddTag("FX")
    inst:AddTag("NOCLICK")
    --[[Non-networked entity]]
    inst.entity:SetCanSleep(false)
    inst.persists = false

    inst.entity:AddTransform()

    inst.AnimState:SetBank("reticuleaoe")
    inst.AnimState:SetBuild("reticuleaoe")
    inst.AnimState:PlayAnimation("idle_target_1")
    inst.AnimState:SetOrientation(ANIM_ORIENTATION.OnGround)
    inst.AnimState:SetLayer(LAYER_WORLD_BACKGROUND)
    inst.AnimState:SetSortOrder(3)
    inst.AnimState:SetBloomEffectHandle("shaders/anim.ksh")

    inst:AddComponent("updatelooper")
    inst.components.updatelooper:AddOnUpdateFn(OnUpdateNearestTarget)

    inst:ListenForEvent("onremove", onremove)

    return inst
end

local function fn_r2q()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()

    inst:AddTag("FX")
    inst:AddTag("NOCLICK")
    --[[Non-networked entity]]
    inst.entity:SetCanSleep(false)
    inst.persists = false

    inst.entity:AddTransform()

    inst.AnimState:SetBank("shiro_targeting")
    inst.AnimState:SetBuild("shiro_targeting")
    --inst.AnimState:PlayAnimation("meter")
    inst.AnimState:SetOrientation(ANIM_ORIENTATION.OnGround)
    inst.AnimState:SetLayer(LAYER_WORLD_BACKGROUND)
    inst.AnimState:SetSortOrder(3)
    inst.AnimState:SetBloomEffectHandle("shaders/anim.ksh")

    inst:AddComponent("updatelooper")
    inst.components.updatelooper:AddOnUpdateFn(OnUpdateNearestQuart)

    inst:ListenForEvent("onremove", onremove)

    return inst
end

local function fn_qsub()
    local inst = Prefabs.reticulemultitargetsub.fn()
    inst.AnimState:SetBank("shiro_targeting")
    inst.AnimState:SetBuild("shiro_targeting")
    inst.AnimState:PlayAnimation("meter")
    inst.AnimState:SetOrientation(ANIM_ORIENTATION.OnGround)
    inst.AnimState:SetLayer(LAYER_WORLD_BACKGROUND)
    inst.AnimState:SetSortOrder(3)
    inst.AnimState:SetBloomEffectHandle("shaders/anim.ksh")
    return inst
end

return Prefab("reticuleabsorb", fn_absorb, assets, prefabs),
    Prefab("reticuleround2quater", fn_r2q, assets, prefabs),
    Prefab("reticuleround2quatersub", fn_qsub, assets, prefabs)
