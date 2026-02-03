local function RegisterSkillComponent(cmp)
    if package.preload["components/" .. cmp] == nil then
        package.preload["components/" .. cmp] = modrequire("skills/" .. cmp, GLOBAL)
    end
    if package.loaded["components/" .. cmp] == nil then
        package.loaded["components/" .. cmp] = modrequire("skills/" .. cmp, GLOBAL)
    end
end
RegisterSkillComponent "nightvision"
RegisterSkillComponent "skanda"
RegisterSkillComponent "skanda_replica"

AddReplicableComponent "skanda"