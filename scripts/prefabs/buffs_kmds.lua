---@diagnostic disable: inject-field, undefined-field
local function AttachFX(fx, buff, target, followsymbol, followoffset)
    if not buff._fx then
        local offset = followoffset or Vector3(0, 0, 0)
        buff._fx = SpawnPrefab(fx)
        buff._fx:ListenForEvent("onremove", function() buff._fx:Remove() end, buff)
        buff._fx.Follower:FollowSymbol(target.GUID, followsymbol, offset:Get())
    end
end

local function CancelTask(inst, task)
    if inst[task] then
        inst[task]:Cancel()
        inst[task] = nil
    end
end

---@class buffdef
---@field attach fun(inst:ent, target:ent, followsymbol:string, followoffset:Vector3, data:table)
---@field extend fun(inst:ent, target:ent, followsymbol:string, followoffset:Vector3, data:table)|nil
---@field detach fun(inst:ent, target:ent, followsymbol:string, followoffset:Vector3, data:table)
---@field duration number|nil
---@field priority integer|nil
---@field prefabs table|nil
---@field nospeech boolean|nil
---@field onsave fun(inst:ent, data:table):(nil)|nil
---@field onload fun(inst:ent, data:table):(nil)|nil
---@field postfn fun(inst:ent):(nil)|nil

local function docurse(inst, target, data)
    inst.buff_layer = (inst.buff_layer or 0) + 1 -- compatible to f_medal
    if target and target.components.combat ~= nil and target.components.combat.AddBonusModifier ~= nil then
        target.components.combat:AddBonusModifier("buff_curse", -inst.buff_layer * TUNING.BUFF.CURSE_ATK_STEAL_MULT, inst)
    end
    -- Reserve for multi-mind
    --[[local doer = inst._doer and inst._doer:IsValid() and inst._doer or nil
    if doer ~= nil and doer.components.combat ~= nil then
        doer.components.combat:AddBonusModifier("buff_curse_doer", inst.buff_layer * .1, inst)
    end]]
end

local function dodecreasepenalty(inst, target)
    if not (target and target:IsValid() and target.components.health) then return end
    target.components.health:DeltaPenalty(-inst._regenval or 0)
    inst._regentick = (inst._regentick or 0) - 1
    if inst._regentick <= 0 then inst:PushEvent("timerdone", { name = "buffover" }) end
end

---@type table<string, buffdef>
local BUFF_DEFS = {
    erosion = {
        attach = function(inst, target, followsymbol, followoffset, data)
            CancelTask(inst, "_erosion_task")
            if target.components.combat then
                AttachFX("erosion_fx_loop", inst, target, followsymbol, followoffset)
                inst.attacker = data and data.attacker or inst
                inst._erosion_task = inst:DoPeriodicTask(1, function()
                    if not (target --[[and target:IsValid()]] and target.components.combat) then return end
                    target.components.combat:GetAttacked(inst.attacker or inst, 0, data and data.weapon, nil,
                        { erosion = 2.5 })
                end)
            else
                inst.components.timer:StopTimer("buffover")
            end
        end,
        extend = function(inst, target, followsymbol, followoffset, data)
            AttachFX("erosion_fx_loop", inst, target, followsymbol, followoffset)
            if data and data.attacker then
                inst.attacker = data.attacker
            end
        end,
        detach = function(inst, target, ...)
            CancelTask(inst, "_erosion_task")
        end,
        duration = 10,
        nospeech = true,
    },
    freeze = {
        attach = function(inst, target, followsymbol, followoffset, data)
            if target.Physics ~= nil then
                inst.physactive = target.Physics:IsActive()
                target.Physics:SetActive(false)
            end
            if target.AnimState ~= nil then
                target.AnimState:Pause()
            end
            if target.sg ~= nil then
                target.sg:GoToState("frozen")
                target.sg:Stop()
            end
            if target.components.inventoryitem ~= nil then
                inst.canbepickedup, target.components.inventoryitem.canbepickedup =
                    target.components.inventoryitem.canbepickedup,
                    true
            end
            target:StopBrain("freezed")
            SpawnAt("fx_book_sleep", target)
            --if data ~= nil then
            --    if data.doer ~= nil then
            --    end
            --end
        end,
        detach = function(inst, target, followsymbol, followoffset, data)
            if target:IsInLimbo() then return end
            if target.Physics ~= nil then
                target.Physics:SetActive(true)
            end
            if target.AnimState ~= nil then
                target.AnimState:Resume()
            end
            if target.sg ~= nil then
                target.sg:Start()
            end
            if target.components.inventoryitem ~= nil then
                target.components.inventoryitem.canbepickedup = inst.canbepickedup
            end
            target:RestartBrain("freezed")
        end,
        duration = 10,
        nospeech = true,
    },
    curse = {
        attach = function(inst, target, followsymbol, followoffset, data)
            inst._doer = data and data.doer
            inst._attach_task = target and target.components.combat ~= nil and
                inst:DoPeriodicTask(1, docurse, nil, target, data) or nil
        end,
        detach = function(inst, target, followsymbol, followoffset, data)
            CancelTask(inst, "_attach_task")
            if not (data and data.persist or inst.persists ~= false) then
                target.components.combat:RemoveBonusModifier("buff_curse", inst)
                if inst._doer ~= nil and inst._doer.components.combat ~= nil then
                    inst._doer.components.combat:RemoveBonusModifier("buff_curse_doer", inst)
                end
            end
        end,
        nospeech = true,
        onsave = function(inst, data)
            data.curse_count = inst.buff_layer
        end,
        onload = function(inst, data)
            inst.buff_layer = data.curse_count
        end,
    },
    health_penalty_reduction = {
        attach = function(inst, target, followsymbol, followoffset, data)
            inst._regentick = data and data.regentick or inst._regentick or 0
            inst._regenval = data and data.regenval or inst._regenval or 0
            inst._regentask = inst:DoPeriodicTask(1, dodecreasepenalty, nil, target)
        end,
        detach = function(inst, target, followsymbol, followoffset, data)
            CancelTask(inst, "_regentask")
        end,
        onsave = function(inst, data)
            data.regentick = inst._regentick or nil
            data.regenval = inst._regenval or nil
        end,
        onload = function(inst, data)
            inst._regentick = data.regentick or 0
            inst._regenval = data.regenval or 0
        end,
    },
    stronggravity = {
        attach = function(inst, target, followsymbol, followoffset, data)

        end,
        detach = function(inst, target, followsymbol, followoffset, data)

        end,
        duration = 10,
        nospeech = true,
    },
}

