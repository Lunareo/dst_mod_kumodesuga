local MakePlayerCharactor = require "prefabs/player_common"
local SpellSetter = require "prefabs/spellsetter"

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
---@return boolean
local function HasSpaceMotor(inst)
    local skilltreeupdater = inst.components.skilltreeupdater
    if skilltreeupdater == nil then
        return false
    end
    if skilltreeupdater:IsActivated("spacemotor") then
        return true
    end
    return skilltreeupdater.HasSkillTag ~= nil and skilltreeupdater:HasSkillTag("spacemotor")
end

--- Transfer / far-transfer only while holding Alt (CONTROL_FORCE_INSPECT).
--- Server receives this via EncodeControlMods / DecodeControlMods on click RPC.
---@param inst avatar_shiro
---@return boolean
local function IsTransferModifierHeld(inst)
    local pc = inst.components.playercontroller
    return pc ~= nil and pc:IsControlPressed(CONTROL_FORCE_INSPECT)
end

--- Land / boat, or open ocean only with spacemotor.
---@param inst avatar_shiro
---@param pos Vector3
---@return boolean
local function CanTransferToPoint(inst, pos)
    if pos == nil then
        return false
    end
    local x, y, z = pos:Get()
    -- Open ocean (not land overhang, not a boat): require spacemotor.
    if TheWorld.Map:IsOceanAtPoint(x, y, z, false) then
        return HasSpaceMotor(inst)
    end
    -- Defensive: ocean tile, not passable, no boat platform.
    if TheWorld.Map:IsOceanTileAtPoint(x, y, z)
        and not TheWorld.Map:IsPassableAtPoint(x, y, z)
        and TheWorld.Map:GetPlatformAtPoint(x, z) == nil then
        return HasSpaceMotor(inst)
    end
    -- Land / visual overhang / boats.
    return TheWorld.Map:IsPassableAtPoint(x, y, z)
end

---@param inst avatar_shiro
local function GetPointSpecialActions(inst, pos, useitem, right)
    if not right or useitem ~= nil then
        return {}
    end

    -- Only show/allow transfer while Alt is held.
    if not IsTransferModifierHeld(inst) then
        return {}
    end

    local skilltreeupdater = inst.components.skilltreeupdater
    if skilltreeupdater == nil then
        return {}
    end

    -- Map screen: return map_only TRANSFER_MAP directly.
    -- Vanilla GetMapActions keeps checkingmapactions=true while also calling
    -- GetRightClickActions(player_pos). Always validate the *map cursor*
    -- (checkingmapactions_pos), not the player feet, so ocean targets without
    -- spacemotor never produce a map action that RemapMapAction would accept.
    -- Also hide when sanity cost cannot be afforded.
    if inst.checkingmapactions then
        local targetpos = inst.checkingmapactions_pos or pos
        local can_show = false
        if skilltreeupdater:IsActivated("spacemagic_3") then
            if KMDS and KMDS.CanShowTransferMap then
                can_show = KMDS.CanShowTransferMap(inst, targetpos)
            else
                can_show = CanTransferToPoint(inst, targetpos)
            end
        end
        if can_show then
            return { ACTIONS.TRANSFER_MAP }
        end
        return {}
    end

    -- Alt already held: allow TRANSFER even with aoetargeting weapons
    -- (hand cast is suppressed separately while Alt is held).
    if skilltreeupdater:IsActivated("spacemagic_2") and CanTransferToPoint(inst, pos) then
        -- Short transfer also needs sanity; hide when unaffordable.
        local afford = true
        if KMDS and KMDS.CanAffordSanityCost then
            afford = KMDS.CanAffordSanityCost(inst, 3)
        end
        if afford then
            return { ACTIONS.TRANSFER }
        end
    end
    return {}
end

---@param inst avatar_shiro
local function OnSetOwner(inst)
    if inst.components.playeractionpicker ~= nil then
        inst.components.playeractionpicker.pointspecialactionsfn = GetPointSpecialActions
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

    SpellSetter(inst)

    inst:ListenForEvent("setowner", OnSetOwner)
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
            if self._other_space ~= nil then
                self:AddChild(self._other_space)
                -- SaveRecord stores absolute world pos; as a child it must sit on the player
                -- or Container:OnUpdate IsNear checks (if skipautoclose is off) will fail.
                self._other_space.Transform:SetPosition(0, 0, 0)
                if self._other_space.components.container ~= nil then
                    self._other_space.components.container.skipautoclose = true
                end
            end
        end
        return OnLoad ~= nil and OnLoad(self, data, ...)
    end

    inst:ListenForEvent("startstarving", onstarve)
    inst:ListenForEvent("stopstarving", stopstarve)
end

return MakePlayerCharactor(avatar_name, prefabs, assets, common_postinit, master_postinit)
