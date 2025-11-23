local ICON_SCALE = 0.6
local spells_common = require "prefabs/spells_common"
local AutoToggleWidget, AbsorbSingleTargetSkill = spells_common.AutoToggleWidget, spells_common.AbsorbSingleTargetSkill

---@class ThePlayer
---@field _toggle_nightvision netvar|nil

local function isNightVisionActivated()
    return ThePlayer and ThePlayer.components.nightvision and ThePlayer.components.nightvision.update:value()
end

local SPELL_FNS = {
    freeze = function(target, doer)
        target:AddDebuff("freeze", "buff_freeze", { doer = doer })
    end,
    gravity = function(target, doer)
        local sh = SpawnAt("daywalker_sinkhole", target)
        if sh then sh:DoTaskInTime(5, sh.Remove) end
    end,
}

return {
    {
        label = STRINGS.SPELLS.TOGGLENIGHTVISION,
        onselect = function(inst)
            inst.components.spellbook.closeonexecute = false
        end,
        execute = function(inst)
            SendModRPCToServer(GetModRPC("kmds.skills", "skills.updating"), hash("nightvision"))
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
    AbsorbSingleTargetSkill{
        name = "freeze",
        spellfn = SPELL_FNS.freeze,
    },
    AbsorbSingleTargetSkill{
        name = "gravity",
        spellfn = SPELL_FNS.gravity,
    },
}
