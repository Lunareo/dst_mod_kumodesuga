TheInput:AddKeyDownHandler(GLOBAL[GetModConfigData("parrykey", true) or "KEY_R"], function()
    local screen = TheFrontEnd and TheFrontEnd:GetActiveScreen()
    if screen and screen.name == "HUD" and ThePlayer and ThePlayer:HasTag("parryable") then
        local ppos = ThePlayer:GetPosition()
        local hands = ThePlayer.replica.inventory and ThePlayer.replica.inventory:GetEquippedItem(EQUIPSLOTS.HANDS) or nil
        local target = hands and hands.components.aoetargeting and ThePlayer or nil
        if TUNING.DSA_ONE_PLAYER_MODE then
            local act = BufferedAction(ThePlayer, target, ACTIONS.PARRY, nil, ppos, nil, nil, nil, nil, nil)
            local playercontroller = ThePlayer.components.playercontroller
            if playercontroller ~= nil then
                playercontroller:DoAction(act)
            end
        else
            SendRPCToServer(RPC.RightClick, ACTIONS.PARRY.code, ppos.x, ppos.z, target, nil, nil, nil, nil,
                ACTIONS.PARRY.mod_name, nil, false)
        end
    end
end)

TheInput:AddControlHandler(CONTROL_CHARACTER_COMMAND_WHEEL, function (down)
    if not down and ThePlayer and ThePlayer.HUD then
        ThePlayer.HUD:CloseSpellWheel()
    end
end)