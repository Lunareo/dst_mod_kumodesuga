AddComponentAction("SCENE", "parryable", function(inst, doer, actions, right)
    local hands = inst == doer and right and inst.replica.inventory:GetEquippedItem(EQUIPSLOTS.HANDS) or nil
    if hands and hands.components.aoetargeting then
        table.insert(actions, ACTIONS.PARRY)
    end
end)

--AddComponentAction("SCENE", "skilltreeupdater", function (inst, doer, actions, right)
--    if right and inst == doer and
--    inst.components.skilltreeupdater:IsActivated("spacemagic_3") and
--        inst:CanSeePointOnMiniMap(pos:Get()) and
--        TheWorld.Map:IsAboveGroundAtPoint(pos:Get()) then
--        rets[2] = BufferedAction(self.inst, nil, ACTIONS.TRANSFER_MAP, nil, pos)
--    end
--end)

--AddComponentAction("POINT", "skilltreeupdater", function(inst, doer, pos, actions, right, target)
--    if right and not target and inst == doer and
--        inst.components.skilltreeupdater:IsActivated("spacemagic_3") and
--        inst:CanSeePointOnMiniMap(pos:Get()) and
--        TheWorld.Map:IsAboveGroundAtPoint(pos:Get()) then
--        table.insert(actions, ACTIONS.TRANSFER_MAP)
--    end
--end)
