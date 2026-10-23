local skillhashes = {
    [hash("nightvision")] = "nightvision",
    [hash("skanda")] = "skanda",
}

--AddModRPCHandler("kmds.skills", "skills.updating", function(player, skillhash, update)
--    if player == nil or player.components == nil then return end
--    local skillname = skillhashes[skillhash]
--    if skillname == nil then return end
--    local skill = player.components[skillname]
--    if skill == nil or type(skill.Enable) ~= "function" then return end
--    skill:Enable(update)
--end)

local SKILL_UTIL = require "prefabs/playerskillutil"
AddModRPCHandler("kmds.toggleskill", "skills.toggle", SKILL_UTIL.Toggle)

---@param player ent
---@return boolean|nil
local function HasSpaceMotor(player)
    local skilltreeupdater = player.components and player.components.skilltreeupdater
    if skilltreeupdater == nil then
        return false
    end
    if skilltreeupdater:IsActivated("spacemotor") then
        return true
    end
    return skilltreeupdater.HasSkillTag ~= nil and skilltreeupdater:HasSkillTag("spacemotor")
end

--- Whether the player may open space_proxy at their current location.
--- Land / boat: always (with spacemagic). Open ocean: only with spacemotor.
---@param player ent
---@return boolean|nil
local function CanOpenSpaceProxyHere(player)
    local x, y, z = player.Transform:GetWorldPosition()
    if TheWorld.Map:IsOceanAtPoint(x, y, z, false) then
        return HasSpaceMotor(player)
    end
    -- Ocean tile, not passable, no boat: treat like open ocean.
    if TheWorld.Map:IsOceanTileAtPoint(x, y, z)
        and not TheWorld.Map:IsPassableAtPoint(x, y, z)
        and TheWorld.Map:GetPlatformAtPoint(x, z) == nil then
        return HasSpaceMotor(player)
    end
    return true
end

--- Spawn position for space_proxy near the player.
--- Without spacemotor: land / boat only (original FindWalkableOffset rules).
--- With spacemotor: also allow ocean tiles / facing fallback on open sea.
---@param player ent
---@return Vector3|nil
local function GetSpaceProxySpawnPos(player)
    local pos = player:GetPosition()
    local has_motor = HasSpaceMotor(player)

    -- 1) Land or boat (same as pre-ocean fix for non-motor players).
    local offset = FindWalkableOffset(pos, math.random() * PI2, .5, 8, nil, nil, nil, false, true)
    if offset ~= nil then
        return pos + offset
    end

    if not has_motor then
        -- No walkable land/boat nearby and no spacemotor → refuse.
        return nil
    end

    -- 2) Spacemotor: allow water tiles.
    offset = FindWalkableOffset(pos, math.random() * PI2, .5, 8, nil, nil, nil, true, true)
    if offset ~= nil then
        return pos + offset
    end

    -- 3) Open ocean fallback: in front of the player (visual only).
    local angle = (player.Transform:GetRotation() or 0) * DEGREES
    return Vector3(pos.x + math.cos(angle) * 0.5, pos.y, pos.z - math.sin(angle) * 0.5)
end

AddModRPCHandler("kmds.spells", "spells.open_space_proxy", function(player) ---@param player avatar_shiro
    if player == nil or not player:IsValid() then
        return
    end
    if player.space_proxy ~= nil then
        return
    end
    local skilltreeupdater = player.components and player.components.skilltreeupdater
    if skilltreeupdater == nil or not skilltreeupdater:IsActivated("spacemagic_1") then
        return
    end
    if not CanOpenSpaceProxyHere(player) then
        return
    end
    -- Need a real pocket container to bind as master.
    local space = player._other_space
    if space == nil or not space:IsValid() or space.components.container == nil then
        return
    end

    local pos = GetSpaceProxySpawnPos(player)
    if pos == nil then
        return
    end
    local proxy = SpawnAt("space_proxy", pos) ---@class prefab_space_proxy
    if proxy == nil then
        return
    end
    proxy:AttachOwner(player)
    if proxy.components.container_proxy ~= nil then
        proxy.components.container_proxy:Open(player)
    end
end)

AddModRPCHandler("kmds.spells", "spells.dismount", function(player) ---@param player ent
    if player == nil or not player:IsValid() then
        return
    end
    local rider = player.components and player.components.rider
    if rider ~= nil and rider:IsRiding() then
        -- Dismount 只是推 "dismount" 事件，交给 SG 走完整的下坐骑动作。
        rider:Dismount()
    end
end)

AddModRPCHandler("kmds.spells", "spells.create_clone", function(player)
    if player == nil or not player:IsValid() or not player:HasTag("shiro") then
        return
    end
    if player.components.magicpoint == nil or not player.components.magicpoint:Cost(TUNING.SPELL_CREATE_CLONE_COST) then
        return
    end
    local item = SpawnPrefab("shiro_clone_item")
    if item ~= nil then
        if player.components.inventory ~= nil then
            player.components.inventory:GiveItem(item)
        end
        SpawnAt("statue_transition_2", player)
    end
end)

AddModRPCHandler("kmds.spells", "spells.wrath_rage", function(player)
    if player == nil or not player:IsValid() or not player:HasTag("wrath") then return end
    if player.components.wrathstate ~= nil then
        if player.components.wrathstate.is_raging then
            player.components.wrathstate:StopRage(false)
        else
            player.components.wrathstate:StartRage()
        end
    end
end)

AddModRPCHandler("kmds.spells", "spells.wrath_enma", function(player)
    if player == nil or not player:IsValid() or not player:HasTag("wrath") then return end
    if player.components.wrathstate ~= nil then
        player.components.wrathstate:StartEnma()
    end
end)

AddModRPCHandler("kmds.spells", "spells.wrath_quick_draw", function(player)
    if player == nil or not player:IsValid() or not player:HasTag("wrath") then return end
    local inv = player.components.inventory
    if inv ~= nil then
        local hand = inv:GetEquippedItem(EQUIPSLOTS.HANDS)
        local target_weapon = nil
        -- 如果当前拿的是魔剑或小刀，优先切武士刀；如果拿的是武士刀或非魔剑，优先切魔剑
        local is_magic_sword = hand and (hand.prefab == "flame_sword" or hand.prefab == "lightning_sword" or hand.prefab == "explosive_sword" or hand.prefab == "lightning_grid_sword" or hand.prefab == "goblin_dagger")
        for k, v in pairs(inv.itemslots) do
            if v ~= nil and v.components.equippable ~= nil and v.components.equippable.equipslot == EQUIPSLOTS.HANDS then
                if is_magic_sword and v.prefab == "katana_wrath" then
                    target_weapon = v
                    break
                elseif not is_magic_sword and (v.prefab == "flame_sword" or v.prefab == "lightning_sword" or v.prefab == "explosive_sword" or v.prefab == "katana_wrath") then
                    target_weapon = v
                    break
                end
            end
        end
        if target_weapon ~= nil then
            inv:Equip(target_weapon)
            -- 切换后首刀攻速提升 20%
            player.components.combat.min_attack_period = 0.4
            player:DoTaskInTime(2, function()
                if player:IsValid() and not (player.components.wrathstate and player.components.wrathstate.is_raging) then
                    player.components.combat.min_attack_period = nil
                end
            end)
        end
    end
end)
