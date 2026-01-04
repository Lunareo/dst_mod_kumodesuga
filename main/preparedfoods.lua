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
        overridebuild = "kumo_food",
        cookbook_atlas = "images/kumo_cookbook.xml",
        nospice = true,
        notinitprefab = true, -- compatible with functional medal
    },
    chips = {
        test = function(cooker, names, tags)
            return ((names.potato or 0) + (names.potato_cooked or 0)
                + (names.seataro or 0) + (names.seataro_cooked or 0)
                + (names.sweet_potato or 0) + (names.sweet_potato_cooked or 0)) >= 4 -- compatible with tropical mods
        end,
        priority = 1,
        foodtype = FOODTYPE.VEGGIE,
        health = -TUNING.HEALING_SMALL,
        hunger = TUNING.CALORIES_MOREHUGE,
        sanity = TUNING.SANITY_LARGE,
        perishtime = TUNING.PERISH_PRESERVED,
        cooktime = .5,
        overridebuild = "kumo_food",
        cookbook_atlas = "images/kumo_cookbook.xml",
    },
}

require "spicedfoods"
local SPICES = UTIL.GetUpvalue(GenerateSpicedFoods, "SPICES")
if SPICES == nil then
    local function oneaten_garlic(inst, eater)
        eater:AddDebuff("buff_playerabsorption", "buff_playerabsorption")
    end

    local function oneaten_sugar(inst, eater)
        eater:AddDebuff("buff_workeffectiveness", "buff_workeffectiveness")
    end

    local function oneaten_chili(inst, eater)
        eater:AddDebuff("buff_attack", "buff_attack")
    end

    SPICES =
    {
        SPICE_GARLIC = { oneatenfn = oneaten_garlic, prefabs = { "buff_playerabsorption" } },
        SPICE_SUGAR  = { oneatenfn = oneaten_sugar, prefabs = { "buff_workeffectiveness" } },
        SPICE_CHILI  = { oneatenfn = oneaten_chili, prefabs = { "buff_attack" } },
        SPICE_SALT   = {},
    }
end
local spicefoods = {}

for k, v in pairs(foods) do
    v.name = k
    v.weight = v.weight or 1
    v.priority = v.priority or 0
    v.perishtime = v.perishtime or TUNING.PERISH_PRESERVED
    v.cooktime = v.cooktime or 1
    v.potlevel = v.potlevel or "med"
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
        spicefoods[k] = v
    end
end

GenerateSpicedFoods(spicefoods)
merge(require("preparedfoods"), foods)
