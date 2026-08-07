local SkillTreeBuilder = require "widgets/redux/skilltreebuilder"
---@class widget_TEMPLATES
---@field StandardCheckbox fun(onclick, size, init_checked, helptext, hovertext_info):widget_imagebutton
---@field OptionsLabelCheckbox fun(onclick, labeltext, checked, width_label, width_button, height, checkbox_size, spacing, font, font_size, horiz_offset, tooltip_text):widget_imagebutton
local TEMPLATE = require "widgets/redux/templates"

local SKILL_UTIL = require "prefabs/playerskillutil"

---@param player ent
---@param skill string
---@return boolean # new checked state
local function ToggleActive(player, skill)
    local classified = player and player.player_classified
    if classified == nil then return false end
    local coder = SKILL_UTIL.CODES[player.prefab] -- resolve the per-prefab code map
    if coder == nil or coder[skill] == nil then return false end
    SendModRPCToServer(MOD_RPC["kmds.toggleskill"]["skills.toggle"], coder[skill])
    return not SKILL_UTIL.IsActivate(player, skill)
end

---Create (or recreate) the toggle switch for one skill graphic.
---Kills any existing switch first, so it never stacks duplicates.
---@param self table SkillTreeBuilder
---@param skill string
---@param checked boolean
---@return widget_imagebutton|nil
local function CreateSwitch(self, skill, checked)
    local graphics = self.skillgraphics[skill]
    if graphics == nil or graphics._kmds_switchpos == nil then return nil end
    if graphics.switch ~= nil then
        graphics.switch:Kill()
        graphics.switch = nil
    end
    local switch = self:AddChild(TEMPLATE.StandardCheckbox(function()
        return ToggleActive(ThePlayer, skill)
    end, 36, checked))
    switch:SetPosition(graphics._kmds_switchpos[1], graphics._kmds_switchpos[2], 0)
    graphics.switch = switch
    return switch
end

---Sync switch visibility with the activation status computed by RefreshTree.
---Only calls Kill/AddChild/Hide here, never buildbuttons/RefreshTree,
---so it cannot re-enter the hooks; the guard flag is extra insurance.
---@param self table SkillTreeBuilder
local function SyncSwitches(self)
    if self._kmds_syncing_switches then return end
    self._kmds_syncing_switches = true

    local skilltreeupdater = nil
    if not (self.fromfrontend or self.readonly) then
        skilltreeupdater = ThePlayer and ThePlayer.components.skilltreeupdater or nil
    end

    for skill, graphics in pairs(self.skillgraphics) do
        local switch = graphics.switch
        if switch ~= nil then
            local activated = graphics.status ~= nil and graphics.status.activated == true
            local show = skilltreeupdater ~= nil and activated
            if show and not switch.shown then
                -- Just became visible: recreate so the checked state matches
                -- the current skillenabled flag.
                CreateSwitch(self, skill, SKILL_UTIL.IsActivate(ThePlayer, skill))
            elseif not show then
                switch:Hide()
            end
        end
    end

    self._kmds_syncing_switches = false
end

UTIL.FnExtend(SkillTreeBuilder, "buildbuttons", nil, function(rets, self, panel, pos, data, offset, root, ...)
    if self.fromfrontend or self.readonly then
        return
    end
    -- Create a switch for every candisable skill right after its button is built.
    -- It stays hidden until the skill is actually activated (see SyncSwitches).
    for skill, subdata in pairs(data) do
        if subdata.candisable then
            local graphics = self.skillgraphics[skill]
            if graphics ~= nil and graphics.switch == nil then
                -- Match the vanilla button position: (pos[1], pos[2] + offset).
                graphics._kmds_switchpos = { subdata.pos[1] + 15, subdata.pos[2] + offset - 15 }
                local switch = CreateSwitch(self, skill, SKILL_UTIL.IsActivate(ThePlayer, skill))
                if switch ~= nil then
                    switch:Hide()
                end
            end
        end
    end
    SyncSwitches(self)
end)

-- Every path that changes skill state (LearnSkill on button press, skill
-- selection, respec, xp events) funnels through RefreshTree, so syncing here
-- makes the switch appear the moment a skill button activates it.
UTIL.FnExtend(SkillTreeBuilder, "RefreshTree", nil, function(rets, self, skillschanged)
    SyncSwitches(self)
end)
