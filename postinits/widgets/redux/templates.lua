local TEMPLATE = require "widgets/redux/templates"
local Widget = require "widgets/widget"

local MakeUIStatusBadge = TEMPLATE.MakeUIStatusBadge
function TEMPLATE.MakeUIStatusBadge(s, ch, ...)
    local status = MakeUIStatusBadge(s, ch, ...)
    if status ~= nil then
        if s == "sanity" and ch == "wakaba" then
            status:Hide()
        end
        status._hidesanity = s == "sanity" or nil
        local ChangeCharacter = status.ChangeCharacter
        function status:ChangeCharacter(c)
            if self._hidesanity and c == "wakaba" then
                self:Hide()
            else
                self:Show()
            end
            return ChangeCharacter(self, c)
        end
    end
    return status
end
