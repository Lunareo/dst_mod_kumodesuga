local function ToggleNightVision(player)
    if player.nightvision ~= nil then
        player.nightvision:set(not player.nightvision:value())
    end
end

AddModRPCHandler("Kmds_spells", "togglenightvision", ToggleNightVision)