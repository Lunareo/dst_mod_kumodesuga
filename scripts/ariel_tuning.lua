-- 初稿未量化的参数集中在这里；技能只改变这些基线，不写回全局常量。
return {
    pool = 100, pool_bonus = 50, food_ratio = .5, material_hunger = 1,
    decay = 1.5, combat_window = 8, hit_gain = 1,
    unarmed_damage = 34, speed = 1.1, physical_resist = .75, allegiance_resist = .85,
    thresholds = { 30, 60, 90 }, damage = { 1.15, 1.3, 1.5 }, regen = { 1, 2, 4 },
    dash_cost = 15, dash_range = 6, dash_cooldown = 4,
    gate_cost = 60, gate_wear = 15, gate_range = 12, gate_radius = 5,
    gate_duration = 5, gate_damage = 500, gate_cooldown = 120, execute_percent = .2,
    humility_wear = .25, humility_sanity = 50, humility_duration = 15,
    humility_cooldown = 480, exhaustion_duration = 20, min_health = 30,
    queen_duration = 60, queen_cooldown = 120, spider_limit = 8, leash_distance = 40,
    puppet_health = 200, puppet_hunger = .05, summon_hunger = 20, summon_cooldown = 10,
    massage_cost = 10, massage_cooldown = 30, massage_sanity = 15, massage_hunger = 5,
    joke_cooldown = 60, joke_delay = 4, joke_sanity = 3,
    tipsy_duration = 60, tipsy_damage = 1.1, tipsy_sanity = .2,
    meal_radius = 8, meal_duration = 60, nurture_amount = 15, nurture_duration = 30,
    rest_health = 3, rest_sanity = 3,
}
