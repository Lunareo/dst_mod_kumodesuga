local Combat = require "ariel_combat"
local Abilities = require "ariel_abilities"

local function IsAriel(doer)
    return doer ~= nil and doer:HasTag("ariel") and not doer:HasTag("playerghost")
        and not (doer.replica.rider ~= nil and doer.replica.rider:IsRiding())
end

local definitions = {
    ARIEL_RECRUIT = { distance = 4, fn = function(act)
        return act.doer.components.arielcommander:Recruit(act.target)
    end },
    ARIEL_DEVOUR = { distance = 3, fn = function(act)
        return act.doer.components.arielgluttony:Devour(act.target or act.invobject)
    end },
    ARIEL_MASSAGE = { distance = 3, fn = function(act)
        return Combat.IsAlive(act.target) and Abilities.Cast(act.doer, "massage", act.target:GetPosition())
    end },
    ARIEL_PACK = { distance = 3, fn = function(act)
        return act.doer.components.arielcommander:Pack(act.target)
    end },
}
for _, name in ipairs({ "ARIEL_RECRUIT", "ARIEL_DEVOUR", "ARIEL_MASSAGE", "ARIEL_PACK" }) do
    local def = definitions[name]
    local perform = def.fn
    local action = AddAction(name, STRINGS.ACTIONS[name], function(act)
        return IsAriel(act.doer) and Combat.IsAlive(act.doer) and perform(act)
    end)
    action.priority = 4
    action.rmb = true
    action.distance = def.distance
    action.mount_valid = false
    AddStategraphActionHandler("wilson", ActionHandler(action, "doshortaction"))
    AddStategraphActionHandler("wilson_client", ActionHandler(action, "doshortaction"))
end

AddComponentAction("SCENE", "combat", function(inst, doer, actions, right)
    if not right or not IsAriel(doer) or inst == doer or inst:HasTag("playerghost") then return end
    if inst:HasTag("player") then
        table.insert(actions, ACTIONS.ARIEL_MASSAGE)
        return
    end
    local follower = inst.replica.follower
    local leader = follower ~= nil and follower:GetLeader() or nil
    if inst:HasTag("ariel_puppet") then
        if leader == doer then table.insert(actions, ACTIONS.ARIEL_PACK) end
    elseif (inst:HasTag("spider") or inst:HasTag("spiderqueen")) and leader == nil then
        table.insert(actions, ACTIONS.ARIEL_RECRUIT)
    end
end)

local function CollectDevour(inst, doer, actions)
    if not IsAriel(doer) or inst:HasTag("irreplaceable") or inst:HasTag("companion")
        or inst:HasTag("smallcreature") or inst:HasTag("bundle") or inst:HasTag("_health") then return end
    if inst.replica.container ~= nil and not inst.replica.container:IsEmpty() then return end
    table.insert(actions, ACTIONS.ARIEL_DEVOUR)
end
AddComponentAction("INVENTORY", "inventoryitem", CollectDevour)
AddComponentAction("SCENE", "inventoryitem", function(inst, doer, actions, right)
    if right then CollectDevour(inst, doer, actions) end
end)
