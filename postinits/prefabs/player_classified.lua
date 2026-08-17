---@diagnostic disable: inject-field
-- local function SetDirty(netvar, val)
--     --Forces a netvar to be dirty regardless of value
--     netvar:set_local(val)
--     netvar:set(val)
-- end

-- local function OnSaturaDelta(parent, data)
-- end

local function PushScoreDirty(inst, currentname, maxname, oldcurrentname, oldpercentname, eventname)
    local current = inst[currentname]:value()
    local max = inst[maxname]:value()
    local percent = max > 0 and current / max or 0
    local oldcurrent = inst[oldcurrentname]
    local oldpercent = inst[oldpercentname]

    if oldcurrent == nil then
        oldcurrent = current
    end
    if oldpercent == nil then
        oldpercent = percent
    end

    inst[oldcurrentname] = current
    inst[oldpercentname] = percent

    if inst._parent ~= nil then
        inst._parent:PushEvent(eventname, {
            oldpercent = oldpercent,
            newpercent = percent,
            delta = current - oldcurrent,
            current = current,
            max = max,
        })
    end
end

local function OnSaturaDirty(inst)
    PushScoreDirty(inst, "currentsatura", "maxsatura", "_oldsaturacurrent", "_oldsaturapercent", "saturadelta")
end

local function OnAccelaDirty(inst)
    PushScoreDirty(inst, "currentaccela", "maxaccela", "_oldaccelacurrent", "_oldaccelapercent", "acceladelta")
end

local function OnStaminaDirty(inst)
    PushScoreDirty(inst, "currentstamina", "maxstamina", "_oldstaminacurrent", "_oldstaminapercent", "staminadelta")
end

local function OnMagicPointDirty(inst)
    PushScoreDirty(inst, "currentmagicpoint", "maxmagicpoint", "_oldmagicpointcurrent", "_oldmagicpointpercent", "magicpointdelta")
end


-- local function RegisterNetListeners_mastersim(inst)
--     inst:ListenForEvent("saturadelta", OnSaturaDelta, inst._parent)
-- end

local function RegisterNetListeners_local(inst)
    inst:ListenForEvent("saturadirty", OnSaturaDirty)
    inst:ListenForEvent("acceladirty", OnAccelaDirty)
    inst:ListenForEvent("staminadirty", OnStaminaDirty)
    inst:ListenForEvent("magicpointdirty", OnMagicPointDirty)
end

local function RegisterNetListeners(inst)
    if TheWorld.ismastersim then
        -- inst._parent = inst.entity:GetParent()
        -- RegisterNetListeners_mastersim(inst)
    else
        RegisterNetListeners_local(inst)
    end

    -- RegisterNetListeners_common(inst)
end

AddPrefabPostInit("player_classified", function(inst)
    inst._oldsaturacurrent = 0
    inst._oldsaturapercent = 0
    inst.currentsatura = net_ushortint(inst.GUID, "satura.current", "saturadirty")
    inst.maxsatura = net_ushortint(inst.GUID, "satura.max", "saturadirty")
    inst.currentsatura:set(0)
    inst.maxsatura:set(75)

    inst._oldaccelacurrent = 0
    inst._oldaccelapercent = 0
    inst.currentaccela = net_ushortint(inst.GUID, "accela.current", "acceladirty")
    inst.maxaccela = net_ushortint(inst.GUID, "accela.max", "acceladirty")
    inst.currentaccela:set(0)
    inst.maxaccela:set(100)

    inst._oldstaminacurrent = 0
    inst._oldstaminapercent = 0
    inst.currentstamina = net_ushortint(inst.GUID, "stamina.current", "staminadirty")
    inst.maxstamina = net_ushortint(inst.GUID, "stamina.max", "staminadirty")
    inst.currentstamina:set(0)
    inst.maxstamina:set(100)

    inst.skillenabled = net_ushortint(inst.GUID, "skillenabled", "skillenableddirty")
    inst.skillenabled:set(65535)

    inst._oldmagicpointcurrent = 0
    inst._oldmagicpointpercent = 0
    inst.currentmagicpoint = net_ushortint(inst.GUID, "magicpoint.current", "magicpointdirty")
    inst.maxmagicpoint = net_ushortint(inst.GUID, "magicpoint.max", "magicpointdirty")
    inst.currentmagicpoint:set(0)
    inst.maxmagicpoint:set(TUNING.SHIRO_MAGICPOINT)

    inst:DoStaticTaskInTime(0, RegisterNetListeners)
end)
