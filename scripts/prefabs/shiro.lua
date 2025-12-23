local MakePlayerCharactor = require "prefabs/player_common"

local avatar_name = "shiro"

local assets = {
    Asset("DYNAMIC_ANIM", "anim/dynamic/shiro.zip"),
    Asset("PKGREF", "anim/dynamic/shiro.dyn"),
    Asset("SCRIPT", "scripts/prefabs/player_common.lua"),
    Asset("SCRIPT", "scripts/prefabs/skilltree_shiro.lua"),
}

local prefabs = {
    "shiro_spells",
}

local start_inv = {}
for k, v in pairs(TUNING.GAMEMODE_STARTING_ITEMS) do
    start_inv[string.lower(k)] = v[string.upper(avatar_name)]
end

prefabs = FlattenTree({ prefabs, start_inv }, true)

--[[
local skilldefs = require "prefabs/skilltree_defs"
local BuildSkillsData = require "prefabs/skilltree_shiro"
local skill_data = BuildSkillsData(skilldefs.FN)
skilldefs.CreateSkillTreeFor(avatar_name, skill_data.SKILLS)
skilldefs.SKILLTREE_ORDERS[avatar_name] = skill_data.ORDERS
skilldefs.SKILLTREE_METAINFO[avatar_name].BACKGROUND_SETTINGS = skill_data.BACKGROUND_SETTINGS
skilldefs.CUSTOM_FUNCTIONS[avatar_name] = skill_data.CUSTOM_FUNCTIONS
]]

local function hide_backpack(inst)
    inst.AnimState:SetSymbolExchange("hair", "swap_body")
end

local common_postinit = function(inst)
    inst:DoTaskInTime(0, hide_backpack)
    inst:AddTag(avatar_name)
    inst:AddTag("spiderdisguise")
    inst:AddTag("D_spirit")

    inst:AddComponent("nightvision")

    local RemoveTag = inst.RemoveTag
    function inst:RemoveTag(tag)
        if tag == "spiderdisguise" then return end
        RemoveTag(self, tag)
    end

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
end

return MakePlayerCharactor(avatar_name, prefabs, assets, common_postinit, master_postinit)
