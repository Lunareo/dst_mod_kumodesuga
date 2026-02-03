---@meta

---@class skill_def
---@field title string|nil -- Can't be nil
---@field desc string|nil -- Can't be nil
---@field icon string|nil -- skill_node_only
---@field pos number[]
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

---@alias componentID_mod string
---| "abyssdamage" # 外道伤害
---| "abyssdefense" # 外道防御
---| "erosiondamage" # 腐蚀伤害
---| "erosiondefense" # 腐蚀防御
---| "magiccaster" # 魔术师
---| "nightvision" # 夜视
---| "parryable" # 闪避
---| "satura" # 饱和
---| "skanda" # 韦陀天

---@alias tagID_mod string
---| "__storing_space" # 未持有空间存储
---| "_storing_space" # 持有空间存储
---| "D_spirit" # 若叶姬色与白织公用标签
---| "lighterweapon" # 若叶姬色使用不衰减倍率的武器
---| "shiro" # 白织
---| "wakaba" # 若叶姬色

---@alias PrefabID_mod string
---| "aramasa" 天羽羽斩
---| "buff_curse"
---| "buff_erosion"
---| "buff_freeze"
---| "buff_health_penalty_reduction" # 腐蚀再生
---| "buff_mighty_strike"
---| "helheim_beyonder"
---| "shiro"
---| "silk_robe"
---| "spiderscythe"
---| "storing_space_dtor"
---| "storing_space"
---| "wakaba"
---| "echo_shadow_fx_client"
---| "bloom_fx_client"

---@alias eventID_mod string

---@class Entity: ent_sys
Entity = {}