---@class components
---@field parryable component_parryable
---@class component_parryable

local Parryable = Class(function(self, inst)
    self.inst = inst

    self.time = 0
    self.delta = FRAMES * 10
    self.cooldown = 0

    inst:AddTag("parryable")
end)

function Parryable:Parry()
    self.time = GetTime()
    self.enabled = true
end

function Parryable:GetAttacked(attacker, damage, weapon, stimuli, spdamage, ...)
    if GetTime() - self.time <= self.delta and stimuli ~= "darkness" then
        if self.enabled then
            self.inst.sg:GoToState("knockbacklanded", { knocker = attacker, radius = .5, strengthmult = 2 })
            if attacker.sg then
                attacker.sg:GoToState("knockback", { knocker = self.inst, radius = .5, strengthmult = 2 })
            end
            self.enabled = nil
        end
        --attacker.components.combat:GetAttacked(attacker, damage, weapon, stimuli, spdamage, ...)
        return true
    end
    return false
end

return Parryable