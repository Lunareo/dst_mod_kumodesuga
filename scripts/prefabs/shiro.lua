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

local skilldefs = require "prefabs/skilltree_defs"
local BuildSkillsData = require "prefabs/skilltree_shiro"
local skill_data = BuildSkillsData(skilldefs.FN)
skilldefs.CreateSkillTreeFor(avatar_name, skill_data.SKILLS)
skilldefs.SKILLTREE_ORDERS[avatar_name] = skill_data.ORDERS
skilldefs.SKILLTREE_METAINFO[avatar_name].BACKGROUND_SETTINGS = skill_data.BACKGROUND_SETTINGS
skilldefs.CUSTOM_FUNCTIONS[avatar_name] = skill_data.CUSTOM_FUNCTIONS

---@class avatar_shiro: ent
---@field _other_space ent|nil
---@field _other_space_data table|nil
---@field enabledshadow net_bool

local function hide_backpack(inst)
    inst.AnimState:SetSymbolExchange("hair", "swap_body")
end

---@param inst avatar_shiro
local function SpawnSkandaFX(inst)
    ---@class echo_shadow_fx_client: ent
    local fx = SpawnPrefab("echo_shadow_fx_client")
    fx:AttachFXOwner(inst)
end

---@param inst avatar_shiro
local function OnEnabledShadowDirty(inst)
    if inst.enabledshadow and inst.enabledshadow:value() then
        if not inst.components.updatelooper then
            inst:AddComponent("updatelooper")
        end
        inst.components.updatelooper:AddOnUpdateFn(SpawnSkandaFX)
    elseif inst.components.updatelooper then
        inst.components.updatelooper:RemoveOnUpdateFn(SpawnSkandaFX)
    end
end

---@param inst avatar_shiro
---@param food ent
---@param feeder ent
local function oneat(inst, food, feeder)
    local fooddisplayname = food and food:GetBasicDisplayName() or nil
    if fooddisplayname ~= nil then
        for _, word in ipairs(TUNING.DRUNK_KEYS) do
            if string.find(fooddisplayname, word) then
                inst:AddDebuff("drunken", "buff_drunken")
            end
        end
    end
end

local function onstarve(inst)
    inst:AddTag("groggy")
    inst.components.locomotor:SetExternalSpeedMultiplier(inst, "onstarving", TUNING.SHIRO_HUNGERY_SPEED_MULT)
end

local function stopstarve(inst)
    if not (inst.components.grogginess and inst.components.grogginess:IsGroggy()) then
        inst:RemoveTag("groggy")
    end
    inst.components.locomotor:RemoveExternalSpeedMultiplier(inst, "onstarving")
end

---@param inst avatar_shiro
local common_postinit = function(inst)
    inst.AnimState:SetHatOffset(2, 27)

    inst.enabledshadow = net_bool(inst.GUID, "skill.skanda.enabledshadow", "skill.skanda.enabledshadowdirty")
    inst.enabledshadow:set(false)

    inst:DoTaskInTime(0, hide_backpack)
    inst:AddTag(avatar_name)
    inst:AddTag("spiderdisguise")
    inst:AddTag("D_spirit")

    inst:AddComponent("nightvision")

    if not TheNet:IsDedicated() then
        inst:ListenForEvent("skill.skanda.enabledshadowdirty", OnEnabledShadowDirty)
    end

    local RemoveTag = inst.RemoveTag
    function inst:RemoveTag(tag)
        if tag == "spiderdisguise" then return end
        RemoveTag(self, tag)
    end

    inst.MiniMapEntity:SetIcon(avatar_name .. ".tex")
end

---@param inst avatar_shiro
local master_postinit = function(inst)
    inst.starting_inventory = start_inv[TheNet:GetServerGameMode()] or start_inv.default
    inst.soundsname = "wendy"

    inst.components.eater:SetStrongStomach(true)
    inst.components.eater:SetCanEatRawMeat(true)
    inst.components.eater:SetIgnoresSpoilage(true)
    inst.components.eater:SetOnEatFn(oneat)

    inst.components.foodaffinity:AddPrefabAffinity("kurikuta_dried", TUNING.AFFINITY_15_CALORIES_MED)

    inst.components.health:SetMaxHealth(TUNING[string.upper(avatar_name) .. "_HEALTH"] --[[@as number]])
    inst.components.hunger:SetMax(TUNING[string.upper(avatar_name) .. "_HUNGER"] --[[@as number]])
    inst.components.sanity:SetMax(TUNING[string.upper(avatar_name) .. "_SANITY"] --[[@as number]])

    inst.components.locomotor:SetTriggersCreep(false)

    inst.components.slipperyfeet.StartSlipperySource = function() end

    local OnDespawn = inst.OnDespawn
    function inst:OnDespawn(migrationdata, ...)
        if self._other_space ~= nil then
            self._other_space_data = self._other_space:GetSaveRecord()
            self:RemoveChild(self._other_space)
            self._other_space.persists = false
            self._other_space:Remove()
            self._other_space = nil
        end
        return OnDespawn ~= nil and OnDespawn(self, migrationdata, ...)
    end

    local OnSave = inst.OnSave
    function inst:OnSave(data, ...)
        if self._other_space ~= nil then
            self._other_space_data = self._other_space:GetSaveRecord()
            self._other_space.persists = false
        end
        data._other_space, self._other_space_data = self._other_space_data, nil
        return OnSave ~= nil and OnSave(self, data, ...)
    end

    local OnLoad = inst.OnLoad
    function inst:OnLoad(data, ...)
        if data._other_space and not self._other_space then
            self._other_space = SpawnSaveRecord(data._other_space)
            self:AddChild(self._other_space)
        end
        return OnLoad ~= nil and OnLoad(self, data, ...)
    end

    inst:ListenForEvent("startstarving", onstarve)
    inst:ListenForEvent("stopstarving", stopstarve)
end

return MakePlayerCharactor(avatar_name, prefabs, assets, common_postinit, master_postinit)
