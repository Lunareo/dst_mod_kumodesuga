---@diagnostic disable: lowercase-global, undefined-global
locale = LOC.GetLocaleCode()
local map = {
    zh = "zh",
    zhr = "zh",
    ch = "zh",
    chs = "zh",
    sc = "zh",
    zht = "zh",
    tc = "zh",
    cht = "zh",
    chinese = "zh",
}

local base = modrequire "languages/strings"
if map[locale] then
    base, ext = modrequire("languages/strings_" .. map[locale]), base
    merge(base, ext)
end
merge(STRINGS, base, true)