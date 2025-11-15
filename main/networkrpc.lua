local function ToggleNightVision(player)
    if player.components.nightvision ~= nil then
        player.components.nightvision:ToggleUpdate()
    end
end

AddModRPCHandler("kmds.skills", "nightvision.update", ToggleNightVision)

AddModRPCHandler("kmds.skills", "storingspace.toggle", UTIL.VoidFn)