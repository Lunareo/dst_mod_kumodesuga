---@meta

---@class component_base
---@field inst ent
local Base = {}

---@param var string
---@param fn fun(inst: ent, ...):any
function Base:WatchWorldState(var, fn) end

---@param var string
---@param fn fun(inst: ent, ...):any
function Base:StopWatchingWorldState(var, fn) end
