local Combat = require "ariel_combat"
local HasSkill = Combat.HasSkill
local M = {}

local function Nearest(doer, pos, test)
    local best, distance
    for _, target in ipairs(TheSim:FindEntities(pos.x, 0, pos.z, 2, nil, { "INLIMBO" })) do
        local d = target:GetDistanceSqToPoint(pos)
        if test(target) and (distance == nil or d < distance) then best, distance = target, d end
    end
    return best
end

M.dash = function(doer, pos)
    local pool, cfg = doer.components.arielgluttony, TUNING.ARIEL
    local range = cfg.dash_range + (HasSkill(doer, "dash") and 2 or 0)
    if not pool:IsReady("dash_cd") or pool.current < cfg.dash_cost
        or doer.components.inventory:IsHeavyLifting() then return false end
    local origin = doer:GetPosition()
    if not Combat.StepToward(doer, pos, range) then return false end
    pool:Cost(cfg.dash_cost)
    pool.timers.dash_cd = cfg.dash_cooldown
    local dest = doer:GetPosition()
    local delta = dest - origin
    local length = delta:Length()
    local axis = delta / length
    for _, target in ipairs(Combat.Enemies(doer, origin, length + 2)) do
        local offset = target:GetPosition() - origin
        local along = offset.x * axis.x + offset.z * axis.z
        local across = math.abs(offset.x * axis.z - offset.z * axis.x)
        if along >= 0 and along <= length + 1 and across <= 1.5 then Combat.Knockback(doer, target) end
    end
    return true
end

M.gate = function(doer, pos)
    local pool, cfg = doer.components.arielgluttony, TUNING.ARIEL
    local wear = cfg.gate_wear * (HasSkill(doer, "temperance") and .8 or 1)
    local radius = cfg.gate_radius + (HasSkill(doer, "abyss") and 1 or 0)
    if not pool:IsReady("gate_cd") or pool.current < cfg.gate_cost or not pool:CanWear(wear)
        or #Combat.Enemies(doer, pos, radius) == 0 then return false end
    local gate = SpawnPrefab("ariel_gate")
    if gate == nil then return false end
    gate.Transform:SetPosition(pos:Get())
    gate.caster = doer
    gate.radius = radius
    gate.damage = cfg.gate_damage * (doer.components.combat.damagemultiplier or 1)
        * doer.components.combat.externaldamagemultipliers:Get() * (HasSkill(doer, "abyss") and 1.2 or 1)
    gate.execute_percent = cfg.execute_percent + (HasSkill(doer, "sovereign") and .1 or 0)
    local removegate = function() gate:Remove() end
    gate:ListenForEvent("death", removegate, doer)
    gate:ListenForEvent("onremove", removegate, doer)
    pool:Cost(cfg.gate_cost)
    pool:AddWear(wear)
    pool.timers.gate_cd = cfg.gate_cooldown
    return true
end

M.humility = function(doer) return doer.components.arielgluttony:StartHumility() end
M.follow = function(doer) return doer.components.arielcommander:SetGuard(nil) end
M.guard = function(doer, pos) return doer.components.arielcommander:SetGuard(pos) end
M.focus = function(doer, pos)
    local target = Nearest(doer, pos, function(ent) return Combat.IsEnemy(doer, ent) end)
    return target ~= nil and doer.components.arielcommander:Focus(target)
end
M.devour = function(doer, pos)
    local pool = doer.components.arielgluttony
    local target = Nearest(doer, pos, function(ent) return pool:CanDevour(ent) end)
    return target ~= nil and pool:Devour(target)
end

M.massage = function(doer, pos)
    local pool, cfg = doer.components.arielgluttony, TUNING.ARIEL
    local target = Nearest(doer, pos, function(ent)
        return ent ~= doer and ent:HasTag("player") and Combat.IsAlive(ent) and doer:IsNear(ent, 3)
    end)
    if target == nil or not pool:IsReady("massage_cd") or not pool:Cost(cfg.massage_cost) then return false end
    pool.timers.massage_cd = cfg.massage_cooldown
    if target.components.freezable ~= nil then target.components.freezable:Unfreeze() end
    if target.components.debuffable ~= nil then
        target.components.debuffable:RemoveDebuff("drunken")
        target.components.debuffable:RemoveDebuff("hangover")
    end
    if target.components.moisture ~= nil then target.components.moisture:DoDelta(-30) end
    if target.components.temperature ~= nil and target.components.temperature:GetCurrent() < 10 then
        target.components.temperature:SetTemperature(10)
    end
    target.components.sanity:DoDelta(cfg.massage_sanity)
    target.components.hunger:DoDelta(cfg.massage_hunger)
    return true
end

M.joke = function(doer)
    local pool, cfg = doer.components.arielgluttony, TUNING.ARIEL
    if not pool:IsReady("joke_cd") then return false end
    pool.timers.joke_cd = cfg.joke_cooldown
    doer.components.talker:Say(STRINGS.CHARACTERS.ARIEL.ANNOUNCE_ARIEL_JOKE)
    local listeners, replies = {}, {}
    for _, player in ipairs(AllPlayers) do
        if player ~= doer and Combat.IsAlive(player) and doer:IsNear(player, 8) then
            listeners[#listeners + 1] = player
            local reply = function() replies[player] = true end
            player:ListenForEvent("emote", reply)
            replies[#replies + 1] = { player, reply }
        end
    end
    local cleaned = false
    local function cleanup()
        if cleaned then return end
        cleaned = true
        for _, pair in ipairs(replies) do
            pair[1]:RemoveEventCallback("emote", pair[2])
        end
    end
    doer:ListenForEvent("onremove", cleanup)
    doer:DoTaskInTime(cfg.joke_delay, function()
        cleanup()
        doer:RemoveEventCallback("onremove", cleanup)
        for _, player in ipairs(listeners) do if replies[player] then return end end
        if not Combat.IsAlive(doer) then return end
        local nearby = false
        for _, player in ipairs(listeners) do
            if Combat.IsAlive(player) and doer:IsNear(player, 8) then
                nearby = true
                player.components.sanity:DoDelta(-cfg.joke_sanity)
            end
        end
        if nearby then doer.components.sanity:DoDelta(-cfg.joke_sanity) end
    end)
    return true
end

for kind = 1, 4 do
    local slot = kind
    M["puppet_" .. kind] = function(doer) return doer.components.arielcommander:Summon(slot) end
end

function M.Cast(doer, name, pos)
    if not Combat.IsAlive(doer) or doer.components.arielgluttony == nil
        or doer.components.rider:IsRiding() or type(name) ~= "string"
        or name == "Cast" or type(M[name]) ~= "function" or pos == nil
        or type(pos.x) ~= "number" or type(pos.z) ~= "number"
        or pos.x ~= pos.x or pos.z ~= pos.z then return false end
    pos = Vector3(pos.x, 0, pos.z)
    if doer.components.arielgluttony:IsExhausted() and name ~= "devour" then return false end
    local range = (name == "devour" or name == "massage") and 3 or TUNING.ARIEL.gate_range
    if doer:GetDistanceSqToPoint(pos) > range * range then return false end
    if (name == "gate" or name == "guard") and not Combat.CanStand(pos) then return false end
    return M[name](doer, pos)
end

return M
