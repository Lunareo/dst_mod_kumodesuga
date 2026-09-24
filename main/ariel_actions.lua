local Combat = require "ariel_combat"

local ACTION_RECRUIT = AddAction(
    "ARIEL_RECRUIT",
    STRINGS.ACTIONS.ARIEL_RECRUIT,
    function(act)
        local doer, target = act.doer, act.target
        if doer == nil or doer.components.arielcommander == nil or target == nil then return false end
        return doer.components.arielcommander:Recruit(target)
    end
)
ACTION_RECRUIT.priority = 4
ACTION_RECRUIT.rmb = true
ACTION_RECRUIT.distance = 4
ACTION_RECRUIT.mount_valid = false

local handler = ActionHandler(ACTION_RECRUIT, "doshortaction")
AddStategraphActionHandler("wilson", handler)
AddStategraphActionHandler("wilson_client", handler)

AddComponentAction("SCENE", "combat", function(inst, doer, actions, right)
    if not right or doer == nil or doer.prefab ~= "ariel" or inst == doer then return end
    if not (inst:HasTag("spider") or inst:HasTag("spiderqueen")) then return end
    if inst:HasTag("playerghost") or inst:HasTag("companion") then return end
    local follower = inst.replica ~= nil and inst.replica.follower or nil
    if follower ~= nil and follower:GetLeader() ~= nil then return end
    table.insert(actions, ACTIONS.ARIEL_RECRUIT)
end)

AddPrefabPostInit("spider", function(inst)
    if not TheWorld.ismastersim then return end
    local retarget = inst.components.combat ~= nil and inst.components.combat.targetfn or nil
    if retarget == nil then return end
    inst.components.combat:SetRetargetFunction(inst.components.combat.retargetperiod or 3, function(spider)
        local target = retarget(spider)
        if target ~= nil and target:HasTag("ariel") and not target:HasTag("playerghost") then return nil end
        return target
    end)
end)
