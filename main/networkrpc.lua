local skillhashes = {
    [hash("nightvision")] = "nightvision",
    [hash("skanda")] = "skanda",
}

AddModRPCHandler("kmds.skills", "skills.updating", function(player, skillhash, update)
    local skill = player.components[skillhashes[skillhash]]
    if skill == nil or type(skill.Enable) ~= "function" then return end
    player.components[skillhashes[skillhash]]:Enable(update)
end)

AddModRPCHandler("kmds.spells", "spells.open_space_proxy", function(player)
    if player and player.space_proxy == nil and player.components.skilltreeupdater:IsActivated("spacemagic_1") then
        local pos = player:GetPosition() + FindWalkableOffset(player:GetPosition(), math.random() * PI2, .5, nil, nil, nil, nil, nil, true)
        if pos ~= nil then
            local proxy = SpawnAt("space_proxy", pos) ---@class prefab_space_proxy
            if proxy ~= nil then
                proxy:AttachOwner(player)
                proxy.components.container_proxy:Open(player)
            end
        end
    end
end)
