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

local common_postinit = function(inst)
    inst:AddTag(avatar_name)
    inst:AddTag("spiderdisguise")
    inst:AddTag("D_spirit")

    inst:AddComponent("spelluser")

    local RemoveTag = inst.RemoveTag
    function inst:RemoveTag(tag)
        if tag == "spiderdisguise" then return end
        RemoveTag(self, tag)
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

    inst:DoTaskInTime(0, function()
        if inst.components.inventory:GetEquippedItem(EQUIPSLOTS.BEARD) == nil then
            inst.components.inventory:Equip(SpawnPrefab("shiro_spells"))
        end
    end)
end

return MakePlayerCharactor(avatar_name, prefabs, assets, common_postinit, master_postinit)
