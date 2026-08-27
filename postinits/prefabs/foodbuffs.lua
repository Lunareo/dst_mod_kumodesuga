--- 蘑菇的睡眠免疫和醉酒互斥：拿到免疫就当场醒酒。
---
--- 顺序很关键——先让原版 attach 把 immunity source 挂上，再解除 drunken。
--- 这样 drunken 的 detach 里那记 AddGrogginess 会被免疫直接挡回去
--- （scripts/components/grogginess.lua 的 AddGrogginess 开头就查 immunity），
--- 于是玩家只是醒酒，不会倒头睡过去。
AddPrefabPostInit("buff_sleepimmunity", function (inst)
    if not TheWorld.ismastersim then return end

    local debuff = inst.components.debuff
    if debuff == nil then return end

    local onattachedfn = debuff.onattachedfn
    debuff:SetAttachedFn(function (buff, target, ...)
        if onattachedfn ~= nil then
            onattachedfn(buff, target, ...)
        end
        if target.components.debuffable ~= nil then
            target.components.debuffable:RemoveDebuff("drunken")
        end
    end)
end)
