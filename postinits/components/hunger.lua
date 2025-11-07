local Hunger = require "components/hunger"

local HEALING_MODIFIER = .5
UTIL.FnExtend(Hunger, "DoDelta",
    function(self, delta, ...)
        local satura = self.inst and self.inst.components.satura
        if satura then
            if delta < 0 and satura:IsSaturated() then
                local new_delta = math.clamp(delta, -satura.current, 0)
                satura:DoDelta(new_delta)
                return nil, false, { self, new_delta == delta and 0 or delta - new_delta, ... }
            elseif delta > 0 then
                local new_delta = math.max(0, delta - self.max + self.current)
                satura:DoDelta(new_delta)
                return
            end
        end
    end)
UTIL.FnExtend(Hunger, "DoDec",
    nil,
    function(rets, self, dt)
        local satura = self.inst and self.inst.components.satura
        if satura and satura:IsSaturated() then
            self.inst.components.health:DoDelta(
                self.hungerrate * dt * self.burnrate * self.burnratemodifiers:Get() * HEALING_MODIFIER, true,
                "saturation")
        end
        return rets
    end)
