local skilltreedefs = require "prefabs/skilltree_defs"
local CODES = {
    shiro = {
        spacemotor = 1, skanda = 2, vision_enhance = 4,
    },
}

---Resolve a skill code (string name or numeric bit value) to its numeric bit value.
---@param player ent
---@param code number|string|nil
---@return number|nil
local function GetCode(player, code)
    local map = player and CODES[player.prefab]
    if map == nil then return nil end
    if type(code) == "number" then
        return code
    end
    return map[code]
end

---@param player ent
---@param code number|string|nil
---@return boolean
---@return net_ushortint|nil
local function IsActivate(player, code)
    local classified = player and player.player_classified or nil
    local flag = classified and classified.skillenabled or nil
    if flag == nil then return false end
    code = GetCode(player, code)
    if code == nil then return false end
    return bit.band(flag:value(), code) > 0, flag
end

---Only call by server
---@param player ent
---@param code number|string
local function Toggle(player, code)
    local ison, flag = IsActivate(player, code)
    if flag == nil then return false end
    local bitcode = GetCode(player, code)
    if bitcode == nil then return false end
    local skill = nil
    if type(code) == "string" then
        skill = code
    else
        local map = CODES[player.prefab]
        for name, value in pairs(map) do
            if value == code then
                skill = name
                break
            end
        end
    end
    if skill == nil then return false end
    local skilldef = skilltreedefs.SKILLTREE_DEFS[player.prefab] and
        skilltreedefs.SKILLTREE_DEFS[player.prefab][skill]
    if skilldef == nil then return false end
    if ison then
        skilldef.ondeactivate(player)
    else
        skilldef.onactivate(player)
    end
    flag:set(bit.bxor(flag:value(), bitcode))
    return ison
end

return {
    CODES = CODES,
    IsActivate = IsActivate,
    Toggle = Toggle,
}
