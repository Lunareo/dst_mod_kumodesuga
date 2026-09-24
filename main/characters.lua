local function RegisterCharacter(prefab, gender, minimap_prefab)
    table.insert(PrefabFiles, prefab)
    for _, v in pairs({
        Asset("ATLAS", "images/saveslot_portraits/" .. prefab .. ".xml"),
        Asset("ATLAS", "images/selectscreen_portraits/" .. prefab .. ".xml"),
        Asset("ATLAS", "images/selectscreen_portraits/" .. prefab .. "_silho.xml"),
        Asset("ATLAS", "bigportraits/" .. prefab .. ".xml"),
        Asset("ATLAS", "bigportraits/" .. prefab .. "_none.xml"),
        Asset("ATLAS", "images/map_icons/" .. prefab .. ".xml"),
        Asset("ATLAS", "images/avatars/avatar_" .. prefab .. ".xml"),
        Asset("ATLAS", "images/avatars/avatar_ghost_" .. prefab .. ".xml"),
        Asset("ATLAS", "images/avatars/self_inspect_" .. prefab .. ".xml"),
        Asset("ATLAS", "images/names_" .. prefab .. ".xml"),
        Asset("ATLAS", "images/names_gold_" .. prefab .. ".xml"),
        Asset("ATLAS", "images/names_gold_cn_" .. prefab .. ".xml"),
    }) do
        table.insert(Assets, v)
    end
    AddMinimapAtlas("images/map_icons/" .. (minimap_prefab or prefab) .. ".xml")
    AddModCharacter(prefab, gender or "FEMALE")
end

RegisterCharacter("shiro")
RegisterCharacter("wakaba")
RegisterCharacter("ariel", "FEMALE", "shiro") -- 占位：暂缺专属美术，复用白织地图图标