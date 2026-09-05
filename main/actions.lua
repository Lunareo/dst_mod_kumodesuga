---@class ACTIONS
---@field PARRY actiondata
---@field SPELL actiondata
---@field UNSPELL actiondata
---@field TRANSFER actiondata
---@field TRANSFER_MAP actiondata

local ACTION_PARRY = AddAction(
    "PARRY",
    STRINGS.ACTIONS.PARRY,
    function(act)
        local inst = act.doer
        if inst ~= nil and inst.components.attackdodger then
            inst.components.attackdodger.dodgetimestamp = GetTime()
            return true
        end
        return false
    end
)

ACTION_PARRY.priority = 10
ACTION_PARRY.rmb = true
ACTION_PARRY.distance = 36
ACTION_PARRY.mount_valid = false

local parryhandler = ActionHandler(ACTION_PARRY, "doshortaction")

AddStategraphActionHandler("wilson", parryhandler)
AddStategraphActionHandler("wilson_client", parryhandler)

local TRANSFER_MAGICPOINT_COST = 3
local TRANSFER_MAP_MAGICPOINT_PER_SEGMENT = 3
local TRANSFER_MAP_DISTANCE_SEGMENT = 80

---@param doer ent
---@return number|nil
local function GetMagicPointCurrent(doer)
    if doer == nil then
        return nil
    end
    local magicpoint = doer.components and doer.components.magicpoint
    if magicpoint ~= nil then
        return magicpoint:GetCurrent()
    end
    local replica = doer.replica and doer.replica.magicpoint
    if replica ~= nil and replica.GetCurrent ~= nil then
        return replica:GetCurrent()
    end
    return nil
end

---@param doer ent
---@param cost number
---@return boolean
local function CanAffordMagicPointCost(doer, cost)
    if cost == nil or cost <= 0 then
        return true
    end
    local current = GetMagicPointCurrent(doer)
    if current == nil then
        -- Replication may not be attached yet; let the server perform the authoritative check.
        return true
    end
    return current >= cost
end

---@param doer ent
---@param cost number
---@return boolean
local function TryConsumeTransferMagicPoint(doer, cost)
    local magicpoint = doer and doer.components and doer.components.magicpoint
    return magicpoint ~= nil and magicpoint:Cost(cost)
end

---@param doer ent
---@param pos Vector3
---@return number
local function GetTransferMapMagicPointCost(doer, pos)
    local dist = doer:GetDistanceSqToPoint(pos:Get())
    dist = math.sqrt(dist)
    -- Every 80 units (or any remainder) costs 3 magic points; minimum one segment.
    local segments = math.max(1, math.ceil(dist / TRANSFER_MAP_DISTANCE_SEGMENT))
    return segments * TRANSFER_MAP_MAGICPOINT_PER_SEGMENT
end

---@param doer ent
---@return boolean
local function HasSpaceMotor(doer)
    local skilltreeupdater = doer and doer.components.skilltreeupdater
    if skilltreeupdater == nil then
        return false
    end
    if skilltreeupdater:IsActivated("spacemotor") then
        return true
    end
    -- Tag fallback (activated skills with the spacemotor tag).
    return skilltreeupdater.HasSkillTag ~= nil and skilltreeupdater:HasSkillTag("spacemotor")
end

--- Land / boat, or open ocean only with spacemotor.
---@param doer ent
---@param pos Vector3
---@return boolean
local function CanTransferToPoint(doer, pos)
    if doer == nil or pos == nil then
        return false
    end
    local x, y, z = pos:Get()
    -- Open ocean (not land overhang, not a boat): require spacemotor.
    if TheWorld.Map:IsOceanAtPoint(x, y, z, false) then
        return HasSpaceMotor(doer)
    end
    -- Also treat non-passable ocean tiles the same (defensive).
    if TheWorld.Map:IsOceanTileAtPoint(x, y, z)
        and not TheWorld.Map:IsPassableAtPoint(x, y, z)
        and TheWorld.Map:GetPlatformAtPoint(x, z) == nil then
        return HasSpaceMotor(doer)
    end
    return TheWorld.Map:IsPassableAtPoint(x, y, z)
end

--- Whether far-transfer may be shown / remapped (destination + affordability).
---@param doer ent
---@param pos Vector3
---@return boolean
local function CanShowTransferMap(doer, pos)
    if doer == nil or pos == nil or not CanTransferToPoint(doer, pos) then
        return false
    end
    return CanAffordMagicPointCost(doer, GetTransferMapMagicPointCost(doer, pos))
end

