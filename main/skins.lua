---@diagnostic disable: undefined-global
modimport "main/skinutil"

---@param basename string
---@param skinbuild string|nil
---@param rarity string|nil
---@param config table|nil
---@param notfree boolean|nil
local function AddCharacterSkin(basename, skinbuild, rarity, config, notfree)
    table.insert(Assets, Asset("DYNAMIC_ANIM", "anim/dynamic/" .. (skinbuild or basename) .. ".zip"))
    table.insert(Assets, Asset("PKGREF", "anim/dynamic/" .. (skinbuild or basename) .. ".dyn"))
    table.insert(Assets, Asset("ANIM", "anim/ghost_" .. basename .. "_build.zip"))
    rarity = rarity or "Character"
    config = config or {}
    local skinname = skinbuild or (basename .. "_none")
    skinbuild = skinbuild or basename
    MakeCharacterSkin(basename, skinname, merge(config, {
        name = STRINGS.SKIN_NAMES[skinbuild],
        des = STRINGS.SKIN_DES[skinbuild],
        quotes = STRINGS.SKIN_QUOTES[skinbuild],
        rarity = STRINGS.UI.RARITY[rarity],
        rarityorder = RARITY_ORDER[rarity],
        raritycolor = SKIN_RARITY_COLORS[rarity],
        release_group = 1000,
        skin_tags = { "BASE", basename, "CHARACTER" },
        skins = {
            normal_skin = skinbuild,
            ghost_skin = "ghost_" .. basename .. "_build",
        },
        build_name_override = skinbuild,
        share_bigportrait_name = basename .. "_none",
        FrameSymbol = rarity,
    }))
end

AddCharacterSkin("shiro")
AddCharacterSkin("shiro", "shiro_jk", "Elegant")
AddCharacterSkin("shiro", "shiro_classic", "Event")
AddCharacterSkin("wakaba")
