local MakePlayerCharactor = require "prefabs/player_common"

local avatar_name = "wrath"

local assets = {
    Asset("SCRIPT", "scripts/prefabs/player_common.lua"),
}

local prefabs = {}

local start_inv = {}
for k, v in pairs(TUNING.GAMEMODE_STARTING_ITEMS) do
    start_inv[string.lower(k)] = v[string.upper(avatar_name)]
end

prefabs = FlattenTree({ prefabs, start_inv }, true)

---@class avatar_wrath: ent

local common_postinit = function(inst) --// Prefab: Rath(Wrath)

end

local master_postinit = function(inst)
    inst.starting_inventory = start_inv[TheNet:GetServerGameMode()] or start_inv.default
    inst.soundsname = "wilson"

    inst.components.health:SetMaxHealth(TUNING[string.upper(avatar_name) .. "_HEALTH"] --[[@as number]])
    inst.components.hunger:SetMax(TUNING[string.upper(avatar_name) .. "_HUNGER"] --[[@as number]])
    inst.components.sanity:SetMax(TUNING[string.upper(avatar_name) .. "_SANITY"] --[[@as number]])
end

return MakePlayerCharactor(avatar_name, prefabs, assets, common_postinit, master_postinit)
