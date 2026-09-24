local assets = {
    Asset("ANIM", "anim/ds_spider_basic.zip"),
    Asset("ANIM", "anim/spider_build.zip"),
}

local prefabs = {
    "shiro_clone_item",
}

local function OnHaunt(inst, doer)
    if not (doer and doer:IsValid() and doer:HasTag("playerghost") and doer.userid == inst._owner_userid) then
        return false
    end

    local x, y, z = inst.Transform:GetWorldPosition()
    if TheWorld.Map:IsInvalidTileAtPoint(x, y, z) then
        return false
    end

    SpawnAt("spider_mutate_fx", inst)
    SpawnAt("statue_transition_2", inst)
    doer.Physics:Teleport(x, y, z)
    doer:PushEvent("respawnfromghost", { source = inst })
    doer:DoTaskInTime(0.1, function()
        if doer:IsValid() and doer.components.health ~= nil and not doer.components.health:IsDead() then
            doer.components.health:SetVal(math.min(50, doer.components.health.maxhealth))
        end
        if doer.components.hunger ~= nil then
            doer.components.hunger:SetPercent(2 / 3)
        end
        if doer.components.sanity ~= nil then
            doer.components.sanity:SetPercent(0.5)
        end
    end)

    inst:Remove()
    return true
end

local function OnDeath(inst)
    if inst._owner_userid ~= nil then
        for _, player in ipairs(AllPlayers) do
            if player.userid == inst._owner_userid then
                if player.components.talker ~= nil then
                    player.components.talker:Say(STRINGS.ANNOUNCE_CLONE_KILLED or "……分体，被毁了。")
                end
                break
            end
        end
    end
end

local function OnSave(inst, data)
    data.owner_userid = inst._owner_userid
    data.owner_name = inst._owner_name
end

local function OnLoad(inst, data)
    if data ~= nil then
        inst._owner_userid = data.owner_userid
        inst._owner_name = data.owner_name
        if inst._owner_userid ~= nil then
            for _, player in ipairs(AllPlayers) do
                if player.userid == inst._owner_userid then
                    if inst.components.maprevealer ~= nil then
                        inst.components.maprevealer:SetPrivateOwner(player)
                        inst.components.maprevealer:Start()
                    end
                    if inst.components.maprevealable ~= nil then
                        inst.components.maprevealable:AddPrivateSource(player)
                    end
                    break
                end
            end
        end
    end
end

local function SetOwner(inst, owner)
    inst._owner_userid = owner.userid
    inst._owner_name = owner.name
    if inst.components.maprevealer ~= nil then
        inst.components.maprevealer:SetPrivateOwner(owner)
        inst.components.maprevealer:Start()
    end
    if inst.components.maprevealable ~= nil then
        inst.components.maprevealable:AddPrivateSource(owner)
    end
end

local function CanActivate(inst, doer)
    if doer == nil or doer.userid ~= inst._owner_userid then
        return false, "NOTMINE"
    end
    return true
end

local function OnActivate(inst, doer)
    if doer ~= nil and doer.userid == inst._owner_userid then
        if doer.components.inventory ~= nil then
            doer.components.inventory:GiveItem(SpawnPrefab("shiro_clone_item"))
        end
        inst:Remove()
        return true
    end
    return false
end

