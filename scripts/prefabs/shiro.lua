local MakePlayerCharactor = require "prefabs/player_common"
local SpellSetter = require "prefabs/spellsetter"
local SKILL_UTIL = require "prefabs/playerskillutil"
local avatar_name = "shiro"

local assets = {
    Asset("ANIM", "anim/shiro.zip"),
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
---@field checkingmapactions boolean|nil
---@field checkingmapactions_pos Vector3
---@field CreateMagicBadge boolean|nil

local function hide_backpack(inst)
    inst.AnimState:SetSymbolExchange("hair", "swap_body")
end

---@param inst avatar_shiro
---@return boolean|nil
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
---@return boolean|nil
local function IsTransferModifierHeld(inst)
    local pc = inst.components.playercontroller
    return pc ~= nil and pc:IsControlPressed(CONTROL_FORCE_INSPECT)
end

--- Land / boat, or open ocean only with spacemotor.
---@param inst avatar_shiro
---@param pos Vector3
---@return boolean|nil
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
    -- Also hide when the magic point cost cannot be afforded.
    if inst.checkingmapactions then
        local targetpos = inst.checkingmapactions_pos or pos
        local can_show = false ---@type boolean|nil
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
        -- Short transfer also needs magic points; hide when unaffordable.
        local afford = true
        if KMDS and KMDS.CanAffordMagicPointCost then
            afford = KMDS.CanAffordMagicPointCost(inst, 3)
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
    -- 睡眠免疫期间是醉不倒的（蘑菇料理给的 shroomsleepimmunity）。
    -- 这道关卡必须设在 AddDebuff 之前：buff 自己的 attach 里再拦就晚了，
    -- MakeBuff 的 OnAttached 会先把"喝醉了"那句台词播出去
    if inst.components.debuffable ~= nil and inst.components.debuffable:HasDebuff("shroomsleepimmunity") then
        return
    end

    local fooddisplayname = food and food:GetBasicDisplayName() or nil
    if fooddisplayname ~= nil then
        for _, word in ipairs(TUNING.DRUNK_KEYS) do
            if string.find(fooddisplayname, word) then
                inst:AddDebuff("drunken", "buff_drunken")
            end
        end
    end
end

local function CustomStatsModFn(inst, health_delta, hunger_delta, sanity_delta, food, feeder)
    if food ~= nil then
        if food.prefab == "spoiled_food" or food.prefab == "spoiled_fish"
            or food.prefab == "spoiled_fish_small" or food.prefab == "rottenegg" then
            return 0, 5, 0
        end
    end
    if health_delta < 0 then
        health_delta = 0
    end
    if sanity_delta < 0 then
        sanity_delta = 0
    end
    return health_delta, hunger_delta, sanity_delta
end
---@param inst avatar_shiro
---@return number
local function GetStarvingSanityRate(inst)
    local hunger = inst.components.hunger
    if hunger ~= nil and not hunger:IsPaused() and hunger:IsStarving() then
        -- Starvation affects sanity independently of hunger's health damage.
        return -TUNING.SHIRO_STARVING_SANITY_RATE
    end
    return 0
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

local function CleanupSpacemotor(inst)
    if inst.components.magicpoint ~= nil then
        inst.components.magicpoint:RemoveConsumptionSrc(inst, "spacemotor")
    end
end

local function UpdateSpacemotor(inst)
    if inst.components.health == nil or inst.components.health:IsDead() or inst:HasTag("playerghost") then
        return
    end

    local skilltreeupdater = inst.components.skilltreeupdater
    if skilltreeupdater == nil or not skilltreeupdater:IsActivated("spacemotor") then
        CleanupSpacemotor(inst)
        return
    end

    local is_on = SKILL_UTIL.IsActivate(inst, "spacemotor")
    if not is_on then
        CleanupSpacemotor(inst)
        return
    end

    if inst.components.magicpoint ~= nil and inst.components.magicpoint.current <= 0 then
        SKILL_UTIL.Toggle(inst, "spacemotor")
        CleanupSpacemotor(inst)
        return
    end

    local x, y, z = inst.Transform:GetWorldPosition()
    local has_ground = (inst:GetCurrentPlatform() ~= nil) or TheWorld.Map:IsVisualGroundAtPoint(x, y, z)

    if not has_ground then
        if inst.components.magicpoint ~= nil then
            inst.components.magicpoint:AddConsumptionSrc(inst, -1, "spacemotor")
        end
    else
        if inst.components.magicpoint ~= nil then
            inst.components.magicpoint:RemoveConsumptionSrc(inst, "spacemotor")
        end
    end
end
---@param inst avatar_shiro
local common_postinit = function(inst)
    inst.AnimState:SetHatOffset(2, 27)

    inst:DoTaskInTime(0, hide_backpack)
    inst:AddTag(avatar_name)
    inst:AddTag("spiderdisguise")
    inst:AddTag("D_spirit")
    inst.CreateMagicBadge = true

    inst:AddComponent("nightvision")

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
    inst.components.eater:SetCanEatHorrible()
    inst.components.eater:SetIgnoresSpoilage(true)
    inst.components.eater:SetOnEatFn(oneat)
    inst.components.eater.custom_stats_mod_fn = CustomStatsModFn

    inst.components.foodaffinity:AddPrefabAffinity("kurikuta_dried", TUNING.AFFINITY_15_CALORIES_MED)

    inst.components.health:SetMaxHealth(TUNING[string.upper(avatar_name) .. "_HEALTH"] --[[@as number]])
    inst.components.health.fire_damage_scale = 1.5

    local old_DoDelta = inst.components.health.DoDelta

    -- 死灭法杖演化：侵蚀类来源的伤害减免80%
    local function ApplyDeathScytheReduction(amount, cause)
        local updater = inst.components.skilltreeupdater
        if updater ~= nil and updater:IsActivated("shiro_evolution_death_scythe")
            and (cause == "acid" or cause == "acid_rain" or cause == "erosion" or cause == "buff_erosion") then
            amount = amount * 0.2
        end
        return amount
    end

    -- 忍耐：单次超过30点的直接伤害，70%转为6秒内（每0.5秒一次）平滑流失，返回立即生效的部分
    local function PatiSplitDamage(amount)
        if -amount <= 30 then
            return amount
        end
        local direct = amount * 0.3
        local ticks_left = 12
        local tick_dmg = -amount * 0.7 / ticks_left
        local task
        task = inst:DoPeriodicTask(0.5, function()
            if not (inst:IsValid() and not inst.components.health:IsDead()) then
                task:Cancel()
            else
                ticks_left = ticks_left - 1
                inst.components.health:DoDelta(-tick_dmg, true, "pati_delayed")
                if ticks_left <= 0 then
                    task:Cancel()
                end
            end
        end, 0.5)
        return direct
    end

    -- 忍耐：不足1血的伤害以1:1消耗MP抵消，MP不足时仍正常承受剩余伤害
    local function PatiMagicPointSave(amount)
        local magicpoint = inst.components.magicpoint
        local cur_hp = inst.components.health.currenthealth
        if cur_hp + amount < 1 and magicpoint ~= nil and magicpoint.current > 0 then
            local excess = 1 - (cur_hp + amount)
            local mp_spent = math.min(excess, magicpoint.current)
            magicpoint:Cost(mp_spent)
            amount = amount + mp_spent
        end
        return amount
    end

    function inst.components.health:DoDelta(amount, overtime, cause, ignore_invincible, afflicter, ignore_absorb)
        if amount ~= nil and amount < 0 then
            amount = ApplyDeathScytheReduction(amount, cause)
            local updater = inst.components.skilltreeupdater
            if updater ~= nil and updater:IsActivated("pati") then
                -- 延迟伤害只走保命，不重复拆分；其他持续伤害维持原有结算。
                if not overtime then
                    amount = PatiSplitDamage(amount)
                end
                if not overtime or cause == "pati_delayed" then
                    amount = PatiMagicPointSave(amount)
                end
            end
        end
        return old_DoDelta(self, amount, overtime, cause, ignore_invincible, afflicter, ignore_absorb)
    end
    inst.components.hunger:SetMax(TUNING[string.upper(avatar_name) .. "_HUNGER"] --[[@as number]])
    inst.components.sanity:SetMax(TUNING[string.upper(avatar_name) .. "_SANITY"] --[[@as number]])
    inst.components.sanity:SetNegativeAuraImmunity(true, inst)
    inst.components.sanity.custom_rate_fn = GetStarvingSanityRate

    inst:AddComponent("magicpoint")
    inst.components.magicpoint:SetMax(TUNING[string.upper(avatar_name) .. "_MAGICPOINT"] --[[@as number]])
    inst.components.magicpoint:SetCurrent(inst.components.magicpoint:GetMax())

    inst.components.locomotor:SetTriggersCreep(false)

    inst.components.slipperyfeet.StartSlipperySource = function() end

    if inst.components.talker ~= nil then
        local OldSay = inst.components.talker.Say
        function inst.components.talker:Say(script, time, noanim, force, nobroadcast, colour, text_filter_context)
            if self.inst.components.debuffable and self.inst.components.debuffable:HasDebuff("drunken") and type(script) == "string" and #script > 0 then
                script = script:gsub("[%.%!%?。！？%s]+$", "") .. "……喵~"
            end
            return OldSay(self, script, time, noanim, force, nobroadcast, colour, text_filter_context)
        end
    end
    local OnDespawn = inst.OnDespawn
    function inst:OnDespawn(migrationdata, ...)
        if self._other_space ~= nil then
            self._other_space_data = self._other_space:GetSaveRecord()
            self:RemoveChild(self._other_space)
            self._other_space.persists = false
            self._other_space:Remove()
            self._other_space = nil
        end
        CleanupSpacemotor(self)
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
    inst:ListenForEvent("death", CleanupSpacemotor)
    inst:ListenForEvent("playerghost", CleanupSpacemotor)

    inst:ListenForEvent("onattackother", function(inst, data)
        local updater = inst.components.skilltreeupdater
        if updater == nil or not updater:IsActivated("shiro_evolution_arachne") then
            return
        end
        -- onattackother 事件不携带伤害数值，二重打击按本次攻击的实际伤害重新计算
        if not inst._is_double_hitting and data and data.target and data.target:IsValid() and data.target.components.combat
            and math.random() < 0.25 then
            local dmg, spdamage = inst.components.combat:CalcDamage(data.target, data.weapon)
            dmg = dmg * 0.5
            if spdamage ~= nil then
                local half = {}
                for k, v in pairs(spdamage) do
                    half[k] = v * 0.5
                end
                spdamage = half
            end

            inst._is_double_hitting = true
            inst:DoTaskInTime(0.05, function()
                if data.target:IsValid() and data.target.components.combat then
                    data.target.components.combat:GetAttacked(inst, dmg, data.weapon, "double_strike", spdamage)
                    SpawnAt("impact", data.target)
                end
                inst._is_double_hitting = false
            end)
        end
    end)

    inst:DoPeriodicTask(2, function()
        if not inst:IsValid() or inst.components.health:IsDead() then return end
        local updater = inst.components.skilltreeupdater
        if updater == nil then return end

        if updater:IsActivated("sapiens") then
            if not inst._sapiens_mp_boosted then
                inst.components.magicpoint:AddConsumptionSrc(inst, 1, "sapiens")
                inst._sapiens_mp_boosted = true
            end
            if inst.player_classified ~= nil and inst.player_classified.MapExplorer ~= nil then
                local x, y, z = inst.Transform:GetWorldPosition()
                local bosses = TheSim:FindEntities(x, 0, z, 60, { "epic" }, { "INLIMBO", "player" })
                for _, b in ipairs(bosses) do
                    if b:IsValid() then
                        local bx, by, bz = b.Transform:GetWorldPosition()
                        inst.player_classified.MapExplorer:RevealArea(bx, 0, bz)
                    end
                end
            end
        else
            if inst._sapiens_mp_boosted then
                inst.components.magicpoint:RemoveConsumptionSrc(inst, "sapiens")
                inst._sapiens_mp_boosted = nil
            end
        end

        if updater:IsActivated("shiro_evolution_queen_spider") then
            local x, y, z = inst.Transform:GetWorldPosition()
            local spiders = TheSim:FindEntities(x, 0, z, 8, { "spider" }, { "INLIMBO", "hostile" })
            for _, sp in ipairs(spiders) do
                if sp:IsValid() and sp.components.follower and sp.components.follower.leader == nil and not (sp.components.combat and sp.components.combat.target == inst) then
                    sp.components.follower:SetLeader(inst)
                end
            end
        end
    end)

    inst:DoPeriodicTask(0.25, UpdateSpacemotor)
end

return MakePlayerCharactor(avatar_name, prefabs, assets, common_postinit, master_postinit)
