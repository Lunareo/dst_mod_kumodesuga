---@class replica_components
---@field godspunable replica_godspunable

STRINGS.NAMES.GODSPUNITEM = "神织 {obj}"

local function GetDisplayName(inst, displaynamefn, ...)
    return (displaynamefn ~= nil and displaynamefn(inst, ...))
        or (inst.nameoverride ~= nil and STRINGS.NAMES[string.upper(inst.nameoverride)])
        or (inst.name_author_netid ~= nil and ApplyLocalWordFilter(inst.name, TEXT_FILTER_CTX_CHAT, inst.name_author_netid))
        or inst.name
end


---@class replica_godspunable: replica_base
---@field _upgraded net_bool
local GodSpunable = Class(function(self, inst)
    self.inst = inst
    self._upgraded = net_bool(inst.GUID, "godspunable.upgraded")
    self.olddisplaynamefn = inst.displaynamefn
    inst.displaynamefn = function(_inst)
        local str = GetDisplayName(_inst, self.olddisplaynamefn)
        if self._upgraded and self._upgraded:value() == true then
            return subfmt(STRINGS.NAMES.GODSPUNITEM, { obj = str })
        end
        return str
    end
end)

return GodSpunable