local ACTION_TRANSFER = AddAction(
    "TRANSFER",
    STRINGS.ACTIONS.TRANSFER,
    function(act)
        local pos = act.pos and act.pos:GetPosition()
        local doer = act and act.doer
        local skilltreeupdater = doer and doer.components.skilltreeupdater
        if skilltreeupdater and skilltreeupdater:IsActivated("spacemagic_2") and CanTransferToPoint(doer, pos) then
            local maxdist = 48
            if doer:GetDistanceSqToPoint(pos:Get()) > maxdist * maxdist then
                return false
            end
            if not TryConsumeTransferMagicPoint(doer, TRANSFER_MAGICPOINT_COST) then
                return false
            end
            doer:ForceFacePoint(pos:Get())
            doer.Physics:Teleport(pos:Get())
            return true
        end
    end
)
ACTION_TRANSFER.priority = 10
ACTION_TRANSFER.rmb = true
ACTION_TRANSFER.distance = 48
-- Teleport action: never pathfind (ocean destinations are unpathable).
ACTION_TRANSFER.do_not_locomote = true
-- Floating on ocean otherwise filters out non-floating_valid actions.
ACTION_TRANSFER.floating_valid = true

local ACTION_TRANSFER_MAP = AddAction(
    "TRANSFER_MAP",
    STRINGS.ACTIONS.TRANSFER_MAP,
    function(act)
        local pos = act.pos and act.pos:GetPosition()
        local doer = act and act.doer
        local skilltreeupdater = doer and doer.components.skilltreeupdater
        if skilltreeupdater and skilltreeupdater:IsActivated("spacemagic_3") and pos and CanTransferToPoint(doer, pos) then
            local cost = GetTransferMapMagicPointCost(doer, pos)
            if not TryConsumeTransferMagicPoint(doer, cost) then
                return false
            end
            doer:ForceFacePoint(pos:Get())
            doer.Physics:Teleport(pos:Get())
            return true
        end
    end
)
ACTION_TRANSFER_MAP.priority = 10
ACTION_TRANSFER_MAP.rmb = true
ACTION_TRANSFER_MAP.do_not_locomote = true
ACTION_TRANSFER_MAP.map_action = true
ACTION_TRANSFER_MAP.map_only = true
ACTION_TRANSFER_MAP.closes_map = true
ACTION_TRANSFER_MAP.floating_valid = true
-- RemapMapAction accepts any ocean tile for map_only actions; re-check destination + cost.
ACTION_TRANSFER_MAP.maponly_checkvalidpos_fn = function(act)
    local doer = act and act.doer
    local pos = act and act.pos and act.pos:GetPosition()
    if doer == nil or pos == nil or not CanShowTransferMap(doer, pos) then
        return false
    end
    return true, nil, pos.x, pos.z
end
ACTION_TRANSFER_MAP.stroverridefn = function(act)
    local doer = act and act.doer
    local pos = act and act.pos and act.pos:GetPosition()
    if doer == nil or pos == nil then
        return nil
    end
    local cost = GetTransferMapMagicPointCost(doer, pos)
    local fmt = STRINGS.ACTIONS.TRANSFER_MAP_COST or "{cost}"
    return subfmt(fmt, { cost = cost })
end

---@param act BufferedAction
---@param pos Vector3
ACTIONS_MAP_REMAP[ACTION_TRANSFER.code] = function(act, pos)
    local doer = act and act.doer
    -- Far-transfer remap also requires Alt (FORCE_INSPECT), same as short transfer.
    local pc = doer and doer.components.playercontroller
    if pc == nil or not pc:IsControlPressed(CONTROL_FORCE_INSPECT) then
        return nil
    end
    local skilltreeupdater = doer.components.skilltreeupdater
    if skilltreeupdater and skilltreeupdater:IsActivated("spacemagic_3") and CanShowTransferMap(doer, pos) then
        return BufferedAction(doer, nil, ACTIONS.TRANSFER_MAP, nil, pos)
    end
    return nil
end

STRINGS.ACTIONS.WEAVE = "再织"

---@class ACTIONS
---@field WEAVE ACTION_WEAVE

---@class ACTION_WEAVE: actiondata
local ACTION_WEAVE = AddAction(
    "WEAVE",
    STRINGS.ACTIONS.WEAVE,
    function (act)
        if act.doer.components.skilltreeupdater:IsActivated("shiro_evolution_arachne")
            and act.invobject ~= nil and act.target ~= nil then
            if act.invobject:HasTag("reweaver") and act.target.replica.godspunable
                and act.target.components.godspunable.upgraded ~= true then
                act.target.components.godspunable:Upgrade()
                if act.invobject.components.stackable ~= nil then
                    act.invobject.components.stackable:Get():Remove()
                else
                    act.invobject:Remove()
                end
                return true
            end
        end
    end
)
ACTION_WEAVE.priority = 10
ACTION_WEAVE.mount_valid = true
ACTION_WEAVE.rmb = true

-- Shared helpers for character pointspecial (client + server).
KMDS = rawget(_G, "KMDS") or {}
KMDS.GetTransferMapMagicPointCost = GetTransferMapMagicPointCost
KMDS.CanAffordMagicPointCost = CanAffordMagicPointCost
KMDS.CanShowTransferMap = CanShowTransferMap
KMDS.CanTransferToPoint = CanTransferToPoint
rawset(_G, "KMDS", KMDS)

-- postinits

UTIL.FnExtend(ACTIONS.USESPELLBOOK, "strfn", function(act, ...) ---@param act BufferedAction
    if act and act.doer and act.doer:HasTag("MA_spellcaster") and act.invobject == nil then
        return { "CASTSPELL" }, true
    end
end)
