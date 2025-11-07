---@diagnostic disable: inject-field
require("prefabs")
---@class Derive: Prefab
---@overload fun(parent: string, name: string, postfn: fun(inst:ent):(ent)|nil, assets:(table|nil), deps:(table|nil), force_path_search:any)
---@field derive string
---@field desc string
Derive = Class(Prefab, function(self, parent, name, postfn, assets, deps, force_path_search)
    local function fn()
        assert(GLOBAL.Prefabs[parent], string.format("Failed to derive %s from %s: Prefab %s doesn't exist yet",
            name, parent, parent))
        local inst = Prefabs[parent].fn()
        if postfn then
            postfn(inst)
        end
        return inst
    end
    deps = merge(deps, { parent })
    Prefab._ctor(self, name, fn, assets, deps, force_path_search)
    self.derive = parent
end)

function Derive:__tostring()
    return string.format("Prefab %s(derive from %s) - %s", self.name, self.derive, self.desc)
end

GLOBAL.Derive = Derive
