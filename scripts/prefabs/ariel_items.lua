local Combat = require "ariel_combat"

local function TeamMeal(eater, kind)
    for _, player in ipairs(AllPlayers) do
        if Combat.IsAlive(player) and eater:IsNear(player, TUNING.ARIEL.meal_radius) then
            player:AddDebuff("ariel_" .. kind, "buff_ariel_" .. kind)
            if kind == "resist" and player ~= eater then
                player.components.health:DoDelta(20, false, "ariel_mushroommeal")
                player.components.sanity:DoDelta(15)
                player.components.hunger:DoDelta(20)
            end
        end
    end
end

local function Food(parent, name, health, hunger, sanity, onfood)
    return Derive(parent, name, function(inst)
        inst.nameoverride = nil
        if not TheWorld.ismastersim then return end
        inst.components.inspectable.nameoverride = nil
        inst.components.edible.healthvalue = health
        inst.components.edible.hungervalue = hunger
        inst.components.edible.sanityvalue = sanity
        inst.components.inventoryitem:ChangeImageName(parent)
        inst.components.edible:SetOnEatenFn(function(_, eater) onfood(eater) end)
    end, nil, { "buff_ariel_war", "buff_ariel_resist" })
end

local silk = Derive("silk", "ariel_puppetsilk", function(inst)
    inst.nameoverride = nil
    if TheWorld.ismastersim then
        inst.components.inspectable.nameoverride = nil
        inst.components.inventoryitem:ChangeImageName("silk")
    end
end)

local chair = Derive("wood_stool", "ariel_silkchair", function(inst)
    inst.nameoverride = nil
    inst.AnimState:SetMultColour(.95, .9, 1, 1)
    if not TheWorld.ismastersim then return end
    inst.components.inspectable.nameoverride = nil
    inst:DoPeriodicTask(1, function()
        local sitter = inst.components.sittable ~= nil and inst.components.sittable.occupier or nil
        if Combat.IsAlive(sitter) and not sitter.components.hunger:IsStarving() then
            sitter.components.hunger:DoDelta(-.5, true)
            sitter.components.health:DoDelta(TUNING.ARIEL.rest_health, true, "ariel_silkchair")
            sitter.components.sanity:DoDelta(TUNING.ARIEL.rest_sanity, true)
        end
    end)
end)

local bed = Derive("tent", "ariel_silkbed", function(inst)
    inst.nameoverride = nil
    inst.AnimState:SetMultColour(.95, .9, 1, 1)
    if not TheWorld.ismastersim then return end
    inst.components.inspectable.nameoverride = nil
    inst.components.sleepingbag.health_tick = TUNING.ARIEL.rest_health
    inst.components.sleepingbag.sanity_tick = TUNING.ARIEL.rest_sanity
end)

return silk, chair, bed,
    Food("meatballs", "ariel_battlemeal", 20, 100, 15, function(eater) TeamMeal(eater, "war") end),
    Food("shroomcake", "ariel_mushroommeal", 40, 75, 40, function(eater) TeamMeal(eater, "resist") end),
    Food("jellybean", "ariel_nurturemeal", 20, 37.5, 20, function(eater)
        if eater.components.arielgluttony ~= nil then eater.components.arielgluttony:Nurture() end
    end),
    MakePlacer("ariel_silkchair_placer", "wood_stool", "wood_stool", "idle"),
    MakePlacer("ariel_silkbed_placer", "tent", "tent", "idle")
