---@diagnostic disable: undefined-global
local spdmgpriority = 1e5 - 1e2
AddSimPostInit(function()
    if not rawget(GLOBAL, "Insight") then
        return
    end
    Insight.descriptors.abyssdamage = {
        Describe = function(self, player_context)
            local description = string.format(STRINGS.NAMES.ABYSSDAMAGE, self:GetDamage())
            return {
                priority = spdmgpriority,
                description = description
            }
        end,
    }
    Insight.descriptors.abyssdefense = {
        Describe = function(self, player_context)
            local description = string.format(STRINGS.NAMES.ABYSSDEFENSE, self:GetDefense())
            return {
                priority = spdmgpriority,
                description = description
            }
        end,
    }
    Insight.descriptors.erosiondamage = {
        Describe = function(self, player_context)
            local description = string.format(STRINGS.NAMES.EROSIONDAMAGE, self:GetDamage())
            return {
                priority = spdmgpriority,
                description = description
            }
        end,
    }
    Insight.descriptors.erosiondefense = {
        Describe = function(self, player_context)
            local description = string.format(STRINGS.NAMES.EROSIONDEFENSE, self:GetDefense())
            return {
                priority = spdmgpriority,
                description = description
            }
        end,
    }
end)
