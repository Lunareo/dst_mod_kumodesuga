local M = {}

function M.HasSkill(inst, name)
    local skills = inst.components.skilltreeupdater
    return skills ~= nil and skills:IsActivated("ariel_" .. name)
end

function M.IsAlive(inst)
    return inst ~= nil and inst:IsValid() and not inst:IsInLimbo()
        and not inst:HasTag("playerghost") and inst.components.health ~= nil
        and not inst.components.health:IsDead()
end

-- 玩家、玩家所有的宠物和中立伴侣不进入伤害/吞噬候选集，包括其他爱丽儿的蛛群。
function M.IsEnemy(owner, target)
    if target == owner or not M.IsAlive(target) or target.components.combat == nil
        or target:HasTag("player") or target:HasTag("companion")
        or target:HasTag("wall") or target:HasTag("structure")
        or target:HasTag("notarget") or target:HasTag("noattack") then return false end
    local follower = target.components.follower
    local leader = follower ~= nil and follower:GetLeader() or nil
    if leader ~= nil and leader:HasTag("player") then return false end
    local combat = owner.components.combat
    return combat == nil or not combat:IsAlly(target)
end

function M.Enemies(owner, pos, radius)
    local result = {}
    for _, target in ipairs(TheSim:FindEntities(pos.x, 0, pos.z, radius, { "_combat" }, { "INLIMBO" })) do
        if M.IsEnemy(owner, target) then result[#result + 1] = target end
    end
    return result
end

function M.IsBoss(target)
    return target:HasTag("epic") or target:HasTag("boss") or target:HasTag("largecreature")
        or target.components.planarentity ~= nil
end

function M.CanStand(pos)
    return TheWorld.Map:IsPassableAtPoint(pos.x, 0, pos.z)
        and not TheWorld.Map:IsGroundTargetBlocked(pos)
        and not TheWorld.Map:IsPointNearHole(pos)
end

function M.Knockback(owner, target, strength)
    if not M.IsBoss(target) then
        target:PushEvent("knockback", { knocker = owner, radius = 2, strengthmult = strength or .5 })
    end
end

-- 沿可行走路径推进，不把战斗突进变成跨海/穿墙传送。
function M.StepToward(inst, pos, distance)
    local origin = inst:GetPosition()
    local delta = pos - origin
    local length = delta:Length()
    if length <= .01 then return false end
    local direction = delta / length
    local dest = origin
    for d = .25, math.min(distance, length), .25 do
        local point = origin + direction * d
        if not M.CanStand(point) then break end
        dest = point
    end
    if (dest - origin):LengthSq() < .01 then return false end
    inst.Physics:Teleport(dest:Get())
    return true
end

return M
