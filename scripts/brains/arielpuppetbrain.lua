require "behaviours/follow"
require "behaviours/wander"
require "behaviours/chaseandattack"
require "behaviours/leash"
local Combat = require "ariel_combat"

local PuppetBrain = Class(Brain, function(self, inst) Brain._ctor(self, inst) end)
local function Leader(inst)
    return inst.components.follower ~= nil and inst.components.follower:GetLeader() or nil
end
local function Home(inst)
    return inst._ariel_guard or (Leader(inst) ~= nil and Leader(inst):GetPosition() or inst:GetPosition())
end

function PuppetBrain:OnStart()
    self.bt = BT(self.inst, PriorityNode({
        Leash(self.inst, function() return Home(self.inst) end, 25, 12),
        ChaseAndAttack(self.inst, 10, 20),
        IfNode(function() return self.inst._ariel_guard == nil and Leader(self.inst) ~= nil end, "follow owner",
            Follow(self.inst, Leader, 2, 4, 7)),
        Wander(self.inst, function() return Home(self.inst) end, 5),
    }, .5))
end

return PuppetBrain
