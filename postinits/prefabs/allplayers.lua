AddReplicableComponent("satura")
AddReplicableComponent("scorebase")
AddReplicableComponent("stamina")
AddReplicableComponent("accela")

hookimport "components/hunger"
hookimport "prefabs/player_classified"
hookimport "widgets/statusdisplays"

AddComponentPostInit("hunger", function(self)
    self.inst:AddComponent("satura")
end)
