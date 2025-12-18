---@type table<string, ScrapbookData>
local scrapbookdata_k = {
    aramasa = { name = "aramasa", tex = "spear.tex", type = "item", prefab = "aramasa", weapondamage = "8.5 * 8", finiteuses = 150, build = "swap_spear", bank = "spear", anim = "idle" },
    helheim_beyonder = { name = "helheim_beyonder", tex = "helheim_beyonder.tex", type = "item", prefab = "helheim_beyonder", weapondamage = "25.5 +17", weaponrange = 10, finiteuses = 200, build = "helheim_beyonder_fx", bank = "helheim_beyonder_fx", anim = "idle" },
    silk_robe = { name = "silk_robe", tex = "silk_robe.tex", type = "item", prefab = "silk_robe", armor = 700, absorb_percent = .7, insulator = 180, insulator_type = "winter", build = "silk_robe", bank = "silk_robe", anim = "idle",  },
    spiderscythe = { name = "spiderscythe", tex = "spiderscythe.tex", type = "item", prefab = "spiderscythe", weapondamage = "42.5 +8.5", weaponrange = 1, finiteuses = 200, build = "spiderscythe", bank = "spiderscythe", anim = "idle" },
}

local scrapbook_prefabs = require "scrapbook_prefabs"
for prefab in pairs(scrapbookdata_k) do
    scrapbook_prefabs[prefab] = true
end

local scrapbookdata = require "screens/redux/scrapbookdata"
for prefab, data in pairs(scrapbookdata_k) do
    scrapbookdata[prefab] = data
end

return scrapbook_prefabs
