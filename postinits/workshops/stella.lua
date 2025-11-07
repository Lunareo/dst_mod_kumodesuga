AddSimPostInit(function()
    if not ACTIONS.ACTION_STELLA_STEAL then return end
    UTIL.FnExtend(ACTIONS.ACTION_STELLA_STEAL, "fn", function(act)
        local doer, target = act.doer, act.target
        if doer and doer:IsValid() then
            doer.flag_is_xl_stealing = true
            if target and target:IsValid() then
                target.flag_is_stealing_by_xl = true
                doer.refer_is_xl_steal_someone = target
            end
        end
    end, function(rets, act)
        local doer, target = act.doer, act.target
        if doer and doer:IsValid() then
            doer.flag_is_xl_stealing = false
            if target and target:IsValid() then
                target.flag_is_stealing_by_xl = false
                doer.refer_is_xl_steal_someone = nil
            end
        end
        return rets
    end)
end)
