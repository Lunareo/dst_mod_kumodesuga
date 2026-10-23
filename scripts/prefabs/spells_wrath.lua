local function CanCastRage(owner)
    if owner.components.wrathstate ~= nil then
        return owner.components.wrathstate:CanRage() or owner.components.wrathstate.is_raging
    end
    return false
end

local function CanCastEnma(owner)
    if owner.components.wrathstate ~= nil then
        return owner.components.wrathstate:CanEnma()
    end
    return false
end

local function CanQuickDraw(owner)
    local updater = owner.components.skilltreeupdater
    return updater ~= nil and updater:IsActivated("wrath_quick_draw")
end

return function(owner)
    local items = {}

    -- 1. 愤怒 (Wrath / Rage)
    local is_raging = owner.components.wrathstate and owner.components.wrathstate.is_raging
    local rage_label = is_raging and (STRINGS.WRATH and STRINGS.WRATH.SPELLS and STRINGS.WRATH.SPELLS.STOP_RAGE or "解除愤怒")
        or (STRINGS.WRATH and STRINGS.WRATH.SPELLS and STRINGS.WRATH.SPELLS.RAGE or "恶鬼之怒")

    items[#items + 1] = {
        label = rage_label,
        bank = "spell_icons_shiro",
        build = "spell_icons_shiro",
        anims = {
            idle = { anim = "eye_of_destroy" },
            focus = { anim = "eye_of_destroy_focus", loop = true },
            down = { anim = "eye_of_destroy" },
            disabled = { anim = "eye_of_destroy_disabled" },
        },
        widget_scale = .45,
        onselect = function(inst)
            if TheWorld.ismastersim then
                if inst.components.wrathstate ~= nil then
                    if inst.components.wrathstate.is_raging then
                        inst.components.wrathstate:StopRage(false)
                    else
                        inst.components.wrathstate:StartRage()
                    end
                end
            else
                SendModRPCToServer(GetModRPC("kmds.spells", "spells.wrath_rage"))
            end
        end,
        execute = function(inst)
            if TheWorld.ismastersim then
                if inst.components.wrathstate ~= nil then
                    if inst.components.wrathstate.is_raging then
                        inst.components.wrathstate:StopRage(false)
                    else
                        inst.components.wrathstate:StartRage()
                    end
                end
            else
                SendModRPCToServer(GetModRPC("kmds.spells", "spells.wrath_rage"))
            end
        end,
    }

    -- 2. 断罪之火·阎魔 (Enma) - 需技能树解锁
    local updater = owner.components.skilltreeupdater
    if updater ~= nil and updater:IsActivated("wrath_enma") then
        local enma_label = STRINGS.WRATH and STRINGS.WRATH.SPELLS and STRINGS.WRATH.SPELLS.ENMA or "断罪之火·阎魔"
        items[#items + 1] = {
            label = enma_label,
            bank = "spell_icons_shiro",
            build = "spell_icons_shiro",
            anims = {
                idle = { anim = "eye_of_curse" },
                focus = { anim = "eye_of_curse_focus", loop = true },
                down = { anim = "eye_of_curse" },
                disabled = { anim = "eye_of_curse_disabled" },
            },
            widget_scale = .45,
            onselect = function(inst)
                if TheWorld.ismastersim then
                    if inst.components.wrathstate ~= nil then
                        inst.components.wrathstate:StartEnma()
                    end
                else
                    SendModRPCToServer(GetModRPC("kmds.spells", "spells.wrath_enma"))
                end
            end,
            execute = function(inst)
                if TheWorld.ismastersim then
                    if inst.components.wrathstate ~= nil then
                        inst.components.wrathstate:StartEnma()
                    end
                else
                    SendModRPCToServer(GetModRPC("kmds.spells", "spells.wrath_enma"))
                end
            end,
        }
    end

    -- 3. 快速拔刀 (Quick Draw) - 需技能树解锁
    if updater ~= nil and updater:IsActivated("wrath_quick_draw") then
        local draw_label = STRINGS.WRATH and STRINGS.WRATH.SPELLS and STRINGS.WRATH.SPELLS.QUICK_DRAW or "快速拔刀"
        items[#items + 1] = {
            label = draw_label,
            bank = "spell_icons_shiro",
            build = "spell_icons_shiro",
            anims = {
                idle = { anim = "eye_of_freeze" },
                focus = { anim = "eye_of_freeze_focus", loop = true },
                down = { anim = "eye_of_freeze" },
                disabled = { anim = "eye_of_freeze_disabled" },
            },
            widget_scale = .45,
            onselect = function(inst)
                if not TheWorld.ismastersim then
                    SendModRPCToServer(GetModRPC("kmds.spells", "spells.wrath_quick_draw"))
                else
                    -- 服务端直接执行切刀
                    local inv = inst.components.inventory
                    if inv ~= nil then
                        local hand = inv:GetEquippedItem(EQUIPSLOTS.HANDS)
                        local is_magic_sword = hand and (hand.prefab == "flame_sword" or hand.prefab == "lightning_sword" or hand.prefab == "explosive_sword" or hand.prefab == "lightning_grid_sword" or hand.prefab == "goblin_dagger")
                        local target_weapon = nil
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
                            inst.components.combat.min_attack_period = 0.4
                            inst:DoTaskInTime(2, function()
                                if inst:IsValid() and not (inst.components.wrathstate and inst.components.wrathstate.is_raging) then
                                    inst.components.combat.min_attack_period = nil
                                end
                            end)
                        end
                    end
                end
            end,
            execute = function(inst)
                if not TheWorld.ismastersim then
                    SendModRPCToServer(GetModRPC("kmds.spells", "spells.wrath_quick_draw"))
                end
            end,
        }
    end

    return items
end
