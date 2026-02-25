---@diagnostic disable: lowercase-global
local function en_zh(en, zh) return (locale == "zh" or locale == "zhr" or locale == "zht") and zh or en end

name = en_zh("Kumodesuga, nanika?", "我是蜘蛛又怎样?!") .. "(Beta)"
version = "1.1.25"
description = ""
author = "Runar"

forumthread = ""

api_version = 10
api_version_dst = 10

dst_compatible = true
-- dont_starve_compatible = true
-- reign_of_giants_compatible = true
-- server_only_mod = true
all_clients_require_mod = true
-- client_only_mod = true

icon_atlas = "images/modicon.xml"
icon = "modicon.tex"

server_filter_tags = {}

local keys = { "A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U",
    "V", "W", "X", "Y", "Z", "F1", "F2", "F3", "F4", "F5", "F6", "F7", "F8", "F9", "F10", "F11", "F12", "LALT", "RALT",
    "LCTRL", "RCTRL", "LSHIFT", "RSHIFT", "TAB", "CAPSLOCK", "SPACE", "MINUS", "EQUALS", "BACKSPACE", "INSERT", "HOME",
    "DELETE", "END", "PAGEUP", "PAGEDOWN", "PRINT", "SCROLLOCK", "PAUSE", "PERIOD", "SLASH", "SEMICOLON", "LEFTBRACKET",
    "RIGHTBRACKET", "BACKSLASH", "UP", "DOWN", "LEFT", "RIGHT", "ENTER", "1", "2", "3", "4", "5", "6", "7", "8", "9", "0" }
local key_option = {}
for i = 1, #keys do
    key_option[i] = {
        description = keys[i],
        data = "KEY_" .. keys[i]:upper(),
    }
end

configuration_options = {
    {
        name = "parrykey",
        label = en_zh("Dodge hot key", "闪避热键"),
        hover = en_zh("While press this key, wakaba will try dodge", "按下此键时, 若叶姬色将尝试进行闪避"),
        options = key_option,
        client = true,
        default = "KEY_R",
    },
    -- {
    --     name = "",
    --     label = "",
    --     options = {
    --         {
    --             description = "",
    --             data = nil,
    --         },
    --     },
    --     default = nil,
    -- },
}
