AddReplicableComponent("satura")
AddReplicableComponent("scorebase")
AddReplicableComponent("stamina")
AddReplicableComponent("accela")

hookimport "components/hunger"
hookimport "prefabs/player_classified"
hookimport "widgets/statusdisplays"

AddPlayerPostInitByComponent("builder", function(inst)
    inst:AddComponent("satura")
end)
