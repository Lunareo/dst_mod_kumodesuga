local assets = { Asset("ANIM", "anim/poison.zip") }

local function Removefx(inst)
    inst.AnimState:PushAnimation("level" .. inst.level .. "_pst", false)
    inst:RemoveEventCallback("animqueueover", Removefx)
    inst:ListenForEvent("animqueueover", function()
        inst.SoundEmitter:KillSound("poisoned")
        inst:Remove()
    end)
end

local function MakeFX(name, level, loop)
    local function fn()
        local inst = CreateEntity()
        inst.entity:AddTransform()
        local anim = inst.entity:AddAnimState()
        inst.entity:AddSoundEmitter()
        inst.entity:AddNetwork()
        inst.entity:AddFollower()

        anim:SetBank("poison")
        anim:SetBuild("poison")
        anim:SetFinalOffset(2)
        anim:SetMultColour(.4, .1, 1, 1)

        inst.level = level or 2
        anim:PlayAnimation("level" .. inst.level .. "_pre")
        if loop then
            anim:PushAnimation("level" .. inst.level .. "_loop", loop) -- Let this loop until something externally calls StopBubbles
        else
            inst:ListenForEvent("animqueueover", Removefx)
        end

        inst:AddTag("fx")

        if not TheWorld.ismastersim then return inst end

        inst.persists = false
        return inst
    end

    return Prefab(name, fn, assets)
end

return MakeFX("erosion_fx_loop", 1, true),
    MakeFX("erosion_fx", 1)
