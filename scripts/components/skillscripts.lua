local Skills = {}

local function LoadSkill(name)
    if Skills[name] ~= nil then
        Skills[name] = require("skills/" .. name)
        assert(Skills[name], "could not load skill " .. name)
    end
    return Skills[name]
end

---@class components
---@field skillscripts component_skillscripts

---@class playerskill
---@field OnSave fun(skill:playerskill, data:table):(table)|nil
---@field OnLoad fun(skill:playerskill, data:table):(nil)|nil

---@class component_skillscripts
---@field inst ent
---@field skills table<string, playerskill>
local SkillScripts = Class(function(self, inst)
    self.inst = inst
    self.skills = {}
end)

function SkillScripts:AddSkill(name)
    local lwr_name = string.lower(name)
    if self.skills[lwr_name] ~= nil then
        print("Skill " .. name .. " already exists on entity " .. tostring(self.inst) .. "!")
        return self.skills[lwr_name]
    end
    local skill = LoadSkill(name)
    if not skill then
        error("Skill " .. name .. " does not exist!")
    end

    self:ReplicateSkill(name)

    local loadedskill = skill(self.inst, self)
    self.skills[lwr_name] = loadedskill

    --TODO: Skill postinits

    return loadedskill
end

function SkillScripts:ReplicateSkill(name)
end

function SkillScripts:GetSkill(name)
    return self.skills[name]
end

function SkillScripts:OnSave(data)
    for k, v in pairs(self.skills) do
        if v.OnSave then
            data[k] = v:OnSave(data)
        end
    end
    return data
end

return SkillScripts
