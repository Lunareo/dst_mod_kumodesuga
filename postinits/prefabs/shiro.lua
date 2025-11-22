AddPrefabPostInit("shiro", function(inst)
    AddComponentProxy(inst, "AnimState")
    inst:AddComponent("magiccaster")
    if not TheWorld.ismastersim then return end
    inst:AddComponent("rusher")
end)