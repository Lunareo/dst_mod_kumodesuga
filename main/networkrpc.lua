local skillhashes = {
    [hash("nightvision")] = "nightvision",
    [hash("skanda")] = "skanda",
}

AddModRPCHandler("kmds.skills", "skills.updating", function(player, skillhash, update)
    if player == nil or player.components == nil then return end
    local skillname = skillhashes[skillhash]
    if skillname == nil then return end
    local skill = player.components[skillname]
    if skill == nil or type(skill.Enable) ~= "function" then return end
    skill:Enable(update)
end)

AddModRPCHandler("kmds.spells", "spells.open_space_proxy", function(player)
    local skilltreeupdater = player and player.components and player.components.skilltreeupdater
    if player and player.space_proxy == nil and skilltreeupdater and skilltreeupdater:IsActivated("spacemagic_1") then
        local offset = FindWalkableOffset(player:GetPosition(), math.random() * PI2, .5, nil, nil, nil, nil, nil, true)
        if offset ~= nil then
            local pos = player:GetPosition() + offset
            local proxy = SpawnAt("space_proxy", pos) ---@class prefab_space_proxy
            if proxy ~= nil then
                proxy:AttachOwner(player)
                if proxy.components.container_proxy ~= nil then
                    proxy.components.container_proxy:Open(player)
                end
            end
        end
    end
end)
