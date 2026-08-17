KMDS.BeyondSanity = KMDS.BeyondSanity or {
    shadow_query_depth = 0,
    moon_query_depth = 0,
}
local BeyondSanity = KMDS.BeyondSanity

---@param depth_key "shadow_query_depth"|"moon_query_depth"
---@param fn function
local function RunTargetQuery(depth_key, fn, ...)
    BeyondSanity[depth_key] = BeyondSanity[depth_key] + 1
    local ok, ret1, ret2 = pcall(fn, ...)
    BeyondSanity[depth_key] = BeyondSanity[depth_key] - 1
    if not ok then
        error(ret1, 0)
    end
    return ret1, ret2
end

---@param inst ent
---@param depth_key "shadow_query_depth"|"moon_query_depth"
local function WrapCombatRetarget(inst, depth_key)
    if not TheWorld.ismastersim or inst.components.combat == nil then return end

    local combat = inst.components.combat
    local old_try_retarget = combat.TryRetarget
    combat.TryRetarget = function(self, ...)
        return RunTargetQuery(depth_key, old_try_retarget, self, ...)
    end
end

local function ShadowCreaturePostInit(inst)
    WrapCombatRetarget(inst, "shadow_query_depth")

    if not TheWorld.ismastersim or inst.ShouldKeepTarget == nil then return end

    local old_should_keep_target = inst.ShouldKeepTarget
    inst.ShouldKeepTarget = function(...)
        return RunTargetQuery("shadow_query_depth", old_should_keep_target, ...)
    end
end

AddPrefabPostInit("crawlinghorror", ShadowCreaturePostInit)
AddPrefabPostInit("terrorbeak", ShadowCreaturePostInit)
AddPrefabPostInit("oceanhorror", ShadowCreaturePostInit)

-- Gestalt guards query both target eligibility and behaviour level during
-- Combat:TryRetarget, so one scoped query preserves all original protection,
-- equipment, buff, and CanTarget checks.
AddPrefabPostInit("gestalt_guard", function(inst)
    WrapCombatRetarget(inst, "moon_query_depth")
end)

-- Regular gestalts obtain their tracking target through the world spawner.
-- Only that lookup sees beyond_sanity as high lunacy; population updates and
-- every unrelated sanity-percent consumer retain their original values.
AddComponentPostInit("brightmarespawner", function(self)
    local old_find_best_player = self.FindBestPlayer
    self.FindBestPlayer = function(component, ...)
        return RunTargetQuery("moon_query_depth", old_find_best_player, component, ...)
    end
end)
