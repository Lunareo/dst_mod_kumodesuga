---@diagnostic disable: inject-field
-- local function SetDirty(netvar, val)
--     --Forces a netvar to be dirty regardless of value
--     netvar:set_local(val)
--     netvar:set(val)
-- end

-- local function OnSaturaDelta(parent, data)
-- end

local function OnSaturaDirty(inst)
    if inst._parent ~= nil then
        local oldpercent = inst._oldsaturapercent
        local percent = inst.currentsatura:value() / inst.maxsatura:value()
        local data =
        {
            oldpercent = oldpercent,
            newpercent = percent,
        }
        inst._oldsaturapercent = percent
        inst._parent:PushEvent("saturadelta", data)
    else
        inst._oldsaturapercent = 1
    end
end

local function OnAccelaDirty(inst)
    if inst._parent ~= nil then
        local oldpercent = inst._oldaccelapercent
        local percent = inst.currentaccela:value() / inst.maxaccela:value()
        local data =
        {
            oldpercent = oldpercent,
            newpercent = percent,
        }
        inst._oldaccelapercent = percent
        inst._parent:PushEvent("acceladelta", data)
    else
        inst._oldaccelapercent = 1
    end
end

local function OnStaminaDirty(inst)
    if inst._parent ~= nil then
        local oldpercent = inst._oldstaminapercent
        local percent = inst.currentstamina:value() / inst.maxstamina:value()
        local data =
        {
            oldpercent = oldpercent,
            newpercent = percent,
        }
        inst._oldstaminapercent = percent
        inst._parent:PushEvent("staminadelta", data)
    else
        inst._oldstaminapercent = 1
    end
end


-- local function RegisterNetListeners_mastersim(inst)
--     inst:ListenForEvent("saturadelta", OnSaturaDelta, inst._parent)
-- end

local function RegisterNetListeners_local(inst)
    inst:ListenForEvent("saturadirty", OnSaturaDirty)
    inst:ListenForEvent("acceladirty", OnAccelaDirty)
    inst:ListenForEvent("staminadirty", OnStaminaDirty)
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
    inst._oldsaturapercent = 0
    inst.currentsatura = net_ushortint(inst.GUID, "satura.current", "saturadirty")
    inst.maxsatura = net_ushortint(inst.GUID, "satura.max", "saturadirty")
    inst.currentsatura:set(0)
    inst.maxsatura:set(75)

    inst._oldaccelapercent = 0
    inst.currentaccela = net_ushortint(inst.GUID, "accela.current", "acceladirty")
    inst.maxaccela = net_ushortint(inst.GUID, "accela.max", "acceladirty")
    inst.currentaccela:set(0)
    inst.maxaccela:set(100)

    inst._oldstaminapercent = 0
    inst.currentstamina = net_ushortint(inst.GUID, "stamina.current", "staminadirty")
    inst.maxstamina = net_ushortint(inst.GUID, "stamina.max", "staminadirty")
    inst.currentstamina:set(0)
    inst.maxstamina:set(100)

    inst:DoStaticTaskInTime(0, RegisterNetListeners)
end)
