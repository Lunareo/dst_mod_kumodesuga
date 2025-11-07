local Sanity = require "components/sanity"

UTIL.FnExtend(Sanity, "_ctor", nil, function(rets, self, inst)
    self.sanity_penalty_vals = {}
end)

UTIL.FnExtend(Sanity, "RecalculatePenalty", nil, function(rets, self)
    local penalty_val = 0
    for _, v in pairs(self.sanity_penalty_vals) do
        penalty_val = penalty_val + v
    end
    local penalty = penalty_val / self.max
    self.penalty = math.min(self.penalty + penalty, 1 - (5 / self.max))
    self:DoDelta(0)
    return rets
end)

function Sanity:AddSanityPenaltyVal(key, mod)
    self.sanity_penalty_vals[key] = mod
    self:RecalculatePenalty()
end

function Sanity:RemoveSanityPenaltyVal(key)
    self.sanity_penalty_vals[key] = nil
    self:RecalculatePenalty()
end
