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

---@class widget_wakabaagebadge: widget_wandaagebadge
local WakabaAgeBadge = Class(OldAgeBadge, function(self, ...)
    OldAgeBadge._ctor(self, ...)
    StartThread(function() -- To against Combined Status' postinit
        Yield()
        self._iswandaoldagebadge = nil
        self.SetPercent = SetPercent
        self:SetPercent()
    end)
end)

function WakabaAgeBadge:OnUpdate(dt)
    if TheNet:IsServerPaused() then return end

    local player_classified = self.owner.player_classified
    if player_classified == nil then
        return
    end

    local year_percent = player_classified.oldager_yearpercent:value()

    -- client prediction for the oldager component
    if not TheWorld.ismastersim then
        local dps_rate = player_classified:GetOldagerRate()

        year_percent = year_percent - (1 / 40 + dps_rate * 0.9) * dt
        if dps_rate == 0 then
            year_percent = math.min(1, year_percent) -- if we are going at the normal rate, then wait for the game to say we have aged a year before progressing
        end
        player_classified.oldager_yearpercent:set_local(year_percent)
    end

    self.days_hand:SetRotation(Lerp(0, 360, year_percent))
end

return WakabaAgeBadge
