local skillhashes = {
    [hash("nightvision")] = "nightvision",
    [hash("skanda")] = "skanda",
}

AddModRPCHandler("kmds.skills", "skills.updating", function(player, skillhash, update)
    local skill = player.components[skillhashes[skillhash]]
    if skill == nil or type(skill.Enable) ~= "function" then return end
    player.components[skillhashes[skillhash]]:Enable(update)
end)
