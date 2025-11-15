local function RegisterSkillComponent(cmp)
    if package.loaded["components/" .. cmp] == nil then
        package.loaded["components/" .. cmp] = modrequire("skills/" .. cmp, GLOBAL)
    end
end
RegisterSkillComponent "nightvision"