local LobbyScreen = require "screens/redux/lobbyscreen"
UTIL.FnExtend(LobbyScreen, "ToNextPanel", nil, function(rets, lobbyscreen)
    local is_mod_character = lobbyscreen.current_panel_index == 2 and
        (lobbyscreen.lobbycharacter == "shiro" or lobbyscreen.lobbycharacter == "wakaba") or nil
    if is_mod_character then
        RemapSoundEvent(GetGameModeProperty("override_lobby_music") or "dontstarve/together_FE/DST_theme_portaled",
            "kumodesuga/soundtrack/theme")
    else
        RemoveRemapSoundEvent(GetGameModeProperty("override_lobby_music") or
            "dontstarve/together_FE/DST_theme_portaled")
    end
    if lobbyscreen.issoundplaying and lobbyscreen.islobbymusicoverrided ~= is_mod_character then
        lobbyscreen:StopLobbyMusic()
        lobbyscreen:StartLobbyMusic()
        lobbyscreen.islobbymusicoverrided = is_mod_character
    end
    return rets
end)
