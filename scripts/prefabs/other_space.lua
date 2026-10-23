-- Shiro 的随身异空间：隐藏的口袋维度容器（other_space_3x2/3x3/3x4）与打开它的 space_proxy。
-- 与 wakaba 的 storing_space（BEARD 槽容器）互不相关，故分开维护。
local params = require "containers".params

params.other_space_3x2 = shallowcopy(params.sacred_chest)
params.other_space_3x3 = shallowcopy(params.treasurechest)
params.other_space_3x4 = shallowcopy(params.dragonflychest)

local function testfn(container, item, slot)
    return not (item and item.replica.health)
end

params.other_space_3x2.itemtestfn = testfn
params.other_space_3x3.itemtestfn = testfn
params.other_space_3x4.itemtestfn = testfn

local proxyassets = {
    Asset("ANIM", "anim/space_proxy.zip"),
}

---@class ent
---@field space_proxy prefab_space_proxy|nil

local function AttachOwner(inst, owner)
    inst.owner = owner
    owner.space_proxy = inst
end

local function OnProxyClose(inst)
    inst.AnimState:PushAnimation("proxy_pst", false)
    inst.SoundEmitter:PlaySound("dontstarve/tentacle/tentacle_disappear")
    if inst.owner ~= nil then
        inst.owner.space_proxy = nil
        inst.owner = nil
    end
    inst:ListenForEvent("animqueueover", inst.Remove)
end

local function MakeSpaceContainer(name)
    return Prefab(name, function()
        local inst = CreateEntity()
        inst.entity:AddTransform()
        inst.entity:AddNetwork()
        -- Pocket-dimension style storage: not a world interactable chest.
        inst:AddTag("CLASSIFIED")
        inst:AddTag("pocketdimension_container")

        inst:SetPrefabNameOverride("space_proxy")

        inst.entity:Hide()
        inst.entity:SetPristine()
        if not TheWorld.ismastersim then
            return inst
        end

        inst:AddComponent("container")
        inst.components.container:WidgetSetup(name)
        -- Critical: without this, Container:OnUpdate distance-checks the
        -- (often misplaced) child entity and instantly Close() after Open.
        inst.components.container.skipautoclose = true
        inst.components.container.skipopensnd = true
        inst.components.container.skipclosesnd = true

        inst:AddComponent("preserver")
        inst.components.preserver:SetPerishRateMultiplier(0)

        return inst
    end)
end

local function proxy()
    ---@class prefab_space_proxy: ent
    local inst = CreateEntity()

    inst.entity:AddTransform()

    inst.entity:AddAnimState()
    inst.AnimState:SetBank("space_proxy")
    inst.AnimState:SetBuild("space_proxy")
    inst.AnimState:PlayAnimation("proxy_pre")
    inst.AnimState:PushAnimation("proxy_loop", true)

    inst.entity:AddSoundEmitter()
    inst.SoundEmitter:PlaySound("dontstarve/common/lava_arena/portal_doom")

    inst.entity:AddNetwork()

    inst:AddComponent("container_proxy")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    -- Placeholder master until a real doer opens us; never leave nil (Open asserts master).
    inst.components.container_proxy:SetMaster(TheWorld:GetPocketDimensionContainer("shadow"))
    local Open = inst.components.container_proxy.Open
    ---@param doer class
    function inst.components.container_proxy:Open(doer)
        local space = doer and doer._other_space
        if space == nil or not space:IsValid() or space.components.container == nil then
            return
        end
        if next(self.openlist) then
            return
        end
        -- Bind to this player's pocket before opening.
        self:SetMaster(space)
        -- Ensure pocket never auto-closes due to parented/hidden entity checks.
        space.components.container.skipautoclose = true
        return Open(self, doer)
    end

    inst.components.container_proxy:SetOnCloseFn(OnProxyClose)

    inst.AttachOwner = AttachOwner

    inst.persists = false

    return inst
end

return MakeSpaceContainer("other_space_3x2"),
    MakeSpaceContainer("other_space_3x3"),
    MakeSpaceContainer("other_space_3x4"),
    Prefab("space_proxy", proxy, proxyassets)
