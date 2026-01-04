AddPrefabPostInit("stella", function(inst)
    --if inst.components["stella_steal"] ~= nil then
    --    inst:RemoveComponent("stella_steal")
    --end
    if TUNING.MOD_STELLA and TUNING.MOD_STELLA.steal ~= nil then
        TUNING.MOD_STELLA.steal = "stella" -- force lvl dn
    end
end)
