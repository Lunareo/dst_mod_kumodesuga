---@diagnostic disable: lowercase-global
local function en_zh(en, zh) return (locale == "zh" or locale == "zhr" or locale == "zht") and zh or en end

name = en_zh("Kumodesuga, nanika?", "转生成为蜘蛛") .. ": Alpha"
version = "1.0.0"
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

configuration_options = {
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
