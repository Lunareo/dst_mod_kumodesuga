local foods = {
    kurikuta_dried = {
        test = function(cooker, names, tags)
            return (tags.fruit or 0) >= 4 and not (tags.inedible or tags.meat or tags.fish or tags.veggie)
        end,
        priority = 40,
        weight = 20,
        foodtype = FOODTYPE.VEGGIE,
        secondaryfoodtype = FOODTYPE.BERRY,
        health = TUNING.HEALING_MEDSMALL,
        hunger = TUNING.CALORIES_MEDSMALL,
        sanity = TUNING.SANITY_HUGE,
        perishtime = TUNING.PERISH_PRESERVED,
        cooktime = 1.5,
        potlevel = "med",
        floater = { nil, .5 },
        overridebuild = "kumo_food",
        cookbook_atlas = "images/kumo_cookbook.xml",
        nospice = true,
    },
}

require "spicedfoods"
local SPICES = UTIL.GetUpvalue(GenerateSpicedFoods, "SPICES")

for k, v in pairs(foods) do
    v.name = k
    v.weight = v.weight or 1
    v.priority = v.priority or 0
    v.perishtime = v.perishtime or TUNING.PERISH_PRESERVED
    v.cooktime = v.cooktime or 1
    v.potlevel = v.potlevel or "low"
    v.overridebuild = v.overridebuild or k
    table.insert(Assets, Asset("ANIM", "anim/" .. v.overridebuild .. ".zip"))
    v.cookbook_atlas = v.cookbook_atlas or ("images/cookbook_" .. k .. ".xml")
    table.insert(Assets, Asset("ATLAS", v.cookbook_atlas))
    v.cookbook_atlas = softresolvefilepath(v.cookbook_atlas)
    v.floater = v.floater or { "small", .05, .7 }
    v.cookbook_category = "mod"
    if v.masterfood == nil then
        AddCookerRecipe("cookpot", v)
        AddCookerRecipe("archive_cookpot", v)
    end
    AddCookerRecipe("portablecookpot", v)
    if v.postfn then
        AddPrefabPostInit(k, v.postfn)
        if not v.nospice then
            for spice in pairs(SPICES) do
                AddPrefabPostInit(k .. "_" .. string.lower(spice), v.postfn)
            end
        end
    end
    if not v.nospice then
        GenerateSpicedFoods({ v })
    end
end

merge(require("preparedfoods"), foods)
