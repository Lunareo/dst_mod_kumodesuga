---@diagnostic disable: lowercase-global, undefined-global
locale = LOC.GetLocaleCode()
local map_zh = {
    zh = true,
    zhr = true,
    ch = true,
    chs = true,
    sc = true,
    zht = true,
    tc = true,
    cht = true,
    chinese = true,
}

local base = modrequire "languages_kmds/strings"
if not map_zh[locale] then
    LoadPOFile("scripts/languages_kmds/strings_en.po", "kmds_en")
end
merge(STRINGS, base, true)
TranslateStringTable(STRINGS)

STRINGS.ACTIONS.USESPELLBOOK.CASTSPELL = STRINGS.ACTIONS.CASTSPELL.GENERIC
STRINGS.CHARACTER_SURVIVABILITY.shiro = STRINGS.CHARACTER_SURVIVABILITY.wilson
STRINGS.CHARACTER_SURVIVABILITY.wakaba = STRINGS.CHARACTER_SURVIVABILITY.wanda
STRINGS.NAMES.HALF_SANITY_VAL = STRINGS.NAMES.HALF_SANITY
STRINGS.SKILLTREE.SHIRO.DOMINATOR_LOCK_DESC = STRINGS.SKILLTREE.WILSON.WILSON_ALLEGIANCE_LOCK_1_DESC