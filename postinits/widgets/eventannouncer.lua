require "widgets/eventannouncer"

UTIL.FnExtend(GLOBAL, "GetNewDeathAnnouncementString", function(theDead)
    if not (theDead and theDead.prefab == "wakaba") then return end
    return
        { string.format(STRINGS.UI.HUD.DEATH_ANNOUNCEMENT_WAKABA[math.random(#STRINGS.UI.HUD.DEATH_ANNOUNCEMENT_WAKABA)],
            theDead:GetDisplayName()) }, true
end)

UTIL.FnExtend(GLOBAL, "GetNewRezAnnouncementString", function(theRezzed, source)
    if not (theRezzed and source and theRezzed.prefab == "wakaba") then return end
    return { string.format(STRINGS.UI.HUD.REZ_ANNOUNCEMENT_WAKABA[math.random(#STRINGS.UI.HUD.REZ_ANNOUNCEMENT_WAKABA)],
        source,
        theRezzed:GetDisplayName()) }, true
end)
