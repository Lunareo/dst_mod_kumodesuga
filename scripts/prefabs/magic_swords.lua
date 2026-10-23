local assets = {
    Asset("ANIM", "anim/spear.zip"),
    Asset("ANIM", "anim/swap_spear.zip"),
}

local prefabs = {
    "explode_small",
    "lightning_grid_field",
}

--------------------------------------------------------------------------------
-- 通用装备与卸下表现
--------------------------------------------------------------------------------
local function onequip(inst, owner)
    owner.AnimState:OverrideSymbol("swap_object", "swap_spear", "swap_spear")
    owner.AnimState:Show("ARM_carry")
    owner.AnimState:Hide("ARM_normal")

    if inst._light ~= nil and inst._light:IsValid() then
        inst._light.Light:Enable(true)
    end
end

local function onunequip(inst, owner)
    owner.AnimState:Hide("ARM_carry")
    owner.AnimState:Show("ARM_normal")

    if inst._light ~= nil and inst._light:IsValid() then
        inst._light.Light:Enable(false)
    end
end

--------------------------------------------------------------------------------
-- 通用寿命管理（480 秒 / 720 秒）
--------------------------------------------------------------------------------
local function OnDecayExpire(inst)
    if inst:IsValid() then
        local x, y, z = inst.Transform:GetWorldPosition()
        local fx = SpawnPrefab("small_puff")
        if fx ~= nil then
            fx.Transform:SetPosition(x, y, z)
        end
        inst:Remove()
    end
end

local function SetupDecay(inst, duration)
    inst._decay_duration = duration or 480
    inst._decay_remaining = inst._decay_duration
    if inst._decay_task ~= nil then inst._decay_task:Cancel() end
    inst._decay_task = inst:DoPeriodicTask(1, function()
        inst._decay_remaining = inst._decay_remaining - 1
        if inst._decay_remaining <= 0 then
            OnDecayExpire(inst)
        end
    end)
end

local function OnSaveSword(inst, data)
    data.decay_remaining = inst._decay_remaining
    data.combo_count = inst._combo_count
end

local function OnLoadSword(inst, data)
    if data ~= nil then
        if data.decay_remaining ~= nil and data.decay_remaining > 0 then
            SetupDecay(inst, data.decay_remaining)
        end
        inst._combo_count = data.combo_count or 0
    end
end

--------------------------------------------------------------------------------
-- 友伤与随从过滤判定
--------------------------------------------------------------------------------
local function IsValidHostileCombatTarget(doer, target)
    if target == nil or not target:IsValid() or not target.components.combat then
        return false
    end
    if target:HasTag("INLIMBO") or target:HasTag("companion") or target:HasTag("wall") then
        return false
    end
    if target:HasTag("player") and not TheNet:GetPVPEnabled() then
        return false
    end
    return doer.components.combat:CanTarget(target)
end

--------------------------------------------------------------------------------
-- 招架反击辅助
--------------------------------------------------------------------------------
local function SwordOnParry(inst, doer, attacker, damage)
    if doer ~= nil and doer.components.wrathstate ~= nil then
        doer.components.wrathstate:OnParrySuccess(attacker, damage)
    end
end

local function SwordSpellFn(inst, doer, pos)
    if doer == nil or not doer:IsValid() then return end
    local duration = 0.35
    if doer.components.skilltreeupdater ~= nil and doer.components.skilltreeupdater:IsActivated("wrath_parry_window") then
        duration = 0.45
    end
    local angle = pos ~= nil and doer:GetAngleToPoint(pos) or doer.Transform:GetRotation()
    inst.components.parryweapon:EnterParryState(doer, angle, duration)
    inst.components.rechargeable:Discharge(3)
end

local function AddParryComponent(inst)
    inst:AddTag("parryweapon")
    inst:AddTag("rechargeable")

    if not TheWorld.ismastersim then return end

    inst:AddComponent("aoespell")
    inst.components.aoespell:SetSpellFn(SwordSpellFn)

    inst:AddComponent("parryweapon")
    inst.components.parryweapon:SetParryArc(120)
    inst.components.parryweapon:SetOnParryFn(SwordOnParry)

    inst:AddComponent("rechargeable")
    inst.components.rechargeable:SetCooldown(3)
end

