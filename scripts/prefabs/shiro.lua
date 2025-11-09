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

local function onnightvisiondirty(inst, ...)
    local isnightvision = inst.nightvision and inst.nightvision:value()
    inst.components.playervision:ForceNightVision(isnightvision)
    if isnightvision then
        inst.components.playervision:PushForcedNightVision("shiro_spells", 10, NIGHTVISION_COLOURCUBES, true)
    else
        inst.components.playervision:PopForcedNightVision("shiro_spells")
    end
end

local common_postinit = function(inst)
    inst.nightvision = net_bool(inst.GUID, "kmds.nightvision", "kmds.nightvisiondirty")
    inst:ListenForEvent("kmds.nightvisiondirty", onnightvisiondirty)

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

    local IsInLight = inst.IsInLight
    function inst:IsInLight()
        return IsInLight(self) or self.nightvision and self.nightvision:value()
    end

    inst.MiniMapEntity:SetIcon(avatar_name .. ".tex")
end

local master_postinit = function(inst)
    inst.starting_inventory = start_inv[TheNet:GetServerGameMode()] or start_inv.default
    table.insert(inst.starting_inventory, "shiro_spells")
    inst.soundsname = "wendy"

    inst.components.eater:SetStrongStomach(true)
    inst.components.eater:SetCanEatRawMeat(true)
    inst.components.eater:SetIgnoresSpoilage(true)

    inst.components.foodaffinity:AddPrefabAffinity("kurikuta_dried", TUNING.AFFINITY_15_CALORIES_MED)

    inst.components.health:SetMaxHealth(TUNING[string.upper(avatar_name) .. "_HEALTH"])
    inst.components.hunger:SetMax(TUNING[string.upper(avatar_name) .. "_HUNGER"])
    inst.components.sanity:SetMax(TUNING[string.upper(avatar_name) .. "_SANITY"])

    inst.components.locomotor:SetTriggersCreep(false)

end

return MakePlayerCharactor(avatar_name, prefabs, assets, common_postinit, master_postinit)
