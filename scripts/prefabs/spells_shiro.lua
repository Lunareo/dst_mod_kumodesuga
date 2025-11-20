local ICON_SCALE = 0.6
local spells_common = require "prefabs/spells_common"
local AutoToggleWidget = spells_common.AutoToggleWidget

---@class ThePlayer
---@field _toggle_nightvision netvar|nil

local function StartAOETargeting(inst)
    local playercontroller = ThePlayer.components.playercontroller
    if playercontroller ~= nil then
        playercontroller:StartAOETargetingUsing(inst)
    end
end

local function ReticuleTargetFn(inst)
    return Vector3(ThePlayer.entity:LocalToWorldSpace(7, 0.001, 0)) -- Raised this off the ground a touch so it wont have any z-fighting with the ground biome transition tiles.
end

local function isNightVisionActivated()
    return ThePlayer and ThePlayer.components.nightvision and ThePlayer.components.nightvision.update:value()
end

local CREATURES_MUST = { "_combat" }
local CREATURES_CAN  = { "monster", "smallcreature", "largecreature", "animal", "bigbernie", "character" }
local CREATURES_CANT = { "INLIMBO", "flight", "player", "ghost", "invisible", "noattack", "notarget" }

local function EndFreeze(target, physactive, canbepickedup)
    if target.Physics ~= nil then
        target.Physics:SetActive(true)
    end
    if target.AnimState ~= nil then
        target.AnimState:Resume()
    end
    if target.sg ~= nil then
        target.sg:Start()
    end
    if target.components.inventoryitem ~= nil then
        target.components.inventoryitem.canbepickedup = canbepickedup
    end
    target:RestartBrain("freezed")
end

local function StartFreeze(target)
    if target ~= nil then
        local physactive, canbepickedup
        if target.Physics ~= nil then
            physactive = target.Physics:IsActive()
            target.Physics:SetActive(false)
        end
        if target.AnimState ~= nil then
            target.AnimState:Pause()
        end
        if target.sg ~= nil then
            target.sg:Stop()
        end
        if target.components.inventoryitem ~= nil then
            canbepickedup, target.components.inventoryitem.canbepickedup = target.components.inventoryitem.canbepickedup,
                true
        end
        target:StopBrain("freezed")
        target:DoTaskInTime(3, EndFreeze, physactive, canbepickedup)
    end
end

local function FreezableTargetFn(inst, doer, pos)
    local target = FindClosestEntityInPoint(pos, 4, nil, CREATURES_MUST, CREATURES_CANT)
    StartFreeze(target)
end

return {
    {
        label = STRINGS.SPELLS.TOGGLENIGHTVISION,
        onselect = function(inst)
            inst.components.spellbook.closeonexecute = false
        end,
        execute = function(inst)
            SendModRPCToServer(GetModRPC("kmds.skills", "skills.updating"), hash("nightvision"))
            --SendModRPCToServer(GetModRPC("kmds.skills", "nightvision.update"))
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
    {
        label = STRINGS.SPELLS.FREEZE,
        onselect = function(inst)
            local spellbook = inst.components.spellbook
            spellbook:SetSpellName(STRINGS.SPELLS.FREEZE)
            inst.spellname = "freeze"
            spellbook:SetSpellAction(nil)
            local aoetargeting = inst.components.aoetargeting
            aoetargeting:SetRange(16)
            aoetargeting:SetDeployRadius(0)
            aoetargeting:SetShouldRepeatCastFn(function() return true end)
            aoetargeting.reticule.reticuleprefab = "reticuleabsorb"
            aoetargeting.reticule.targetfn = ReticuleTargetFn

            if TheWorld.ismastersim then
                inst.components.aoespell:SetSpellFn(FreezableTargetFn)
                spellbook:SetSpellFn(nil)
            end
        end,
        execute = StartAOETargeting,
        bank = "spell_icons_woby",
        build = "spell_icons_woby",
        anims =
        {
            idle = { anim = "working" },
            focus = { anim = "working_focus" },
            down = { anim = "working_pressed" },
        },
        widget_scale = ICON_SCALE,
    },
}