--------------------------------------------------------------------------------
-- 通用魔剑骨架：五把剑仅伤害、耐久、附魔与外观参数不同
--------------------------------------------------------------------------------
local SWORD_FLOATABLE = { "med", 0.05, { 1.1, 0.5, 1.1 }, true, -9 }
local DAGGER_FLOATABLE = { "med", 0.05, { 0.8, 0.4, 0.8 }, true, -9 }
local SWORD_LIGHT_COLOUR = { 240 / 255, 120 / 255, 40 / 255 }

---@param config table
---@return fun(): ent
local function MakeSword(config)
    return function()
        local inst = CreateEntity()
        inst.entity:AddTransform()
        inst.entity:AddAnimState()
        inst.entity:AddNetwork()

        MakeInventoryPhysics(inst)

        inst.AnimState:SetBank("spear")
        inst.AnimState:SetBuild("swap_spear")
        inst.AnimState:PlayAnimation("idle")

        inst:AddTag("sharp")
        inst:AddTag("pointy")
        inst:AddTag("weapon")
        if config.tags ~= nil then
            for _, tag in ipairs(config.tags) do
                inst:AddTag(tag)
            end
        end
        if config.parry then
            AddParryComponent(inst)
        end

        MakeInventoryFloatable(inst, unpack(config.floatable))

        inst.entity:SetPristine()
        if not TheWorld.ismastersim then return inst end

        inst:AddComponent("weapon")
        inst.components.weapon:SetDamage(config.damage)
        if config.onattack ~= nil then
            inst.components.weapon:SetOnAttack(config.onattack)
        end

        inst:AddComponent("finiteuses")
        inst.components.finiteuses:SetMaxUses(config.uses)
        inst.components.finiteuses:SetUses(config.uses)
        inst.components.finiteuses:SetOnFinished(inst.Remove)

        inst:AddComponent("inspectable")
        inst:AddComponent("inventoryitem")

        inst:AddComponent("equippable")
        inst.components.equippable:SetOnEquip(onequip)
        inst.components.equippable:SetOnUnequip(onunequip)

        if config.spellfn ~= nil then
            inst:AddComponent("aoespell")
            inst.components.aoespell:SetSpellFn(config.spellfn)
        end

        if config.light then
            local light = SpawnPrefab("minerhatlight")
            if light ~= nil then
                light.entity:SetParent(inst.entity)
                light.Light:SetRadius(2.0)
                light.Light:SetFalloff(0.7)
                light.Light:SetIntensity(0.6)
                light.Light:SetColour(unpack(SWORD_LIGHT_COLOUR))
                light.Light:Enable(false)
                inst._light = light
            end
        end

        SetupDecay(inst, 480)
        inst.OnSave = OnSaveSword
        inst.OnLoad = OnLoadSword

        MakeHauntableLaunch(inst)
        return inst
    end
end

--------------------------------------------------------------------------------
-- 1. 破烂哥布林小刀 (goblin_dagger)
--------------------------------------------------------------------------------
local goblin_dagger_fn = MakeSword {
    damage = 17, uses = 40, floatable = DAGGER_FLOATABLE, tags = { "quick_murderer" },
}

--------------------------------------------------------------------------------
-- 2. 烈焰魔剑 (flame_sword)
--------------------------------------------------------------------------------
local function OnAttackFlameSword(inst, attacker, target)
    if attacker == nil or not attacker:IsValid() then return end
    inst._combo_count = (inst._combo_count or 0) + 1

    -- 每第 3 次攻击触发炎斩
    if inst._combo_count >= 3 then
        inst._combo_count = 0
        if target and target:IsValid() then
            local x, y, z = target.Transform:GetWorldPosition()
            -- 范围 2，最多 3 个敌人
            local targets = TheSim:FindEntities(x, y, z, 2.0, { "_combat" }, { "INLIMBO" })
            local hit_count = 0
            for _, ent in ipairs(targets) do
                if hit_count >= 3 then break end
                if IsValidHostileCombatTarget(attacker, ent) then
                    hit_count = hit_count + 1
                    ent.components.combat:GetAttacked(attacker, 15, inst, "fire")
                    if ent.components.burnable ~= nil and not ent.components.burnable:IsBurning() then
                        ent.components.burnable:Ignite(nil, attacker)
                    end
                end
            end
            local fx = SpawnPrefab("explode_small")
            if fx ~= nil then
                fx.Transform:SetPosition(x, y, z)
            end
        end
    end
end

