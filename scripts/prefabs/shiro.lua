local MakePlayerCharactor = require "prefabs/player_common"

local avatar_name = "shiro"

local assets = {
    Asset("SCRIPT", "scripts/prefabs/player_common.lua"),
    Asset("ANIM", "anim/" .. avatar_name .. ".zip"),
    Asset("ANIM", "anim/ghost_" .. avatar_name .. "_build.zip"),
}

local prefabs = {
    "shiro_spells",
}

local start_inv = {}
for k, v in pairs(TUNING.GAMEMODE_STARTING_ITEMS) do
    start_inv[string.lower(k)] = v[string.upper(avatar_name)]
end

prefabs = FlattenTree({ prefabs, start_inv }, true)

local NIGHTVISION_COLOURCUBES =
{
    day = "images/colour_cubes/mole_vision_off_cc.tex",
    dusk = "images/colour_cubes/mole_vision_on_cc.tex",
    night = "images/colour_cubes/mole_vision_on_cc.tex",
    full_moon = "images/colour_cubes/mole_vision_off_cc.tex",
}

local SPELLBOOK_RADIUS = 120

local Spells = require "defs/allspells"
local SHIRO_SPELLS = {
    Spells.ToggleNightVision,
}

local function nightvision_onworldstateupdate(inst)
    inst:SetForcedNightVision(TheWorld.state.isnight and not TheWorld.state.isfullmoon)
end

local function nightvision_activate(inst)
    if inst._toggle_nightvision:value() and TheWorld ~= nil and inst.SetForcedNightVision ~= nil then
        if TheWorld:HasTag("cave") then
            inst:SetForcedNightVision(true)
        else
            inst:WatchWorldState("isnight", nightvision_onworldstateupdate)
            inst:WatchWorldState("isfullmoon", nightvision_onworldstateupdate)
            nightvision_onworldstateupdate(inst)
        end
    end
end

local function nightvision_deactivate(inst)
    if not inst._toggle_nightvision:value() and TheWorld ~= nil and inst.SetForcedNightVision ~= nil then
        if TheWorld:HasTag("cave") then
            inst:SetForcedNightVision(false)
        else
            inst:StopWatchingWorldState("isnight", nightvision_onworldstateupdate)
            inst:StopWatchingWorldState("isfullmoon", nightvision_onworldstateupdate)
            inst:SetForcedNightVision(false)
        end
    end
end

local function OnToggleNightVisionDirty(inst)
    if inst._toggle_nightvision:value() then
        nightvision_activate(inst)
    else
        nightvision_deactivate(inst)
    end
end

local function OnForcedNightVisionDirty(inst)
    if inst.components.playervision ~= nil then
        if inst._forced_nightvision:value() then
            inst.components.playervision:PushForcedNightVision(inst)
        else
            inst.components.playervision:PopForcedNightVision(inst)
        end
    end
end

local NIGHTVISION_GRUEIMMUNITY_NAME = "shiroskills_nightvision"
local function SetForcedNightVision(inst, nightvision_on)
    inst._forced_nightvision:set(nightvision_on)

    if inst.components.playervision ~= nil then
        if nightvision_on then
            inst.components.playervision:PushForcedNightVision(inst)
        else
            inst.components.playervision:PopForcedNightVision(inst)
        end
    end

    -- The nightvision event might get consumed during save/loading,
    -- so push an extra custom immunity into the table.
    if nightvision_on then
        inst.components.grue:AddImmunity(NIGHTVISION_GRUEIMMUNITY_NAME)
    else
        inst.components.grue:RemoveImmunity(NIGHTVISION_GRUEIMMUNITY_NAME)
    end
end

local common_postinit = function(inst)
    inst._toggle_nightvision = net_bool(inst.GUID, "shiroskills._toggle_nightvision", "shiroskills._toggle_nightvisiondirty")
    inst._forced_nightvision = net_bool(inst.GUID, "shiroskills._forced_nightvision", "shiroskills._forced_nightvisiondirty")
    inst:ListenForEvent("shiroskills._forced_nightvisiondirty", OnForcedNightVisionDirty)

    inst:AddTag(avatar_name)
    inst:AddTag("spiderdisguise")
    inst:AddTag("D_spirit")

    local spellbook = inst:AddComponent("spellbook")
    spellbook:SetRadius(SPELLBOOK_RADIUS)
    spellbook:SetFocusRadius(SPELLBOOK_RADIUS) --UIAnimButton don't use focus radius SPELLBOOK_FOCUS_RADIUS)
    spellbook:SetItems(SHIRO_SPELLS)

    local RemoveTag = inst.RemoveTag
    function inst:RemoveTag(tag)
        if tag == "spiderdisguise" then return end
        RemoveTag(self, tag)
    end

    --local IsInLight = inst.IsInLight
    --function inst:IsInLight()
    --    return IsInLight(self) or self._forced_nightvision and self._forced_nightvision:value()
    --end

    inst.MiniMapEntity:SetIcon(avatar_name .. ".tex")
end

local master_postinit = function(inst)
    inst.starting_inventory = start_inv[TheNet:GetServerGameMode()] or start_inv.default
    inst.soundsname = "wendy"

    inst.components.eater:SetStrongStomach(true)
    inst.components.eater:SetCanEatRawMeat(true)
    inst.components.eater:SetIgnoresSpoilage(true)

    inst.components.foodaffinity:AddPrefabAffinity("kurikuta_dried", TUNING.AFFINITY_15_CALORIES_MED)

    inst.components.health:SetMaxHealth(TUNING[string.upper(avatar_name) .. "_HEALTH"])
    inst.components.hunger:SetMax(TUNING[string.upper(avatar_name) .. "_HUNGER"])
    inst.components.sanity:SetMax(TUNING[string.upper(avatar_name) .. "_SANITY"])

    inst.components.locomotor:SetTriggersCreep(false)

    inst.SetForcedNightVision = SetForcedNightVision

    inst:ListenForEvent("shiroskills._toggle_nightvisiondirty", OnToggleNightVisionDirty)
end

return MakePlayerCharactor(avatar_name, prefabs, assets, common_postinit, master_postinit)
