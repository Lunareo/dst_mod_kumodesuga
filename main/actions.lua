---@class ACTIONS
---@field PARRY actiondata
---@field SPELL actiondata
---@field UNSPELL actiondata
---@field TRANSFER actiondata
---@field TRANSFER_MAP actiondata

local Parry = AddAction(
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

Parry.priority = 10
Parry.rmb = true
Parry.distance = 36
Parry.mount_valid = false

local parryhandler = ActionHandler(Parry, "doshortaction")

AddStategraphActionHandler("wilson", parryhandler)
AddStategraphActionHandler("wilson_client", parryhandler)

local Transfer = AddAction(
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
Transfer.priority = 10
Transfer.rmb = true
Transfer.distance = 48

local Transfer_Map = AddAction(
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
Transfer_Map.rmb = true
Transfer_Map.do_not_locomote = true
Transfer_Map.map_action = true
Transfer_Map.map_only = true
Transfer_Map.closes_map = true

---@param act BufferedAction
---@param pos Vector3
ACTIONS_MAP_REMAP[Transfer.code] = function(act, pos)
    if act and act.doer and act.doer.components.skilltreeupdater:IsActivated("spacemagic_3") and
        pos and (act.doer.components.skilltreeupdater:IsActivated("spacemotor") or
            TheWorld.Map:IsAboveGroundAtPoint(pos:Get())) then
        return BufferedAction(act.doer, nil, ACTIONS.TRANSFER_MAP, nil, pos)
    end
    return nil
end
