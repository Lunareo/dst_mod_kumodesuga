local function ToggleNightVision(player)
    if player.components.nightvision ~= nil then
        player.components.nightvision:ToggleUpdate()
    end
end

AddModRPCHandler("Kmds_spells", "togglenightvision", ToggleNightVision)