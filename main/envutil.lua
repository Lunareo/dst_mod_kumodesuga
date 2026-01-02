---@diagnostic disable: lowercase-global, undefined-global, redundant-return-value

---------------------------------------------
---                 env                   ---
---------------------------------------------
GLOBAL.setmetatable(env, { __index = function(_, k) return GLOBAL.rawget(GLOBAL, k) end })

---@type table<string, table>
local package_loaded = {}

---@param modulename string
---@param env_override table|_G|nil
---@param force boolean|nil # force reload
---@return any
modrequire = function(modulename, env_override, force)
    if package_loaded[modulename] == nil or force then
        local result = kleiloadlua(MODROOT .. "scripts/" .. modulename .. ".lua")
        setfenv(result, env_override or env)
        package_loaded[modulename] = { result() }
    end
    return unpack(package_loaded[modulename])
end

---@param dest table|nil
---@param orig table
---@param force boolean|nil
---@return table
merge = function(dest, orig, force)
    dest = dest or {}
    for k, v in pairs(orig) do
        if type(v) == "table" and type(dest[k]) == "table" then
            merge(dest[k], v, force)
        else
            if force then
                dest[k] = v
            else
                dest[k] = dest[k] or v
            end
        end
    end
    return dest
end

---@param module string
---@param ... string
hookimport = function(module, ...)
    local sub = { ... }
    if #sub <= 0 then
        modimport("postinits/" .. module)
    else
        for _, v in ipairs(sub) do
            modimport("postinits/" .. module .. "/" .. v)
        end
    end
end

---@param common fun(inst:ent)|nil
---@param master fun(inst:ent)|nil
AddPlayerPostInit_Soft = function(common, master)
    if common ~= nil then
        AddComponentPostInit("avengingghost", function(self) common(self.inst) end)
    end
    if master ~= nil then
        AddComponentPostInit("experiencecollector", function(self) master(self.inst) end)
    end
end


---@type table<string, function>
UTIL = {}

---@param obj table
---@param key string|integer
---@param prefn fun(...):(table|nil,boolean|nil,table|nil)|nil
---@param pstfn fun(table, ...):(any)|nil
---@param isSkipOld boolean|nil
---author: 绯世行
UTIL.FnExtend = function(obj, key, prefn, pstfn, isSkipOld)
    local oldval = obj[key]
    obj[key] = function(...)
        local rets, skipOldFlag, newparams, oldvalrets
        if prefn ~= nil then
            rets, skipOldFlag, newparams = prefn(...)
        end
        if type(oldval) == "function" and not skipOldFlag then
            if newparams ~= nil then
                oldvalrets = { oldval(unpack(newparams)) }
            else
                oldvalrets = { oldval(...) }
            end
            if not isSkipOld then
                rets = oldvalrets
            end
        end
        if pstfn ~= nil then
            rets = pstfn(rets, ...)
        end
        if rets == nil then
            return nil
        end
        return unpack(rets)
    end
end

---author: 绯世行
local GetUpvalue = function(fn, upvalname)
    local i = 1
    while true do
        local name, value = debug.getupvalue(fn, i)
        if not name then break end
        if name == upvalname then
            return value, i
        end
        i = i + 1
    end
end

---@param fn function
---@param ... string
---@return any
---@return integer|nil
---@return function|nil
UTIL.GetUpvalue = function(fn, ...)
    local val, i, caller = fn, nil, nil
    for _, name in ipairs { ... } do
        caller, val, i = val, GetUpvalue(val, name)
        if i == nil then
            return nil
        end
    end
    return val, i, caller
end

UTIL.VoidFn = function() end

---------------------------------------------
---                GLOBAL                 ---
---------------------------------------------
---@param t class
---@param k string
---@return function|nil
getsetter = function(t, k)
    local _ = rawget(t, "_")
    assert(_ ~= nil, "Class does not support property setters")
    local p = _[k]
    if p ~= nil then
        return p[2]
    end
end
GLOBAL.getsetter = getsetter

tracestack = function()
    local str = "[Trace stack]"
    local level = 2

    while true do
        local info = debug.getinfo(level, "Snl")
        if not info then break end

        local source = info.source
        if source:sub(1, 1) == "@" then
            source = source:sub(2)
        end

        local func_name = info.name or "<anonymous>"
        local line = info.currentline or 0
        local func_type = info.what

        str = str ..
            "\n        " ..
            string.format("[#%d] %20s:%3d in function '%s' (%s)", level - 1, source, line, func_name, func_type)

        level = level + 1
    end
    print(str)
