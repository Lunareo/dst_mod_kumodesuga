local OldAgeBadge = require "widgets/wandaagebadge"

local function SetPercent(self, val, max, penaltypercent)
    val = val or self.percent
    max = max or TUNING.WAKABA_MAX_YEARS_OLD
    local age_precent = 1 - val
    local age = TUNING.WAKABA_MIN_YEARS_OLD + age_precent * (TUNING.WAKABA_MAX_YEARS_OLD - TUNING.WAKABA_MIN_YEARS_OLD)

    self.health_precent = val

    self.num:SetString(tostring(math.floor(age + 0.5)))

    self.year_hand:SetRotation(Lerp(0, 360, age_precent))

    local active = self.active
    self.active = true
    if self.CombinedStatusUpdateNumbers then
        self:CombinedStatusUpdateNumbers(TUNING.WAKABA_MAX_YEARS_OLD)
    end
    self.active = active
end

---@class widget_wakabaagebadge
local WakabaAgeBadge = Class(OldAgeBadge, function(self, ...)
    OldAgeBadge._ctor(self, ...)
    StartThread(function() -- To against Combined Status' postinit
        Yield()
        self._iswandaoldagebadge = nil
        self.SetPercent = SetPercent
        self:SetPercent()
    end)
end)

return WakabaAgeBadge
