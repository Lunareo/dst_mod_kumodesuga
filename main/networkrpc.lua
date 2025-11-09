local function ToggleNightVision(player)
    if player._toggle_nightvision ~= nil then
        player._toggle_nightvision:set(not player._toggle_nightvision:value())
    end
end

AddModRPCHandler("Kmds_spells", "togglenightvision", ToggleNightVision)