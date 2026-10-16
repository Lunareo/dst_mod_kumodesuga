-- 在独立离线测试世界的服务器端调用；不触碰玩家世界或账号存档。
return function(done)
    local Combat = require "ariel_combat"
    local Abilities = require "ariel_abilities"
    local made = {}
    local function spawn(name, x, z)
        local ent = assert(SpawnPrefab(name), "missing prefab: " .. name)
        made[#made + 1] = ent
        ent.Transform:SetPosition(x or 0, 0, z or 0)
        return ent
    end
    local function check(name, condition)
        assert(condition, "ARIEL_TEST failed: " .. name)
        print("ARIEL_TEST|" .. name .. "|ok")
    end
    local function near(a, b) return math.abs(a - b) < .001 end
    local delayed
    local function finish(ok, err)
        for _, ent in ipairs(made) do if ent:IsValid() then ent:Remove() end end
        if ok then print("ARIEL_TEST|all_tests_ok|true") end
        done(ok, err)
    end
    local ok, err = xpcall(function()
        local ariel = spawn("ariel")
        ariel.Transform:SetPosition(TheWorld.components.playerspawner:GetAnySpawnPoint())
        local x, _, z = ariel.Transform:GetWorldPosition()
        local pool = ariel.components.arielgluttony
        ariel:StopUpdatingComponent(pool)
        local commander = ariel.components.arielcommander
        check("stats", ariel.components.health.maxhealth == 300 and ariel.components.hunger.max == 250
            and ariel.components.sanity.max == 200 and near(ariel.components.hunger.hungerrate, TUNING.WILSON_HUNGER_RATE * 1.5))
        check("strings", STRINGS.ACTIONS.ARIEL_RECRUIT ~= nil and STRINGS.CHARACTERS.ARIEL.ANNOUNCE_ARIEL_JOKE ~= nil)
        local spells = require("prefabs/spells_ariel")(ariel)
        for _, spell in ipairs(spells) do check("spell_label", type(spell.label) == "string") end
        pool:DoDelta(90)
        check("tier3", pool:GetTier() == 3 and near(ariel.components.combat.externaldamagemultipliers:Get(), 1.5))
        pool:OnUpdate(1)
        check("tier3_decay", near(pool.current, 87))
        pool.combatleft = 8
        pool:OnUpdate(1)
        check("combat_decay_paused", near(pool.current, 87))
        ariel.components.health:SetCurrentHealth(100)
        check("wear_cost", pool:AddWear(15) and near(ariel.components.health.maxhealth, 285)
            and near(ariel.components.health.currenthealth, 100))
        pool:Nurture()
        pool:OnUpdate(1)
        check("nurture_rate", near(pool.wear, 14.5))
        pool.current = 0
        pool:Refresh()
        ariel.components.health:SetCurrentHealth(100)
        local meal = spawn("ariel_battlemeal", x, z)
        ariel.components.inventory:GiveItem(meal)
        check("devour_food", pool:Devour(meal))
        check("food_effects", near(ariel.components.health.currenthealth, 120) and near(pool.current, 50))
        check("war_buff", ariel:GetDebuff("ariel_war") ~= nil
            and near(ariel.components.combat.externaldamagemultipliers:Get(), 1.15 * 1.2))
        ariel:RemoveDebuff("ariel_war")
        local silk = spawn("silk", x, z)
        silk.components.stackable:SetStackSize(3)
        ariel.components.inventory:GiveItem(silk)
        local before = pool.current
        check("single_material", pool:Devour(silk) and silk.components.stackable:StackSize() == 2 and near(pool.current, before + 5))
        local rabbit = spawn("rabbit", x, z)
        check("live_item_protected", not pool:CanDevour(rabbit))
        local bundle = spawn("bundle", x, z)
        check("bundle_protected", not pool:CanDevour(bundle))
        local backpack = spawn("backpack", x, z)
        backpack.components.container:GiveItem(spawn("goldnugget", x, z))
        check("full_container_protected", not pool:CanDevour(backpack))
        local other = spawn("wilson", x, z)
        local gold = spawn("goldnugget", x, z)
        other.components.inventory:GiveItem(gold)
        check("foreign_item_protected", not pool:CanDevour(gold))
        check("player_protected", not Combat.IsEnemy(ariel, other))
        ariel.components.health:SetCurrentHealth(100)
        other.components.health:SetCurrentHealth(50)
        local mushroom = spawn("ariel_mushroommeal", x, z)
        check("mushroom_eat", ariel.components.eater:Eat(mushroom))
        check("mushroom_no_self_double", ariel.components.health.currenthealth == 140
            and other.components.health.currenthealth == 70)
        check("resist_buff", ariel:GetDebuff("ariel_resist") ~= nil and other:GetDebuff("ariel_resist") ~= nil)
        ariel:RemoveDebuff("ariel_resist")
        other:RemoveDebuff("ariel_resist")
        local material = spawn("ariel_puppetsilk", x, z)
        material.components.stackable:SetStackSize(4)
        ariel.components.inventory:GiveItem(material)
        ariel.components.hunger:SetPercent(1)
        check("summon", commander:Summon(1))
        local puppet = commander.puppets[1]
        puppet.components.health:SetCurrentHealth(81)
        check("pack", commander:Pack(puppet) and commander.packed[1] ~= nil)
        local hunger = ariel.components.hunger.current
        check("redeploy", commander:Summon(1) and commander.puppets[1].components.health.currenthealth == 81
            and ariel.components.hunger.current == hunger)
        check("unique_puppet", not commander:Summon(1))
        check("friendly_puppet", not Combat.IsEnemy(other, commander.puppets[1]))
        commander.puppets[1].components.health:Kill()
        check("death_cooldown", not pool:IsReady("puppet_1") and not commander:Summon(1))
        check("shield_summon", commander:Summon(4) and commander.puppets[4].components.health.maxhealth == 400)
        local saved = commander:OnSave()
        check("puppet_save", saved.puppets[4].data.health.health == 400)
        local queen = spawn("spiderqueen", x + 1, z)
        local brain = queen.brainfn
        check("queen_recruit", commander:Recruit(queen) and queen.components.follower:GetLeader() == ariel)
        check("queen_transient", queen.components.follower:OnSave() == nil)
        commander:DismissSpiders()
        check("queen_release", queen.components.follower:GetLeader() == nil and queen.brainfn == brain)
        pool.current = 0
        ariel.components.sanity:SetPercent(1)
        check("humility", pool:StartHumility() and pool:IsHumility())
        ariel.components.combat:ResetCooldown()
        ariel.sg:GoToState("ariel_attack")
        check("attack_timing", ariel.sg.currentstate.name == "ariel_attack"
            and near(ariel.sg.timeout, 24 * FRAMES / 1.5))
        ariel.sg:GoToState("idle")
        ariel:PushEvent("attacked", { attacker = other, damage = 1 })
        check("superarmour", ariel.sg.currentstate.name == "idle")
        ariel.components.freezable:AddColdness(100)
        check("freeze_immune", not ariel.components.freezable:IsFrozen())
        pool:OnUpdate(TUNING.ARIEL.humility_duration)
        check("exhaustion", pool:IsExhausted() and not pool:IsHumility() and pool:GetTier() == 0)
        local health = ariel.components.health.currenthealth
        ariel.components.health:DoDelta(10, true, "test")
        check("exhaustion_regen_blocked", health == ariel.components.health.currenthealth)
        local wear = pool.wear
        local state = pool:OnSave()
        local loaded = spawn("ariel", x, z)
        loaded.components.arielgluttony:OnLoad(state)
        check("wear_and_timer_save", loaded.components.arielgluttony.wear == wear
            and loaded.components.arielgluttony:IsExhausted() and not loaded.components.arielgluttony:IsReady("humility_cd"))
        check("invalid_cast", not Abilities.Cast(ariel, "Cast", ariel:GetPosition()))
        check("gate_not_cooker_recipe", require("preparedfoods").ariel_battlemeal == nil)
        spawn("ariel_silkchair", x + 2, z)
        spawn("ariel_silkbed", x + 4, z)
        spawn("ariel_mushroommeal", x, z)
        spawn("ariel_nurturemeal", x, z)
        check("all_prefabs", true)
        loaded:StopUpdatingComponent(loaded.components.arielgluttony)
        pool.timers = {}
        pool.current = 100
        pool:Refresh()
        local oldwear = pool.wear
        check("empty_gate_free", not Abilities.gate(ariel, Vector3(1000000, 0, 1000000))
            and pool.current == 100 and pool.wear == oldwear and pool:IsReady("gate_cd"))
        local pos
        for i = 1, 32 do
            local point = Vector3(x + math.cos(i * TWOPI / 32) * 9, 0, z + math.sin(i * TWOPI / 32) * 9)
            if Combat.CanStand(point) then pos = point; break end
        end
        assert(pos, "No open test position")
        local enemy = spawn("pigman", pos.x, pos.z)
        enemy:SetBrain(nil)
        enemy:AddTag("epic")
        enemy.components.health:SetMaxHealth(5000)
        enemy:AddComponent("abyssdefense")
        enemy.components.abyssdefense:SetBaseDefense(50)
        local immune = spawn("pigman", pos.x + .5, pos.z)
        immune:SetBrain(nil)
        immune.components.health:SetInvincible(true)
        local immunehealth = immune.components.health.currenthealth
        other.Transform:SetPosition(pos:Get())
        -- 隔离前一项蘑菇料理留下的饱腹回血，保留友军生命必须完全不变的断言。
        print("ARIEL_TEST|fixture_satura|" .. tostring(other.components.satura.current))
        other.components.satura:SetCurrent(0)
        local friendhealth = other.components.health.currenthealth
        local projectile = spawn("boomerang", x, z)
        projectile:AddTag("activeprojectile")
        projectile.components.projectile.owner = other
        check("friendly_projectile_protected", not pool:CanDevour(projectile))
        projectile.components.projectile.owner = enemy
        check("enemy_projectile", pool:CanDevour(projectile))
        projectile:Remove()
        check("gate_cast", Abilities.Cast(ariel, "gate", pos))
        check("gate_cost", near(pool.current, 40) and near(pool.wear, oldwear + 15) and not pool:IsReady("gate_cd"))
        local gate
        for _, ent in ipairs(TheSim:FindEntities(pos.x, 0, pos.z, 1)) do
            if ent.prefab == "ariel_gate" and ent.caster == ariel then gate = ent; break end
        end
        assert(gate, "Gate did not spawn")
        made[#made + 1] = gate
        local expected = 5000 - 2 * (gate.damage / 10 - 50)
        delayed = function()
            check("loaded_max_health", near(loaded.components.health.maxhealth, 300 - wear))
            check("gate_abyss_defense", near(enemy.components.health.currenthealth, expected))
            check("gate_invincible", immune.components.health.currenthealth == immunehealth)
            check("gate_friendly", other.components.health.currenthealth == friendhealth)
            check("gate_slow", near(enemy.components.locomotor:GetSpeedMultiplier(), .4))
            ariel.components.health:Kill()
            check("gate_death_cleanup", not gate:IsValid() and near(enemy.components.locomotor:GetSpeedMultiplier(), 1))
        end
    end, debug.traceback)
    if not ok then finish(false, err); return end
    TheWorld:DoTaskInTime(1.1, function()
        local passed, failure = xpcall(delayed, debug.traceback)
        finish(passed, failure)
    end)
end
