local Skills, Replicas = {}, {}

local function LoadSkill(name, self)
    if Skills[name] == nil then
        Skills[name] = require("skills/" .. name)
        assert(Skills[name], "could not load skill " .. name)
        Skills[name].WatchWorldState = self.WatchWorldState
        Skills[name].StopWatchingWorldState = self.StopWatchingWorldState
    end
    return Skills[name]
end

local replica_mt =
{
    __index = function(t, k)
        return rawget(t, "inst"):ValidateReplicaSkill(k, rawget(t, "_")[k])
    end,
}

---@class components
---@field skillscript component_skillscript

---@class playerskill
---@field OnSave fun(skill:playerskill, data:table):(table)|nil
---@field OnLoad fun(skill:playerskill, data:table):(nil)|nil

---@class component_skillscript
---@field inst ent
---@field skills table<string, playerskill>
---@field replica table<string, playerskill>
local SkillScript = Class(function(self, inst)
    self.inst = inst
    self.skills = {}
    self.replica = { _ = {}, component = self }
    setmetatable(self.replica, replica_mt)
end)

function SkillScript:AddSkill(name)
    local lwr_name = string.lower(name)
    if self.skills[lwr_name] ~= nil then
        print("Skill " .. name .. " already exists on entity " .. tostring(self.inst) .. "!")
        return self.skills[lwr_name]
    end
    local skill = LoadSkill(name, self)
    if not skill then
        error("Skill " .. name .. " does not exist!")
    end

    local loadedskill = skill(self.inst, self)
    self.skills[lwr_name] = loadedskill

    --TODO: Skill postinits

    return loadedskill
end

function SkillScript:RemoveSkill(name)

end

function SkillScript:GetSkill(name)
    return self.skills[name]
end

function SkillScript:OnSave(data)
    for k, v in pairs(self.skills) do
        if v.OnSave then
            data[k] = v:OnSave(data)
        end
    end
    return data
end

function SkillScript:ValidateReplicaSkill(name, skill)
    return self.inst:HasTag("_skill." .. name) and skill or nil
end

return SkillScript
