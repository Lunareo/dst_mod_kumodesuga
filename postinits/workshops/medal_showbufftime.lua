AddComponentPostInit("medal_showbufftime", function(ShowBuffTime)
    UTIL.FnExtend(ShowBuffTime, "getbuffinfofn", function(inst, buff_info)
        local satura = inst.components.satura
        if satura and satura:IsSaturated() then
            table.insert(buff_info, {
                buffname = satura:IsHighsaturated() and "kumo_oversaturate" or "kumo_saturate",
                bufftime = -1,
                bufflayer = math.floor(satura:GetCurrent()),
            })
        end
        --[[local combat = inst.components.combat
        local bonus = combat and combat.damagebonuslist and combat.damagebonuslist:CalculateModifierFromSource("buff_curse_doer")
        if bonus and bonus > 0 then
            table.insert(buff_info, {
                buffname = "kumo_atk_stealer",
                bufftime = -1,
                bufflayer = math.floor(bonus * 10),
            })
        end]]
    end)
end)
