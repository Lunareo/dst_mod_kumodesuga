local SPELLBOOK_RADIUS = 120

local function ReticuleTargetAllowWaterFn()
    local player = ThePlayer
    local ground = TheWorld.Map
    local pos = Vector3(0, 0, 0)
    --Cast range is 8, leave room for error
    --4 is the aoe range
    for r = 7, 0, -.25 do
        pos.x, pos.y, pos.z = player.entity:LocalToWorldSpace(r, 0, 0)
        if ground:IsPassableAtPoint(pos.x, 0, pos.z, true) and not ground:IsGroundTargetBlocked(pos) then
            return pos
        end
    end
    return pos
end

local function updatespells(inst)
    inst.components.spellbook:SetItems(require("prefabs/spells_" .. inst.prefab)(inst))
end

local function WatchSkillRefresh_Client(inst)
    inst:ListenForEvent("onactivateskill_client", updatespells)
    inst:ListenForEvent("ondeactivateskill_client", updatespells)
end

local function WatchSkillRefresh_Server(inst)
    inst:ListenForEvent("onactivateskill_server", updatespells)
    inst:ListenForEvent("ondeactivateskill_server", updatespells)
end

return function(inst)
    inst:AddTag("throw_line")

    local aoetargeting = inst:AddComponent("aoetargeting")
    aoetargeting:SetAllowWater(true)
    aoetargeting:SetRange(1)
    aoetargeting.reticule.targetfn = ReticuleTargetAllowWaterFn
    aoetargeting.reticule.validcolour = { 1, 1, 1, 1 }
    aoetargeting.reticule.invalidcolour = { .5, .5, .5, .9 }
    aoetargeting.reticule.ease = true
    aoetargeting.reticule.mouseenabled = true
    aoetargeting.reticule.twinstickmode = 1
    aoetargeting.reticule.twinstickrange = TUNING.WINONA_REMOTE_RANGE

    inst:AddComponent("spellbook")
    inst.components.spellbook:SetRadius(SPELLBOOK_RADIUS)
    inst.components.spellbook:SetFocusRadius(SPELLBOOK_RADIUS) --UIAnimButton don't use focus radius SPELLBOOK_FOCUS_RADIUS)

    inst:DoTaskInTime(0, updatespells)

    if not TheWorld.ismastersim then
        WatchSkillRefresh_Client(inst)
    end

    inst:AddComponent("aoespell")

    WatchSkillRefresh_Server(inst)
end
