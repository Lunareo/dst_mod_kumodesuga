---@author: Runar
---@class components
---@field nightvision component_nightvision

---@class component_nightvision: component_base
---@field root table # component_skillscript
---@field activate netvar # net_bool
---@field update netvar # net_bool
local NightVision = Class(function(self, inst, root)
    self.inst = inst
    self.root = root
    self.name = "nightvision"
    self.activate = net_bool(self.inst.GUID, "skills.nightvision.activate", "skills.nightvision.activatedirty")
    self.update = net_bool(self.inst.GUID, "skills.nightvision.update", "skills.nightvision.updatedirty")
    self.inst:ListenForEvent("skills.nightvision.activatedirty", function() self:_OnActivateDirty() end)
    if TheWorld.ismastersim then
        self.inst:ListenForEvent("skills.nightvision.updatedirty", function() self:_OnUpdateDirty() end)
    end
end, nil, {})

function NightVision:ToggleUpdate(update)
    self.update:set(update or not self.update:value())
end

function NightVision:OnRemoveFromEntity()
    self:ToggleUpdate(false)
end

local function nightvision_onworldstateupdate(self)
    self:_SetForceNightVision(TheWorld.state.isnight and not TheWorld.state.isfullmoon)
end

function NightVision:_Activate()
    if self.update:value() and TheWorld ~= nil then
        if TheWorld:HasTag("cave") then
            self:_SetForceNightVision(true)
        else
            self:WatchWorldState("isnight", nightvision_onworldstateupdate)
            self:WatchWorldState("isfullmoon", nightvision_onworldstateupdate)
            nightvision_onworldstateupdate(self)
        end
    end
end

function NightVision:_Deactivate()
    if not self.update:value() and TheWorld ~= nil then
        if TheWorld:HasTag("cave") then
            self:_SetForceNightVision(false)
        else
            self:StopWatchingWorldState("isnight", nightvision_onworldstateupdate)
            self:StopWatchingWorldState("isfullmoon", nightvision_onworldstateupdate)
            self:_SetForceNightVision(false)
        end
    end
end

function NightVision:_OnUpdateDirty()
    if self.update:value() then
        self:_Activate()
    else
        self:_Deactivate()
    end
end

function NightVision:_OnActivateDirty()
    local inst = self.inst
    if inst.components.playervision ~= nil then
        if self.activate:value() then
            inst.components.playervision:PushForcedNightVision(inst)
        else
            inst.components.playervision:PopForcedNightVision(inst)
        end
    end
end

local NIGHTVISION_GRUEIMMUNITY_NAME = "skills.nightvision"
function NightVision:_SetForceNightVision(on)
    local inst = self.inst
    self.activate:set(on)

    if inst.components.playervision ~= nil then
        if on then
            inst.components.playervision:PushForcedNightVision(inst)
        else
            inst.components.playervision:PopForcedNightVision(inst)
        end
    end

    -- The nightvision event might get consumed during save/loading,
    -- so push an extra custom immunity into the table.
    if on then
        inst.components.grue:AddImmunity(NIGHTVISION_GRUEIMMUNITY_NAME)
    else
        inst.components.grue:RemoveImmunity(NIGHTVISION_GRUEIMMUNITY_NAME)
    end
end

function NightVision:OnSave(data)
    return self.update:value() and {
        update = true,
    } or nil
end

function NightVision:OnLoad(data)
    if data and data.update then
        self:ToggleUpdate(true)
    end
end

return NightVision