local function clone_fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()
    inst.entity:AddMiniMapEntity()

    MakeCharacterPhysics(inst, 10, .5)

    inst.AnimState:SetBank("spider")
    inst.AnimState:SetBuild("spider_build")
    inst.AnimState:PlayAnimation("idle", true)
    inst.AnimState:SetScale(0.55, 0.55, 0.55)
    inst.AnimState:SetMultColour(1, 1, 1, 1)

    inst.MiniMapEntity:SetIcon("spiderden_1.png")

    inst:AddTag("shiro_clone")
    inst:AddTag("companion")
    inst:AddTag("resurrector")
    inst:AddTag("spider")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("health")
    inst.components.health:SetMaxHealth(50)

    inst:AddComponent("combat")

    inst:AddComponent("inspectable")

    inst:AddComponent("maprevealer")
    inst:AddComponent("maprevealable")
    inst.components.maprevealable:SetIcon("spiderden_1.png")

    inst:AddComponent("hauntable")
    inst.components.hauntable:SetHauntValue(TUNING.HAUNT_INSTANT_REZ)
    inst.components.hauntable:SetOnHauntFn(OnHaunt)

    inst:AddComponent("activatable")
    inst.components.activatable.CanActivateFn = CanActivate
    inst.components.activatable.OnActivate = OnActivate
    inst.components.activatable.quickaction = true
    inst.GetActivateVerb = function(self, doer)
        return "RETRIEVE"
    end

    inst:ListenForEvent("death", OnDeath)

    inst:ListenForEvent("ms_playerjoined", function(_, player)
        if player and player.userid == inst._owner_userid then
            if inst.components.maprevealer ~= nil then
                inst.components.maprevealer:SetPrivateOwner(player)
                inst.components.maprevealer:Start()
            end
            if inst.components.maprevealable ~= nil then
                inst.components.maprevealable:AddPrivateSource(player)
            end
        end
    end, TheWorld)

    inst:ListenForEvent("ms_playerleft", function(_, player)
        if player and player.userid == inst._owner_userid then
            if inst.components.maprevealer ~= nil then
                inst.components.maprevealer:Stop()
            end
            if inst.components.maprevealable ~= nil then
                inst.components.maprevealable:RemovePrivateSource(player)
            end
        end
    end, TheWorld)

    inst.SetOwner = SetOwner
    inst.OnSave = OnSave
    inst.OnLoad = OnLoad

    TheWorld.shiro_clones = TheWorld.shiro_clones or {}
    table.insert(TheWorld.shiro_clones, inst)

    inst:ListenForEvent("onremove", function()
        if TheWorld.shiro_clones ~= nil then
            table.removearrayvalue(TheWorld.shiro_clones, inst)
        end
    end)

    return inst
end

----------------------------------------------------------------------------------------
-- Inventory Item Version (随身分体)
----------------------------------------------------------------------------------------

local function OnDeploy(inst, pt, deployer)
    TheWorld.shiro_clones = TheWorld.shiro_clones or {}
    local count = 0
    for i = #TheWorld.shiro_clones, 1, -1 do
        local c = TheWorld.shiro_clones[i]
        if c:IsValid() and c.components.health and not c.components.health:IsDead() then
            if c._owner_userid == deployer.userid then
                count = count + 1
            end
        else
            table.remove(TheWorld.shiro_clones, i)
        end
    end

    if count >= 3 then
        if deployer.components.talker ~= nil then
            deployer.components.talker:Say(STRINGS.ANNOUNCE_CLONE_LIMIT or "……分体数量，已达上限。")
        end
        return false
    end

    local clone = SpawnPrefab("shiro_clone")
    if clone ~= nil then
        clone.Transform:SetPosition(pt:Get())
        clone:SetOwner(deployer)
        inst:Remove()
        return true
    end
    return false
end

local function item_fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("spider")
    inst.AnimState:SetBuild("spider_build")
    inst.AnimState:PlayAnimation("idle", true)
    inst.AnimState:SetScale(0.4, 0.4, 0.4)
    inst.AnimState:SetMultColour(1, 1, 1, 1)

    MakeInventoryFloatable(inst, "small", 0.1)

    inst:AddTag("shiro_clone_item")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inspectable")
    inst:AddComponent("inventoryitem")

    inst:AddComponent("deployable")
    inst.components.deployable.ondeploy = OnDeploy
    inst.components.deployable:SetDeployMode(DEPLOYMODE.DEFAULT)

    return inst
end

return Prefab("shiro_clone", clone_fn, assets, prefabs),
    Prefab("shiro_clone_item", item_fn, assets)
