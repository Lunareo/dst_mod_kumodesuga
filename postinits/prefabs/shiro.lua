AddPrefabPostInit("shiro", function(inst)
    inst:AddComponent("magiccaster")
    if not TheWorld.ismastersim then return end
    inst:AddComponent("rusher")
end)