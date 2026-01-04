AddSimPostInit(function()
    if type(TUNING.NDNR_NOT_PARASITEPLAYERS) == "table" then
        table.insert(TUNING.NDNR_NOT_PARASITEPLAYERS, "shiro")
    end
    if type(TUNING.NDNR_NOT_BEEPOISONPLAYERS) == "table" then
        table.insert(TUNING.NDNR_NOT_BEEPOISONPLAYERS, "shiro")
    end
    if type(TUNING.NDNR_NOT_GOUT_PLAYER) == "table" then
        table.insert(TUNING.NDNR_NOT_GOUT_PLAYER, "shiro")
    end
    if type(TUNING.NDNR_NO_EMOSTATUS_PLAYER) == "table" then
        table.insert(TUNING.NDNR_NO_EMOSTATUS_PLAYER, "shiro")
        table.insert(TUNING.NDNR_NO_EMOSTATUS_PLAYER, "wakaba")
    end
end)
AddPrefabPostInit("shiro", function(inst)
    if not TheWorld.ismastersim then
        return
    end
    inst:DoTaskInTime(0, function(this)
        if this["ndnr_parasite"] then
            this["ndnr_parasite"] = false
        end
    end)
end)
