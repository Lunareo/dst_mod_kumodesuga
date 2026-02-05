local is_character_ingredient = UTIL.GetUpvalue(IsCharacterIngredient, "is_character_ingredient")
if type(is_character_ingredient) == "table" then
    is_character_ingredient[CHARACTER_INGREDIENT.HUNGER] = true
    is_character_ingredient[CHARACTER_INGREDIENT.MAX_SANITY_VAL] = true
else
    is_character_ingredient = {
        [CHARACTER_INGREDIENT.HUNGER] = true,
        [CHARACTER_INGREDIENT.MAX_SANITY_VAL] = true,
    }
    local old_IsCharacterIngredient = GLOBAL.IsCharacterIngredient
    function GLOBAL.IsCharacterIngredient(ingredienttype, ...)
        if ingredienttype and is_character_ingredient[ingredienttype] then
            return true
        end
        return old_IsCharacterIngredient(ingredienttype, ...)
    end
end

--- SHIRO RECIPES
AddRecipe2("spiderscythe", { Ingredient(CHARACTER_INGREDIENT.HEALTH, CHARACTER_INGREDIENT_SEG * 20) }, TECH.NONE, { builder_tag = "shiro" }, { "CHARACTER", "WEAPONS" })
AddRecipe2("silk_robe", { Ingredient(CHARACTER_INGREDIENT.HUNGER, CHARACTER_INGREDIENT_SEG * 20), Ingredient("silk", 10) }, TECH.NONE, { builder_tag = "shiro" }, { "CHARACTER", "ARMOUR", "CLOTHING", "CONTAINERS", "WINTER", "RAIN" })
AddRecipe2("silk_shiro", { Ingredient(CHARACTER_INGREDIENT.HUNGER, CHARACTER_INGREDIENT_SEG * 2) }, TECH.NONE, { builder_tag = "shiro", product = "silk", description = "silk_shiro" }, { "CHARACTER", "REFINE" })
AddRecipe2("spiderden_shiro", { Ingredient(CHARACTER_INGREDIENT.HUNGER, CHARACTER_INGREDIENT_SEG * 24), Ingredient("silk", 6) }, TECH.NONE, { builder_skill = "shiro_evolution_queen_spider", image = "spidereggsack.tex", description = "spidereggsack", product = "spiderden", placer = "spidereggsack_placer" }, { "CHARACTER" })

--- WAKABA RECIPES
AddRecipe2("spiderscythe_wakaba", { Ingredient(CHARACTER_INGREDIENT.HEALTH, CHARACTER_INGREDIENT_SEG), Ingredient("livinglog", 2), Ingredient("silk", 4) }, TECH.NONE, { product = "spiderscythe", builder_tag = "wakaba" }, { "CHARACTER", "WEAPONS" })
AddRecipe2("helheim_beyonder", { Ingredient("purplegem", 1), Ingredient("livinglog", 2), Ingredient("nightmarefuel", 3) }, TECH.NONE, { builder_tag = "wakaba" }, { "CHARACTER", "WEAPONS" })
AddRecipe2("storing_space", { Ingredient(CHARACTER_INGREDIENT.MAX_SANITY_VAL, 100) }, TECH.NONE, { builder_tag = "__storing_space", image = "equip_slot_hud.tex", atlas = GetInventoryItemAtlas("equip_slot_hud.tex"), sg_state = "spawn_mutated_creature" }, { "CHARACTER", "CONTAINERS" })
AddRecipe2("storing_space_dtor", { Ingredient(CHARACTER_INGREDIENT.SANITY, 0) }, TECH.NONE, { builder_tag = "_storing_space", image = "equip_slot_hud.tex", atlas = GetInventoryItemAtlas("equip_slot_hud.tex") }, { "CHARACTER", "CONTAINERS" })
AddRecipe2("aramasa", { Ingredient("bluegem", 2), Ingredient("gears", 2), Ingredient("pigskin", 4)}, TECH.MAGIC_THREE, { builder_tag = "wakaba" }, { "CHARACTER", "WEAPONS", "MAGIC" })