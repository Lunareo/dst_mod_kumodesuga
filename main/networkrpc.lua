AddModRPCHandler("kmds.skills", "nightvision.update", function(player)
    if player.components.nightvision == nil then return end
    player.components.nightvision:ToggleUpdate()
end)