local ItemTile = require "widgets/itemtile"

local UIAnim = require "widgets/uianim"

function ItemTile:ToggleFlameFx()
    if self.item.prefab == "helheim_beyonder" and self.helflamefx == nil then
        self.helflamefx = self:AddChild(UIAnim())
        self.helflamefx:GetAnimState():SetBank("helheim_beyonder_fx")
        self.helflamefx:GetAnimState():SetBuild("helheim_beyonder_fx")
        self.helflamefx:GetAnimState():PlayAnimation("idle", true)
        self.helflamefx:GetAnimState():SetTime(math.random() * self.helflamefx:GetAnimState():GetCurrentAnimationTime())
        self.helflamefx:SetScale(.35)
        self.helflamefx:GetAnimState():AnimateWhilePaused(false)
        self.helflamefx:SetClickable(false)
        self.helflamefx:SetPosition(0, -25, 0)
    end
end

UTIL.FnExtend(ItemTile, "ToggleShadowFX",
    function(self)
        self:ToggleFlameFx()
    end)
