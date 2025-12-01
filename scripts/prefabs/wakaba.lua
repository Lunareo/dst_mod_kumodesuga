local MakePlayerCharactor = require "prefabs/player_common"
local WakabaAgeBadge = require "widgets/wakabaagebadge"

local avatar_name = "wakaba"

local assets = {
    Asset("DYNAMIC_ANIM", "anim/dynamic/wakaba.zip"),
    Asset("PKGREF", "anim/dynamic/wakaba.dyn"),
    Asset("SCRIPT", "scripts/prefabs/player_common.lua"),
}

local prefabs = {}

local start_inv = {}
for k, v in pairs(TUNING.GAMEMODE_STARTING_ITEMS) do
    start_inv[string.lower(k)] = v[string.upper(avatar_name)]
end

prefabs = FlattenTree({ prefabs, start_inv }, true)

local function GetPointSpecialActions(inst, pos, useitem, right)
    if right and useitem == nil then
        local rider = inst.replica.rider
        if rider ~= nil and not rider:IsRiding() or rider == nil then
            return { ACTIONS.PARRY }
        end
    end
    return {}
end

local function OnSetOwner(inst)
    if inst.components.playeractionpicker ~= nil then
        inst.components.playeractionpicker.pointspecialactionsfn = GetPointSpecialActions
    end
end

local function redirect_to_oldager(inst, amount, overtime, cause, ignore_invincible, afflicter, ignore_absorb)
    return inst.components.oldager ~= nil and
        inst.components.oldager:OnTakeDamage(amount, overtime, cause, ignore_invincible, afflicter, ignore_absorb)
end

local function CustomDmg(inst, target, weapon, multiplier, mount)
    return weapon and weapon:HasTag("lighterweapon") and 1 or TUNING.WENDY_DAMAGE_MULT
end

local heal_srcs = {
    "debug_key",
    "redamulet",
    "wortox_soul",
    "jellybean",
    "saturation",
}

local common_postinit = function(inst)
    inst:AddTag(avatar_name)
    inst:AddTag("D_spirit")
    inst:AddTag("reader")
    inst:AddTag("canbuildspcontainer")

    inst.MiniMapEntity:SetIcon(avatar_name .. ".tex")

    if not TheNet:IsDedicated() then
        inst.CreateHealthBadge = WakabaAgeBadge
    end

    inst:ListenForEvent("setowner", OnSetOwner)
end

local master_postinit = function(inst)
    inst.starting_inventory = start_inv[TheNet:GetServerGameMode()] or start_inv.default
    inst.soundsname = "wendy"

    local reader = inst:AddComponent("reader")
    reader.sanity_mult = 0

    inst.components.foodaffinity:AddPrefabAffinity("chips", TUNING.AFFINITY_15_CALORIES_MED)

    inst.components.health:SetMaxHealth(TUNING[string.upper(avatar_name) .. "_OLDAGER"])
    inst.components.health.redirect = redirect_to_oldager
    inst.components.health.disable_penalty = true
    inst.resurrect_multiplier = TUNING.WAKABA_HEALTH_SCALE
    --PostInit.wakaba.health(inst.components.health)

    inst.components.hunger:SetMax(TUNING[string.upper(avatar_name) .. "_HUNGER"])

    inst.components.sanity:SetMax(TUNING[string.upper(avatar_name) .. "_SANITY"])
    inst.components.sanity.get_equippable_dappernessfn = function() return 0 end
    --PostInit.wakaba.sanity(inst.components.sanity)

    local oldager = inst:AddComponent("oldager")
    oldager.base_rate = -TUNING.WAKABA_OLDAGE_RECOVER_RATE
    for _, src in ipairs(heal_srcs) do
        oldager:AddValidHealingCause(src)
    end
    function oldager:OnTakeDamage(amount, overtime, cause, ignore_invincible, afflicter, ignore_absorb)
        if self._taking_time_damage then
            return false
        end
        if amount < 0 or self.valid_healing_causes[cause] then
            amount = -amount -- because aging is reversed from health

            local damage_remaining = self.damage_remaining
            if (damage_remaining > 0 and amount < 0) or (damage_remaining < 0 and amount > 0) then
                damage_remaining = 0
            end

            self.damage_remaining = damage_remaining + amount * TUNING.WAKABA_HEALTH_SCALE
            self.damage_per_second = math.min(math.ceil(math.sqrt(math.abs(self.damage_remaining)) * 1.5), 30)
            if self.damage_remaining < 0 then
                self.damage_per_second = -self.damage_per_second
            end
        end

        return true
    end

    inst.components.combat.customdamagemultfn = CustomDmg
    --PostInit.wakaba.combat(inst.components.combat)

    inst:AddComponent("parryable")

    --PostInit.wakaba.inventory(inst.components.inventory)

    inst.skeleton_prefab = nil
end

return MakePlayerCharactor(avatar_name, prefabs, assets, common_postinit, master_postinit)
