local function AttachEchoFXOwner(inst, owner)
    local build, bank, anim, frame = owner.AnimState:GetBuild(), owner.AnimState:GetHistoryData()
    local rot = owner.Transform:GetRotation()
    inst.Transform:SetPosition(owner.Transform:GetWorldPosition())
    inst.AnimState:SetBuild(build)
    inst.AnimState:SetBankAndPlayAnimation(bank, anim)
    inst.AnimState:SetFrame(frame)
    inst.Transform:SetRotation(rot)
end

local function ghost()
    ---@class inst:ent
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.Transform:SetFourFaced()

    inst.entity:AddAnimState()
    inst.AnimState:SetMultColour(0, 0, 0, 0)

    inst:AddTag("FX")
	inst:AddTag("NOCLICK")
	inst:AddTag("notarget")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        inst.CanMouseThrough = function() return true, true end
        return inst
    end

    inst:DoTaskInTime(FRAMES * 1, function() inst.AnimState:SetMultColour(1, 1, 1, .4) end)
    inst:DoTaskInTime(FRAMES * 2, function() inst.AnimState:SetMultColour(1, 1, 1, .2) end)
    inst:DoTaskInTime(FRAMES * 3, inst.Remove)

    inst.AttachFXOwner = AttachEchoFXOwner

    inst.persists = false
    return inst
end

return Prefab("echo_shadow_fx", ghost)
