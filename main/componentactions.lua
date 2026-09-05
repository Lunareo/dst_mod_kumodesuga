AddComponentAction("SCENE", "parryable", function(inst, doer, actions, right)
    local inventory = inst == doer and right and inst.replica and inst.replica.inventory or nil
    local hands = inventory and inventory:GetEquippedItem(EQUIPSLOTS.HANDS) or nil
    if hands and hands.components.aoetargeting then
        table.insert(actions, ACTIONS.PARRY)
    end
end)

AddComponentAction("USEITEM", "inventoryitem", function(inst, doer, target, actions, right)
    if doer.components.skilltreeupdater:IsActivated("shiro_evolution_arachne")
        and inst:HasTag("reweaver") and target.replica.godspunable
        and target.replica.godspunable._upgraded
        and target.replica.godspunable._upgraded:value() ~= true then
            table.insert(actions, ACTIONS.WEAVE)
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
