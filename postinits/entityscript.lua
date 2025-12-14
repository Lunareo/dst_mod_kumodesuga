---@return boolean|nil # is dead
---@return boolean|nil # has health
---@nodiscard
---@diagnostic disable-next-line: inject-field
function EntityScript:IsDead()
    local health = self.components.health
    return self:IsValid() and (health ~= nil and (health:IsDead() or
                (health.currenthealth and health.minhealth and health.currenthealth <= health.minhealth)) or
            self:HasTag("playerghost")) or nil,
        self:HasTag("_health") or self:HasTag("__health")
end

---@return boolean|nil # is alive
---@return boolean|nil # has health
---@nodiscard
---@diagnostic disable-next-line: inject-field
function EntityScript:IsAlive()
    local rets = { self:IsDead() }
    rets[1] = rets[1] ~= nil and not rets[1]
    ---@diagnostic disable-next-line: redundant-return-value
    return unpack(rets)
end
