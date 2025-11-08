AddComponentPostInit("medal_showbufftime", function(ShowBuffTime)
    UTIL.FnExtend(ShowBuffTime, "getbuffinfofn", function(inst, buff_info)
        local satura = inst.replica.satura
        if satura then
            if satura:IsHighsaturated() then
                table.insert(buff_info, {
                    buffname = "kumo_oversaturate",
                    bufftime = -1,
                })
            elseif satura:IsSaturated() then
                table.insert(buff_info, {
                    buffname = "kumo_saturate",
                    bufftime = -1,
                })
            end
        end
    end)
end)
