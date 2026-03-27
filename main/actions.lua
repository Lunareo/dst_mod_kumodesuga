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

local ACTION_TRANSFER = AddAction(
    "TRANSFER",
    STRINGS.ACTIONS.TRANSFER,
    function(act)
        local pos = act.pos and act.pos:GetPosition()
        if act and act.doer and act.doer.components.skilltreeupdater:IsActivated("spacemagic_2") and pos then
            act.doer:ForceFacePoint(pos:Get())
            act.doer.Physics:Teleport(act.pos:GetPosition():Get())
            return true
        end
    end
)
ACTION_TRANSFER.priority = 10
ACTION_TRANSFER.rmb = true
ACTION_TRANSFER.distance = 48

local ACTION_TRANSFER_MAP = AddAction(
    "TRANSFER_MAP",
    STRINGS.ACTIONS.TRANSFER_MAP,
    function(act)
        local pos = act.pos and act.pos:GetPosition()
        if act and act.doer and act.doer.components.skilltreeupdater:IsActivated("spacemagic_3") and pos then
            act.doer:ForceFacePoint(pos:Get())
            act.doer.Physics:Teleport(pos:Get())
            return true
        end
    end
)
ACTION_TRANSFER_MAP.rmb = true
ACTION_TRANSFER_MAP.do_not_locomote = true
ACTION_TRANSFER_MAP.map_action = true
ACTION_TRANSFER_MAP.map_only = true
ACTION_TRANSFER_MAP.closes_map = true

---@param act BufferedAction
---@param pos Vector3
ACTIONS_MAP_REMAP[ACTION_TRANSFER.code] = function(act, pos)
    if act and act.doer and act.doer.components.skilltreeupdater:IsActivated("spacemagic_3") and
        pos and (act.doer.components.skilltreeupdater:IsActivated("spacemotor") or
            TheWorld.Map:IsAboveGroundAtPoint(pos:Get())) then
        return BufferedAction(act.doer, nil, ACTIONS.TRANSFER_MAP, nil, pos)
    end
    return nil
end

-- postinits

UTIL.FnExtend(ACTIONS.USESPELLBOOK, "strfn", function(act, ...) ---@param act BufferedAction
    if act.doer:HasTag("MA_spellcaster") and act.invobject == nil then
        return { "CASTSPELL" }, true
    end
end)