local function OnTimerDone(inst, data)
    if data.name == "buffover" then
        inst.components.debuff:Stop()
    end
end

---@param name string
---@param onattachedfn function
---@param onextendedfn function
---@param ondetachedfn function
---@param duration number|nil
---@param priority integer|nil
---@param prefabs table|nil
---@param nospeech boolean|nil
---@param extradata buffdef
---@return Prefab
local function MakeBuff(name, onattachedfn, onextendedfn, ondetachedfn, duration, priority, prefabs, nospeech, extradata)
    local ATTACH_BUFF_DATA = {
        buff = (not nospeech and "ANNOUNCE_ATTACH_BUFF_" .. string.upper(name)) or nil,
        priority = priority
    }
    local DETACH_BUFF_DATA = {
        buff = (not nospeech and "ANNOUNCE_DETACH_BUFF_" .. string.upper(name)) or nil,
        priority = priority
    }

    local function OnAttached(inst, target, followsymbol, followoffset, data, ...)
        inst.entity:SetParent(target.entity)
        inst.Transform:SetPosition(0, 0, 0) --in case of loading
        inst:ListenForEvent("death", function()
            inst.components.debuff:Stop()
        end, target)

        target:PushEvent("foodbuffattached", ATTACH_BUFF_DATA)
        if onattachedfn ~= nil then
            if data ~= nil and data.duration then
                inst.components.timer:StopTimer("buffover")
                inst.components.timer:StartTimer("buffover", data.duration)
            end
            onattachedfn(inst, target, followsymbol, followoffset, data, ...)
        end
    end

    local function OnExtended(inst, target, followsymbol, followoffset, data, ...)
        if type(duration) == "number" then
            inst.components.timer:StopTimer("buffover")
            inst.components.timer:StartTimer("buffover", duration)
        end

        target:PushEvent("foodbuffattached", ATTACH_BUFF_DATA)
        if onextendedfn ~= nil then
            if data ~= nil and data.duration then
                inst.components.timer:StopTimer("buffover")
                inst.components.timer:StartTimer("buffover", data.duration)
            end
            onextendedfn(inst, target, followsymbol, followoffset, data, ...)
        end
    end

    local function OnDetached(inst, target, followsymbol, followoffset, data, ...)
        if ondetachedfn ~= nil then
            ondetachedfn(inst, target, followsymbol, followoffset, data, ...)
        end

        target:PushEvent("foodbuffdetached", DETACH_BUFF_DATA)
        inst:Remove()
    end

    local function fn()
        local inst = CreateEntity()

        if not TheWorld.ismastersim then
            --Not meant for client!
            inst:DoTaskInTime(0, inst.Remove)
            return inst
        end

        inst.entity:AddTransform()

        --[[Non-networked entity]]
        --inst.entity:SetCanSleep(false)
        inst.entity:Hide()
        inst.persists = false

        inst:AddTag("CLASSIFIED")

        inst:AddComponent("debuff")
        inst.components.debuff:SetAttachedFn(OnAttached)
        inst.components.debuff:SetDetachedFn(OnDetached)
        inst.components.debuff:SetExtendedFn(OnExtended)
        inst.components.debuff.keepondespawn = true

        inst:AddComponent("updatelooper")

        inst:AddComponent("timer")
        if type(duration) == "number" then
            inst.components.timer:StartTimer("buffover", duration)
        end
        inst:ListenForEvent("timerdone", OnTimerDone)

        --if TUNING.FUNCTIONAL_MEDAL_IS_OPEN then
        --end

        inst.OnSave = extradata.onsave
        inst.OnLoad = extradata.onload

        if extradata.postfn then
            extradata.postfn(inst)
        end

        return inst
    end

    return Prefab("buff_" .. name, fn, nil, prefabs)
end

local buffs = {}
for k, v in pairs(BUFF_DEFS) do
    table.insert(buffs,
        MakeBuff(k, v.attach, v.extend, v.detach, v.duration, v.priority, v.prefabs, v.nospeech, v))
end
return unpack(buffs)
