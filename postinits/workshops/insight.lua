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
    Insight.prefab_descriptors.aramasa = {
        Describe = function(inst, player_context)
            return {
                priority = 0,
                description = STRINGS.INSIGHT_DESC.ARAMASA,
            }
        end,
    }
    UTIL.FnExtend(Insight.descriptors.equippable, "Describe", nil,
        ---@param rets [{description:(string|nil)}]
        ---@param self component_equippable
        function(rets, self, player_context)
            local description = {}
            if self.critrate ~= nil then
                table.insert(description, string.format(STRINGS.NAMES.EQUIPPABLE_CRITRATE,
                    FunctionOrValue(self.critrate, self.inst) * 100))
            end
            if self.critdamagerate ~= nil then
                table.insert(description, string.format(STRINGS.NAMES.EQUIPPABLE_CRITDAMAGERATE,
                    FunctionOrValue(self.critdamagerate, self.inst) * 100))
            end
            rets[1].description = (rets[1].description or "") .. table.concat(description, ", ")
            return rets
        end)
end)
