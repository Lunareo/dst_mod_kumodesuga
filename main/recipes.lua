local is_character_ingredient = UTIL.GetUpvalue(IsCharacterIngredient, "is_character_ingredient")
if is_character_ingredient then
    is_character_ingredient[CHARACTER_INGREDIENT.HUNGER] = true
    is_character_ingredient[CHARACTER_INGREDIENT.MAX_SANITY_VAL] = true
end

--- SHIRO RECIPES
AddRecipe2("spiderscythe", { Ingredient(CHARACTER_INGREDIENT.HEALTH, CHARACTER_INGREDIENT_SEG * 20) }, TECH.NONE, { builder_tag = "shiro" }, { "CHARACTER", "WEAPONS" })
AddRecipe2("silk_robe", { Ingredient(CHARACTER_INGREDIENT.HUNGER, CHARACTER_INGREDIENT_SEG * 20), Ingredient("silk", 10) }, TECH.NONE, { builder_tag = "shiro" }, { "CHARACTER", "ARMOUR", "CLOTHING", "CONTAINERS", "WINTER", "RAIN" })

--- WAKABA RECIPES
AddRecipe2("spiderscythe_wakaba", { Ingredient(CHARACTER_INGREDIENT.HEALTH, CHARACTER_INGREDIENT_SEG), Ingredient("livinglog", 2), Ingredient("silk", 4) }, TECH.NONE, { product = "spiderscythe", builder_tag = "wakaba" }, { "CHARACTER", "WEAPONS" })
AddRecipe2("helheim_beyonder", { Ingredient("purplegem", 1), Ingredient("livinglog", 2), Ingredient("nightmarefuel", 3) }, TECH.NONE, { builder_tag = "wakaba" }, { "CHARACTER", "WEAPONS" })
AddRecipe2("storing_space", { Ingredient(CHARACTER_INGREDIENT.MAX_SANITY_VAL, 100) }, TECH.NONE, { builder_tag = "__storing_space", image = "equip_slot_hud.tex", atlas = GetInventoryItemAtlas("equip_slot_hud.tex"), sg_state = "spawn_mutated_creature" }, { "CHARACTER", "CONTAINERS" })
AddRecipe2("storing_space_dtor", { Ingredient(CHARACTER_INGREDIENT.SANITY, 0) }, TECH.NONE, { builder_tag = "_storing_space", image = "equip_slot_hud.tex", atlas = GetInventoryItemAtlas("equip_slot_hud.tex") }, { "CHARACTER", "CONTAINERS" })
-- silk_shiro