local UIAnim = require "widgets/uianim"
local Image = require "widgets/image"
local ICON_SCALE = 0.6
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

local function isNightVisionActivated()
    return ThePlayer and ThePlayer.replica.inventory and ThePlayer.replica.inventory:EquipHasTag("nightvision")
end

local function ToggleNightVision(player, equip)
    equip:AddOrRemoveTag("nightvision", not equip:HasTag("nightvision"))
    player:PushEvent("equip", { item = equip, eslot = equip.replica.equippable:EquipSlot(), no_animation = true })
end

AddModRPCHandler("Shiro_spell", "NightVision", ToggleNightVision)

return
{
    ToggleNightVision = {
        label = "NightVision",
        onselect = function(inst)
            inst.components.spellbook.closeonexecute = false
        end,
        execute = function(inst)
            ToggleNightVision(ThePlayer or inst.components.inventoryitem:GetGrandOwner(), inst)
            if not TheWorld.ismastersim then
                SendModRPCToServer(GetModRPC("Shiro_spell", "NightVision"), inst)
            end
        end,
        bank = "spell_icons_woby",
        build = "spell_icons_woby",
        anims =
        {
            idle = { anim = "working" },
            focus = { anim = "working_focus" },
            down = { anim = "working_pressed" },
        },
        widget_scale = ICON_SCALE,
        postinit = AutoToggleWidget(isNightVisionActivated),
    },
}

