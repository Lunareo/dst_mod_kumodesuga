local assets         = { Asset("ANIM", "anim/reticuleaoe.zip") }
local prefabs        = { "reticulemultitargetsub" }

local CREATURES_MUST = { "_combat" }
local CREATURES_CAN  = { "monster", "smallcreature", "largecreature", "animal", "bigbernie", "character" }
local CREATURES_CANT = { "INLIMBO", "flight", "player", "ghost", "invisible", "noattack", "notarget" }

local function OnUpdateNearestTarget(inst, dt)
    local target = FindClosestEntity(inst, 4, nil, CREATURES_MUST, CREATURES_CANT)
    if target ~= nil then
        inst.Transform:SetPosition(target.Transform:GetWorldPosition())
    end
end

local function main()
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
    inst.AnimState:PlayAnimation("idle_target_6")
    inst.AnimState:SetOrientation(ANIM_ORIENTATION.OnGround)
    inst.AnimState:SetLayer(LAYER_WORLD_BACKGROUND)
    inst.AnimState:SetSortOrder(3)
    inst.AnimState:SetScale(1.15, 1.15)
    inst.AnimState:SetBloomEffectHandle("shaders/anim.ksh")

    inst:AddComponent("updatelooper")
    inst.components.updatelooper:AddOnUpdateFn(OnUpdateNearestTarget)

    return inst
end

return Prefab("reticuleabsorb", main, assets, prefabs)
