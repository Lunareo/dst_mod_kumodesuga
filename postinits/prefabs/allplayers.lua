AddReplicableComponent("satura")
AddReplicableComponent("scorebase")
AddReplicableComponent("stamina")
AddReplicableComponent("accela")
AddReplicableComponent("magicpoint")
AddReplicableComponent("godspunable")

hookimport "components/hunger"
hookimport "prefabs/player_classified"
hookimport "widgets/statusdisplays"

AddPlayerPostInit_Soft(nil, function(inst)
    inst:AddComponent("satura")
end)
