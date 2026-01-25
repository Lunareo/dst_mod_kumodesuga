TheInput:AddKeyDownHandler(GLOBAL[GetModConfigData("parrykey", true)], function()
    if TheFrontEnd:GetActiveScreen() and TheFrontEnd:GetActiveScreen().name == "HUD" and ThePlayer:HasTag("parryable") then
        local ppos = ThePlayer:GetPosition()
        local hands = ThePlayer.replica.inventory and ThePlayer.replica.inventory:GetEquippedItem(EQUIPSLOTS.HANDS) or nil
        local target = hands and hands.components.aoetargeting and ThePlayer or nil
        if TUNING.DSA_ONE_PLAYER_MODE then
            local act = BufferedAction(ThePlayer, target, ACTIONS.PARRY, nil, ppos, nil, nil, nil, nil, nil)
            ThePlayer.components.playercontroller:DoAction(act)
        else
            SendRPCToServer(RPC.RightClick, ACTIONS.PARRY.code, ppos.x, ppos.z, target, nil, nil, nil, nil,
                ACTIONS.PARRY.mod_name, nil, false)
        end
    end
end)