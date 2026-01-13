local allsymbols = {
    "arm_lower_cuff", "arm_lower", "arm_upper_skin", "arm_upper", "BEARD", "face", "foot", "HAIR_HAT",
    "hair", "hairfront", "hairpigtails", "hand", "headbase_hat", "headbase", "LANTERN_OVERLAY", "leg", "skirt",
    "SWAP_BODY_TALL", "SWAP_BODY_TALL", "SWAP_BODY", "SWAP_BODY", "SWAP_FACE", "swap_hat", "swap_object", "tail",
    "torso_pelvis", "torso",
}

local function AttachEchoFXOwner_Client(inst, owner)
    if not TheNet:IsDedicated() then
        inst.Transform:SetPosition(owner.Transform:GetWorldPosition())
        inst.Transform:SetScale(owner.Transform:GetScale())
        inst.Transform:SetRotation(owner.Transform:GetRotation())
        local info = owner:GetDebugString() or ""
        local build, anim, frame = info:match("build: ([%w%d_]+)"), info:match("anim: ([%w%d_]+)"),
            info:match("Frame: (%d+)")
        inst.AnimState:SetBuild(build or 0)
        inst.AnimState:PlayAnimation(anim or 0)
        inst.AnimState:SetFrame(tonumber(frame) or 0)
        for _, symbol in ipairs(allsymbols) do
            local overrridebuild, overridesymbol = owner.AnimState:GetSymbolOverride(symbol)
            if overrridebuild ~= nil and overridesymbol ~= nil then
                inst.AnimState:OverrideSymbol(symbol, overrridebuild, overridesymbol)
            end
        end
        inst:DoTaskInTime(FRAMES * 1, function() inst.AnimState:SetMultColour(1, 1, 1, .3) end)
        inst:DoTaskInTime(FRAMES * 2, function() inst.AnimState:SetMultColour(1, 1, 1, .1) end)
    end
end

local function ghost()
    ---@class echo_shadow_fx_client: ent
    local inst = CreateEntity()
    inst.entity:AddTransform()

    if not TheNet:IsDedicated() then
        inst.Transform:SetFourFaced()

        inst.entity:AddAnimState()
        inst.AnimState:SetBank("wilson")
        inst.AnimState:SetMultColour(0, 0, 0, 0)
    end

    inst:AddTag("FX")

    inst.AttachFXOwner = AttachEchoFXOwner_Client

    inst:DoTaskInTime(FRAMES * 3, inst.Remove)

    inst.persists = false

    return inst
end

return Prefab("echo_shadow_fx_client", ghost)
