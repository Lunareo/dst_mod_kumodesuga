local assets         = { Asset("ANIM", "anim/reticuleaoe.zip") }
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

return Prefab("reticuleabsorb", main, assets, prefabs)
