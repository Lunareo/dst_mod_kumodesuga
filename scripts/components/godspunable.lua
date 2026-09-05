---@class components
---@field godspunable component_godspunable

---@param self component_godspunable
local function onchangeupgrade(self, old, new)
    if self.inst.replica.godspunable and self.inst.replica.godspunable._upgraded then
        self.inst.replica.godspunable._upgraded:set(self.upgraded)
    end
end

---@class component_godspunable: component_base
---@field inst ent
---@field upgraded boolean|nil
---@field onupgrade fun(inst:ent, fromload:boolean|nil)
---@field _skip_remove boolean
---@field _hooked boolean|nil
local GodSpunable = Class(function(self, inst)
    self.inst = inst
    self.upgraded = false
    self._skip_remove = false
    self._hooked = false
    --self.onupgrade = nil
end, nil, {
    upgraded = onchangeupgrade
})

---@param fromload boolean|nil
function GodSpunable:Upgrade(fromload)
    self.upgraded = true

    if not self._hooked then
        self._hooked = true

        local orig_remove = self.inst.Remove
        self.inst.Remove = function(inst)
            if not self._skip_remove then
                orig_remove(inst)
            end
        end

        if self.inst.components.armor then
            self.inst.components.armor:SetKeepOnFinished(true)
            local old_fn = self.inst.components.armor.onfinished
            self.inst.components.armor:SetOnFinished(function(inst)
                self._skip_remove = true
                if old_fn ~= nil then
                    old_fn(inst)
                end
                self._skip_remove = false
            end)
        end

        if self.inst.components.finiteuses then
            local old_fn = self.inst.components.finiteuses.onfinished
            self.inst.components.finiteuses:SetOnFinished(function(inst)
                self._skip_remove = true
                if old_fn ~= nil and old_fn ~= orig_remove then
                    old_fn(inst)
                end
                self._skip_remove = false
            end)
        end

        if self.inst.components.fueled then
            local old_fn = self.inst.components.fueled.depleted
            self.inst.components.fueled:SetDepletedFn(function(inst)
                self._skip_remove = true
                if old_fn ~= nil and old_fn ~= orig_remove then
                    old_fn(inst)
                end
                self._skip_remove = false
            end)
        end
    end

    if not self.inst.components.erosiondefense then
        self.inst:AddComponent("erosiondefense")
    end
    self.inst.components.erosiondefense:AddBonus(self.inst, 5, "godspun")
    if not self.inst.components.planardefense then
        self.inst:AddComponent("planardefense")
    end
    self.inst.components.planardefense:AddBonus(self.inst, 5, "godspun")

    if self.onupgrade then
        self.onupgrade(self.inst, fromload)
    end
end

---@param fn fun(inst:ent, fromload:boolean|nil)
function GodSpunable:SetOnUpgrade(fn)
    self.onupgrade = fn
end

function GodSpunable:OnSave(data)
    if self.upgraded == true then
        return {
            upgraded = self.upgraded
        }
    end
end

function GodSpunable:OnLoad(data)
    if data and data.upgraded then
        self:Upgrade(true)
    end
end

return GodSpunable
