---@meta

---@class skill_def
---@field title string|nil -- Can't be nil
---@field desc string|nil -- Can't be nil
---@field icon string|nil -- skill_node_only
---@field pos table<integer, integer>
---@field group string
---@field tags string[]|nil -- skill_node_only
---@field root boolean|nil
---@field lock_open fun(prefabname:string, activatedskills:string[], readonly:boolean|nil):(boolean)|nil
---@field onactivate fun(inst:ent, fromload:boolean|nil)|nil
---@field ondeactivate fun(inst:ent, fromload:boolean|nil)|nil
---@field connects string[]|nil
---@field defaultfocus boolean|nil

---@class SkillTreeFns
---@field CountSkills fun(prefabname:string, activatedskills:string[]):integer
---@field HasTag fun(prefab:string, targettag:string, activatedskills:string[]):boolean
---@field CountTags  fun(prefab:string, targettag:string, activatedskills):integer
---@field SkillHasTags  fun(skill, tag:string, prefabname:string):boolean
---@field MakeFuelWeaverLock  fun(extra_data, not_root):skill_def
---@field MakeNoShadowLock  fun(extra_data:table, not_root:(boolean|nil)):skill_def
---@field MakeCelestialChampionLock  fun(extra_data:table, not_root:(boolean|nil)):skill_def
---@field MakeNoLunarLock  fun(extra_data:table, not_root:(boolean|nil)):skill_def
---@field MakePurelyVisualLock  fun(skills, locknametoreplicate, locknamesuffix):skill_def




