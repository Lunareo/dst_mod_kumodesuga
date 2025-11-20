local UIAnim = require "widgets/uianim"
local Image = require "widgets/image"
local ICON_RADIUS = 60

local function SetupMouseOver(w)
    --V2C: using Image widget for mouseover hitbox, since anim hitbox is not accurate
    w.uianim:SetClickable(false)
    w.mouseover = w:AddChild(Image())
    w.mouseover:SetRadiusForRayTraces(ICON_RADIUS)
    w.mouseover:MoveToBack()
end

local function AutoToggleWidget(fn)
    return function(w)
        SetupMouseOver(w)
        w.ring = w:AddChild(UIAnim())
        w.ring:GetAnimState():SetBank("spell_icons_woby")
        w.ring:GetAnimState():SetBuild("spell_icons_woby")
        w.ring:GetAnimState():PlayAnimation("autocast_ring", true)
        w.ring.OnUpdate = function(ring, dt)
            if fn() then
                local anim = "autocast_ring"
                if not ring:GetAnimState():IsCurrentAnimation(anim) then
                    local frame = ring:GetAnimState():GetCurrentAnimationFrame()
                    ring:GetAnimState():PlayAnimation(anim, true)
                    ring:GetAnimState():SetFrame(frame)
                end
                ring:Show()
                w.overrideclicksound = "dontstarve/HUD/toggle_off"
            else
                ring:Hide()
                w.overrideclicksound = "dontstarve/HUD/toggle_on"
            end
        end
        w.OnShow = function(_w)
            _w.ring:StartUpdating()
        end
        w.OnHide = function(_w)
            _w.ring:StopUpdating()
        end
        if w.shown then
            w.ring:StartUpdating()
            w.ring:OnUpdate(0)
        end
    end
end

return {
    AutoToggleWidget = AutoToggleWidget,
}