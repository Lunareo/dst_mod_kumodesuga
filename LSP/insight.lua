---@meta

---@class Insight_context
---@field priority integer
---@field description string
---@field worldly boolean|nil
---@field icon {atlas:string, tex:string}|nil

---@class Insight_descriptors
---@field Describe fun(self:table, player_context:table):Insight_context

---@class Insight_prefab_descriptors
---@field Describe fun(inst:ent, player_context:table):Insight_context

---@class Insight
---@field descriptors table<componentID, Insight_descriptors>
---@field prefab_descriptors table<PrefabID, Insight_prefab_descriptors>
Insight = {
    descriptors = {},
    prefab_descriptors = {},
}
