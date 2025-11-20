local skillhashes = {
    [hash("nightvision")] = "nightvision",
    [hash("rusher")] = "rusher",
}

AddModRPCHandler("kmds.skills", "skills.updating", function(player, skillhash, update)
    local skill = player.components[skillhashes[skillhash]]
    if skill == nil or type(skill.Enable) ~= "function" then return end
    player.components[skillhashes[skillhash]]:Enable(update)
end)