local flame_sword_fn = MakeSword {
    damage = 51, uses = 80, floatable = SWORD_FLOATABLE, parry = true, light = true, onattack = OnAttackFlameSword,
}

--------------------------------------------------------------------------------
-- 3. 迅雷魔剑 (lightning_sword)
--------------------------------------------------------------------------------
local function OnAttackLightningSword(inst, attacker, target)
    if attacker == nil or not attacker:IsValid() then return end
    inst._combo_count = (inst._combo_count or 0) + 1

    -- 每第 3 次攻击触发跳跃电弧
    if inst._combo_count >= 3 then
        inst._combo_count = 0
        if target and target:IsValid() then
            local x, y, z = target.Transform:GetWorldPosition()
            local ents = TheSim:FindEntities(x, y, z, 4.0, { "_combat" }, { "INLIMBO" })
            local hit_count = 0
            local now = GetTime()
            for _, ent in ipairs(ents) do
                if hit_count >= 3 then break end
                if IsValidHostileCombatTarget(attacker, ent) then
                    hit_count = hit_count + 1
                    local elec_dmg = 20
                    if ent.components.moisture ~= nil and ent.components.moisture:GetMoisture() > 0 then
                        elec_dmg = elec_dmg * 1.5
                    end
                    ent.components.combat:GetAttacked(attacker, elec_dmg, inst, "electric")

                    -- 3秒内置硬直打断
                    if ent._wrath_last_shock_time == nil or (now - ent._wrath_last_shock_time) >= 3.0 then
                        ent._wrath_last_shock_time = now
                        if ent.sg ~= nil and not ent:HasTag("epic") and not ent:HasTag("boss") then
                            ent.sg:GoToState("hit")
                        end
                    end

                    -- 元素连携技能：目标若着火，追加 15 范围过载破片
                    local updater = attacker.components.skilltreeupdater
                    if updater ~= nil and updater:IsActivated("wrath_element_combo") then
                        if ent.components.burnable and ent.components.burnable:IsBurning() then
                            local tx, ty, tz = ent.Transform:GetWorldPosition()
                            local combo_targets = TheSim:FindEntities(tx, ty, tz, 2.5, { "_combat" }, { "INLIMBO" })
                            for _, c_ent in ipairs(combo_targets) do
                                if IsValidHostileCombatTarget(attacker, c_ent) then
                                    c_ent.components.combat:GetAttacked(attacker, 15, inst)
                                end
                            end
                            local fx = SpawnPrefab("explode_small")
                            if fx ~= nil then fx.Transform:SetPosition(tx, ty, tz) end
                        end
                    end
                end
            end
        end
    end
end

local lightning_sword_fn = MakeSword {
    damage = 51, uses = 60, floatable = SWORD_FLOATABLE, parry = true, onattack = OnAttackLightningSword,
}

--------------------------------------------------------------------------------
-- 4. 爆碎魔剑 (explosive_sword)
--------------------------------------------------------------------------------
local function DoExplosionAt(inst, doer, pt)
    local x, y, z = pt.x, pt.y, pt.z
    local has_mastery = doer.components.skilltreeupdater ~= nil
        and doer.components.skilltreeupdater:IsActivated("wrath_explosive_mastery")

    local dmg = has_mastery and 240 or 200

    -- 特效
    local fx = SpawnPrefab("explode_small")
    if fx ~= nil then fx.Transform:SetPosition(x, y, z) end

    -- 伤害范围 3
    local targets = TheSim:FindEntities(x, y, z, 3.0, nil, { "INLIMBO", "structure", "wall", "boat" })
    for _, ent in ipairs(targets) do
        if ent == doer then
            -- 投掷者自伤 60 且强制击退
            doer.components.combat:GetAttacked(nil, 60, nil)
            if doer.Physics ~= nil then
                local rot = doer:GetAngleToPoint(x, y, z) * DEGREES
                doer.Physics:SetVel(-math.cos(rot) * 8, 0, math.sin(rot) * 8)
            end
        elseif IsValidHostileCombatTarget(doer, ent) then
            ent.components.combat:GetAttacked(doer, dmg, inst)
        elseif ent.components.workable ~= nil and ent:HasTag("mineable") then
            -- 破拆矿石
            local num_work = has_mastery and 10 or 6
            ent.components.workable:WorkedBy(doer, num_work)
        end
    end

    -- 爆破精研反冲后跳
    if has_mastery and doer.Physics ~= nil then
        local rot = doer:GetAngleToPoint(x, y, z) * DEGREES
        doer.Physics:SetVel(-math.cos(rot) * 4, 0, math.sin(rot) * 4)
    end

    inst:Remove()
