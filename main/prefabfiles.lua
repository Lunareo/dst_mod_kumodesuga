PrefabFiles = {
    "buffs_kmds",
    "erosion_fx",
    "helheim_beyonder",
    "reticule_kmds",
    "silk_robe",
    "spell_item",
    "spiderscythe",
    "storing_space",
    "strong_gravity_creep",
    "unique_fx",
}

local HotPrefabFiles = {
}
if next(HotPrefabFiles) ~= nil then
    UTIL.FnExtend(GLOBAL, "SpawnPrefab", function(prefab)
        if HotPrefabFiles[prefab] then
            print("[hot load] Hot loading prefab:", prefab, "from", "prefabs/" .. HotPrefabFiles[prefab])
            LoadPrefabFile("prefabs/" .. HotPrefabFiles[prefab])
        end
    end)
end
