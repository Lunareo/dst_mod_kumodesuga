---@diagnostic disable: lowercase-global, undefined-global, redundant-return-value
---@type table<string, table>
local package_loaded = {}

---@param modulename string
---@param env_override table|nil
---@return any
modrequire = function(modulename, env_override)
    if package_loaded[modulename] == nil then
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

---@param cmp string
---@param fn fun(inst:ent):any
AddPlayerPostInitByComponent = function(cmp, fn)
    AddComponentPostInit(cmp, function(self)
        fn(self.inst)
    end)
end


---@type table<string, function>
UTIL = {}

---@param obj table
---@param key string
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
        if not skipOldFlag then
            if newparams ~= nil then
                oldvalrets = { oldval and oldval(unpack(newparams)) }
            else
                oldvalrets = { oldval and oldval(...) }
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

local function print_call_stack()
    print("\n[Trace stack]")
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

        print(string.format("[#%d] %20s:%3d in function '%s' (%s)", level - 1, source, line, func_name, func_type))

        level = level + 1
    end
end
GLOBAL.print_call_stack = print_call_stack

local debugprintf = function(fmt, ...)
    print(string.format("[DEBUG] " .. fmt, ...))
end
GLOBAL.debugprintf = debugprintf