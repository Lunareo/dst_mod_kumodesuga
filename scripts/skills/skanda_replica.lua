---@class replica_components
---@field skanda replica_skanda

---@class replica_skanda: replica_base
---@field enabledshadow net_bool
local Skanda = Class(function(self, inst, root)
    self.inst = inst
    self.root = root
    self.name = "skanda"
    self.enabledshadow = net_bool(inst.GUID, "skill.skanda.enabledshadow", "skill.skanda.enabledshadowdirty")
    self.enabledshadow:set(false)
    if not TheNet:IsDedicated() then
        self.inst:ListenForEvent("skill.skanda.enabledshadowdirty", function() self:EnableShadow(self.enabledshadow:value()) end)
    end
end)

function Skanda:Enable(enable)
    self.enabledshadow:set(enable)
end

function Skanda:EnableShadow(enable)
    if enable then
        self.inst:StartUpdatingComponent(self)
    else
        self.inst:StopUpdatingComponent(self)
    end
end

function Skanda:OnUpdate(dt)
    ---@class echo_shadow_fx_client: ent
    local fx = SpawnPrefab("echo_shadow_fx_client")
    fx:AttachFXOwner(self.inst)
end

return Skanda