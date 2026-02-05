local PlayerVision = require "components/playervision"
UTIL.FnExtend(PlayerVision, "ForceGoggleVision", function (playervision, force)
    local nv = playervision.inst.components.nightvision
    if not force and nv and nv.update:value() then
        return nil, true
    end
end)