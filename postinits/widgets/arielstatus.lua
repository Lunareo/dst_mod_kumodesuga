local StatusDisplays = require "widgets/statusdisplays"
local Badge = require "widgets/badge"

local TINT = { 180 / 255, 70 / 255, 40 / 255, 1 }

local function AddGluttony(self, owner)
    if self.gluttony ~= nil then return end
    self.gluttony = self:AddChild(Badge(nil, owner, TINT, "status_hunger", nil, nil, true))
    self.gluttony:SetPosition(self.stomach:GetPosition() * 2 - self.heart:GetPosition())
    local function refresh()
        if self.gluttony == nil or not owner:IsValid() then return end
        local current = owner._arielpool ~= nil and owner._arielpool:value() or 0
        local max = owner._arielmax ~= nil and owner._arielmax:value() or 0
        if max > 0 then self.gluttony:SetPercent(current / max, max) end
        self.gluttony:SetTooltip(string.format(STRINGS.ARIEL.POOL, current, max,
            owner._arielwear:value(), STRINGS.ARIEL.STANCES[owner._arielstance:value() + 1]))
    end
    -- 监听归属 UI 实体，HUD 销毁时引擎自动解除，不在玩家身上遗留旧 Widget 闭包。
    self.inst:ListenForEvent("arieldirty", refresh, owner)
    self.inst:DoTaskInTime(0, refresh)
    if self.isghostmode then self.gluttony:Hide() end
end

UTIL.FnExtend(StatusDisplays, "_ctor", nil, function(_, self, owner)
    if owner ~= nil and owner.prefab == "ariel" then AddGluttony(self, owner) end
end)

UTIL.FnExtend(StatusDisplays, "SetGhostMode", nil, function(_, self, ghostmode)
    if self.gluttony == nil then return end
    if ghostmode then self.gluttony:Hide() else self.gluttony:Show() end
end)
