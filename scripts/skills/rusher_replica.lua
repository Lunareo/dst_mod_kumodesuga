---@class replica_components
---@field rusher replica_rusher

---@class replica_rusher: replica_base
---@field enabledshadow net_bool
local Rusher = Class(function(self, inst, root)
    self.inst = inst
    self.root = root
    self.name = "rusher"
    self.enabledshadow = net_bool(inst.GUID, "skill.rusher.enabledshadow", "skill.rusher.enabledshadowdirty")
    self.enabledshadow:set(false)
    if not TheNet:IsDedicated() then
        self.inst:ListenForEvent("skill.rusher.enabledshadowdirty", function() self:EnableShadow(self.enabledshadow:value()) end)
    end
end)

function Rusher:Enable(enable)
    self.enabledshadow:set(enable)
end

function Rusher:EnableShadow(enable)
    if enable then
        self.inst:StartUpdatingComponent(self)
    else
        self.inst:StopUpdatingComponent(self)
    end
end

function Rusher:OnUpdate(dt)
    ---@class echo_shadow_fx_client: ent
    local fx = SpawnPrefab("echo_shadow_fx_client")
    fx:AttachFXOwner(self.inst)
end

return Rusher