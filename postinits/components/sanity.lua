local Sanity = require "components/sanity"

UTIL.FnExtend(Sanity, "_ctor", nil, function(rets, self, inst)
    self.sanity_penalty_vals = {}
end)

local BEYOND_SANITY_MIDDLE_PERCENT = .55
local BEYOND_SANITY_LOSS_PER_SPAWN = 50

KMDS.BeyondSanity = KMDS.BeyondSanity or {
    shadow_query_depth = 0,
    moon_query_depth = 0,
}
local BeyondSanity = KMDS.BeyondSanity

---@param self component_sanity
---@return boolean
local function IsBeyondSanity(self)
    return self.inst ~= nil and self.inst:HasTag("beyond_sanity")
end

---@param self component_sanity
local function FlushPendingShadowSpawns(self)
    local pending = self._beyond_sanity_pending_spawns or 0
    if pending <= 0 then return end

    local spawner = TheWorld ~= nil and TheWorld.components.shadowcreaturespawner or nil
    if spawner == nil then return end

    while self._beyond_sanity_pending_spawns > 0 do
        self._beyond_sanity_force_low_percent = true
        local ok, err = pcall(spawner.SpawnShadowCreature, spawner, self.inst)
        self._beyond_sanity_force_low_percent = nil
        if not ok then
            print("[KMDS] beyond_sanity shadow spawn failed:", err)
            return
        end
        self._beyond_sanity_pending_spawns = self._beyond_sanity_pending_spawns - 1
    end
end

---@param self component_sanity
---@param delta number
local function AccumulateSanityLoss(self, delta)
    if delta >= 0 then return end

    local loss = (self._beyond_sanity_loss or 0) - delta
    local spawn_count = math.floor(loss / BEYOND_SANITY_LOSS_PER_SPAWN)
    self._beyond_sanity_loss = loss - spawn_count * BEYOND_SANITY_LOSS_PER_SPAWN
    self._beyond_sanity_pending_spawns = (self._beyond_sanity_pending_spawns or 0) + spawn_count
end

UTIL.FnExtend(Sanity, "_ctor", nil, function(rets, self)
    self._beyond_sanity_loss = 0
    self._beyond_sanity_pending_spawns = 0
    return rets
end)

UTIL.FnExtend(Sanity, "DoDelta",
    function(self, delta, overtime)
        if not IsBeyondSanity(self) or self.redirect ~= nil or self.ignore then return end

        if type(delta) == "number" then
            AccumulateSanityLoss(self, delta)
        end

        local middle = self:GetMaxWithPenalty() * BEYOND_SANITY_MIDDLE_PERCENT
        return nil, nil, { self, middle - self.current, overtime }
    end,
    function(rets, self)
        if IsBeyondSanity(self) then
            -- Keep the underlying percentage state sane; induced insanity/lunacy
            -- is still resolved by the original public query methods below.
            self.sane = true
            FlushPendingShadowSpawns(self)
        end
        return rets
    end)

UTIL.FnExtend(Sanity, "IsSane", function(self)
    if not IsBeyondSanity(self) then return end

    if self.mode == SANITY_MODE_INSANITY then
        return { not self.inducedinsanity or self.inducedlunacy or false }, true
    end
    return { not self.inducedlunacy or self.inducedinsanity or false }, true
end)

UTIL.FnExtend(Sanity, "IsInsane", function(self)
    if IsBeyondSanity(self) then
        return { self.mode == SANITY_MODE_INSANITY and self.inducedinsanity and not self.inducedlunacy or false }, true
    end
end)

UTIL.FnExtend(Sanity, "IsEnlightened", function(self)
    if IsBeyondSanity(self) then
        return { self.mode == SANITY_MODE_LUNACY and self.inducedlunacy and not self.inducedinsanity or false }, true
    end
end)

UTIL.FnExtend(Sanity, "IsCrazy", function(self)
    if BeyondSanity.shadow_query_depth > 0 and IsBeyondSanity(self) and not self.inducedlunacy then
        return { true }, true
    end
end)

UTIL.FnExtend(Sanity, "GetPercent", function(self)
    if self._beyond_sanity_force_low_percent then
        return { 0 }, true
    end
end)

UTIL.FnExtend(Sanity, "GetPercentWithPenalty", function(self)
    if BeyondSanity.moon_query_depth > 0 and IsBeyondSanity(self) and not self.inducedinsanity then
        return { 1 }, true
    end
end)

UTIL.FnExtend(Sanity, "OnSave", nil, function(rets, self)
    local data = rets ~= nil and rets[1] or {}
    if IsBeyondSanity(self) then
        data.kmds_beyond_sanity_loss = self._beyond_sanity_loss
        data.kmds_beyond_sanity_pending_spawns = self._beyond_sanity_pending_spawns
    end
    return { data }
end)

UTIL.FnExtend(Sanity, "OnLoad", nil, function(rets, self, data)
    if IsBeyondSanity(self) and data ~= nil then
        self._beyond_sanity_loss = data.kmds_beyond_sanity_loss or 0
        self._beyond_sanity_pending_spawns = data.kmds_beyond_sanity_pending_spawns or 0
        FlushPendingShadowSpawns(self)
    end
    return rets
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