end

local function ThrowSpellFn(inst, doer, pos)
    if doer == nil or not doer:IsValid() or pos == nil then return end

    local range = 10
    if doer.components.skilltreeupdater ~= nil and doer.components.skilltreeupdater:IsActivated("wrath_explosive_mastery") then
        range = 12
    end

    local dsq = doer:GetDistanceSqToPoint(pos)
    if dsq > range * range then
        local angle = doer:GetAngleToPoint(pos) * DEGREES
        pos = Vector3(
            doer.Transform:GetWorldPosition() + math.cos(angle) * range,
            0,
            doer.Transform:GetWorldPosition() - math.sin(angle) * range
        )
    end

    DoExplosionAt(inst, doer, pos)
end

local explosive_sword_fn = MakeSword {
    damage = 51, uses = 20, floatable = SWORD_FLOATABLE, spellfn = ThrowSpellFn,
}

--------------------------------------------------------------------------------
-- 5. 雷栅阵剑 (lightning_grid_sword) 与 雷栅力场 (lightning_grid_field)
--------------------------------------------------------------------------------
local function GridSpellFn(inst, doer, pos)
    if doer == nil or not doer:IsValid() then return end
    local pt = pos or doer:GetPosition()

    -- 全图同时至多维持 1 个雷栅（清理旧的）
    if doer._active_lightning_grid ~= nil and doer._active_lightning_grid:IsValid() then
        doer._active_lightning_grid:Remove()
        doer._active_lightning_grid = nil
    end

    local grid = SpawnPrefab("lightning_grid_field")
    if grid ~= nil then
        grid.Transform:SetPosition(pt.x, 0, pt.z)
        grid._creator = doer
        doer._active_lightning_grid = grid
    end

    inst:Remove()
end

local lightning_grid_sword_fn = MakeSword {
    damage = 34, uses = 40, floatable = SWORD_FLOATABLE, spellfn = GridSpellFn,
}

--------------------------------------------------------------------------------
-- 雷栅力场预制件 (lightning_grid_field)
--------------------------------------------------------------------------------
local function lightning_grid_field_fn()
    local inst = CreateEntity()
    inst.entity:AddTransform()
    inst.entity:AddNetwork()

    inst:AddTag("FX")
    inst:AddTag("NOCLICK")

    inst.entity:SetPristine()
    if not TheWorld.ismastersim then return inst end

    -- 每秒对范围内敌怪造成 15 电伤并减速 30%（首领 15%）
    inst:DoPeriodicTask(1.0, function()
        local x, y, z = inst.Transform:GetWorldPosition()
        local creator = inst._creator
        local ents = TheSim:FindEntities(x, y, z, 3.0, { "_combat" }, { "INLIMBO" })
        for _, ent in ipairs(ents) do
            if creator and creator:IsValid() and IsValidHostileCombatTarget(creator, ent) then
                ent.components.combat:GetAttacked(creator, 15, nil, "electric")

                -- 减速效果
                if ent.components.locomotor ~= nil then
                    local slow_rate = (ent:HasTag("epic") or ent:HasTag("boss")) and 0.85 or 0.70
                    ent.components.locomotor:SetExternalSpeedMultiplier(inst, "lightning_grid_slow", slow_rate)
                    ent:DoTaskInTime(1.1, function()
                        if ent:IsValid() and ent.components.locomotor ~= nil then
                            ent.components.locomotor:RemoveExternalSpeedMultiplier(inst, "lightning_grid_slow")
                        end
                    end)
                end
            end
        end
    end)

    -- 持续 10 秒
    inst:DoTaskInTime(10, function()
        if inst:IsValid() then inst:Remove() end
    end)

    return inst
end

return Prefab("goblin_dagger", goblin_dagger_fn, assets),
    Prefab("flame_sword", flame_sword_fn, assets),
    Prefab("lightning_sword", lightning_sword_fn, assets),
    Prefab("explosive_sword", explosive_sword_fn, assets, prefabs),
    Prefab("lightning_grid_sword", lightning_grid_sword_fn, assets, prefabs),
    Prefab("lightning_grid_field", lightning_grid_field_fn)