end
GLOBAL.tracestack = tracestack

local debugprintf = function(fmt, ...)
    print(string.format("[DEBUG] " .. fmt, ...))
end
GLOBAL.debugprintf = debugprintf

---@param pos Vector3
---@param radius number
---@param ignoreheight boolean|nil
---@param musttags table|nil
---@param canttags table|nil
---@param mustoneoftags table|nil
---@param fn function|nil
---@return ent|nil
---@return number|nil
FindClosestEntityInPoint = function(pos, radius, ignoreheight, musttags, canttags, mustoneoftags, fn)
    if pos ~= nil then
        local x, y, z = pos:Get()
        local ents = TheSim:FindEntities(x, ignoreheight and 0 or y, z, radius, musttags, canttags, mustoneoftags)
        local closestEntity = nil
        local rangesq = radius * radius
        for i, v in ipairs(ents) do
            if (not IsEntityDeadOrGhost(v)) and v.entity:IsVisible() and (fn == nil or fn(v, pos)) then
                local distsq = v:GetDistanceSqToPoint(x, y, z)
                if distsq < rangesq then
                    rangesq = distsq
                    closestEntity = v
                end
            end
        end
        return closestEntity, closestEntity ~= nil and rangesq or nil
    end
end
GLOBAL.FindClosestEntityInPoint = FindClosestEntityInPoint

Round2Quarter = function(n)
    local int_part = math.floor(n)
    local frac_part = n - int_part
    local rounded_frac = math.floor(frac_part * 4 + 0.5) / 4
    if rounded_frac >= 1 then
        return int_part + 1
    else
        return int_part + rounded_frac
    end
end
GLOBAL.Round2Quarter = Round2Quarter

pairs_v = function(t)
    local function iter(tbl, key)
        local k, v = next(tbl, key)
        if k == nil then return nil end
        if type(v) == "table" and v.entity and not GLOBAL.Entity.IsValid(v.entity) then
            tbl[k] = nil
            return iter(tbl, k)
        end
        return k, v
    end
    return iter, t, nil
end
GLOBAL.pairs_v = pairs_v

ipairs_v = function(t)
    local wptr = 1
    local n = #t
    for rptr = 1, n do
        local v = t[rptr]
        if type(v) == "table" and v.entity and not GLOBAL.Entity.IsValid(v.entity) then
            if wptr ~= rptr then
                t[wptr] = v
            end
            wptr = wptr + 1
        end
    end
    for i = wptr, n do
        t[i] = nil
    end
    return ipairs(t)
end
GLOBAL.ipairs_v = ipairs_v

rebuildsetter = function(t, k, prefn, pstfn, isSkipOld)
    local _ = rawget(t, "_")
    assert(_ ~= nil, "Class does not support property setters")
    if not _[k] then _[k] = {} end
    UTIL.FnExtend(_[k], 2, prefn, pstfn, isSkipOld)
end
GLOBAL.rebuildsetter = rebuildsetter
---------------------------------------------
---              DEPRECATED               ---
---------------------------------------------
--[[
---@param inst ent
---@param ccmp string
---@return table|nil
AddComponentProxy = function(inst, ccmp) -- WARNING! IF USE "inst[ccmp]" as a param, it would not return the real component.
    local gccmp = rawget(GLOBAL, FirstToUpper(ccmp))
    if type(inst[ccmp]) ~= "userdata" and gccmp == nil then return end
    inst[ccmp] = setmetatable({
        self = inst[ccmp],
        _ = {},
    }, {
        __newindex = function(t, k, v)
            --debugprintf("NEWINDEX %s %s %s", tostring(t), tostring(k), tostring(v))
            if type(v) == "function" then
                return rawset(t._, k, function(self, ...)
                    return v(self.self, ...)
                end)
            end
            return rawset(t, k, v)
        end,
        __index = function(t, k)
            local v = rawget(t._, k)
            if v ~= nil then return v end
            v = rawget(gccmp, k)
            if type(v) == "function" then
                --debugprintf("INDEX %s %s", tostring(t), tostring(k))
                rawset(t._, k, function(self, ...)
                    return v(self.self, ...)
                end)
                return rawget(t._, k)
            end
            return rawget(t, k)
        end
    })
    return inst[ccmp]
end
GLOBAL.AddComponentProxy = AddComponentProxy
]]
