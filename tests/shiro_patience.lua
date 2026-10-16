-- 从模组根目录用 Lua 5.1/LuaJIT 执行；直接加载角色的伤害处理代码，不复制被测实现。
local file = assert(io.open("scripts/prefabs/shiro.lua", "rb"))
local source = file:read("*a")
file:close()
local first = assert(source:find("    local old_DoDelta = inst.components.health.DoDelta", 1, true))
local last = assert(source:find("    inst.components.hunger:SetMax", first, true))
local install = assert(loadstring("return function(inst)\n" .. source:sub(first, last - 1) .. "\nend",
    "@shiro_damage_handler"))()

local function near(actual, expected)
    assert(math.abs(actual - expected) < 0.000001,
        string.format("expected %.8f, got %.8f", expected, actual))
end

local function player(hp, mp, active)
    local inst = { components = {}, tasks = {}, valid = true, active = active ~= false }
    function inst:IsValid() return self.valid end
    function inst:DoPeriodicTask(period, fn, delay)
        near(period, .5)
        near(delay, .5)
        local task = { fn = fn, cancelled = false }
        function task:Cancel() self.cancelled = true end
        self.tasks[#self.tasks + 1] = task
        return task
    end
    inst.components.skilltreeupdater = {
        IsActivated = function(_, skill)
            return (skill == "pati" and inst.active)
                or (skill == "shiro_evolution_death_scythe" and inst.acidresist == true)
        end,
    }
    inst.components.magicpoint = {
        current = mp,
        Cost = function(self, amount)
            assert(amount >= 0 and amount <= self.current, "invalid MP cost")
            self.current = self.current - amount
            return true
        end,
    }
    inst.components.health = {
        currenthealth = hp,
        IsDead = function(self) return self.currenthealth <= 0 end,
        DoDelta = function(self, amount)
            self.currenthealth = math.max(0, self.currenthealth + amount)
            return amount
        end,
    }
    install(inst)
    return inst
end

local function ticks(inst, count)
    for _ = 1, count do
        -- 固定当前轮的任务数，防止递归分摊被测试调度器掩盖。
        for i = 1, #inst.tasks do
            local task = inst.tasks[i]
            if not task.cancelled then task.fn(inst) end
        end
    end
end

local function check(name, fn)
    fn()
    print("SHIRO_PATI|" .. name .. "|ok")
end

check("delayed_damage_preserves_one_hp", function()
    local inst = player(100, 150)
    inst.components.health:DoDelta(-200, false, "attack")
    near(inst.components.health.currenthealth, 40)
    ticks(inst, 12)
    near(inst.components.health.currenthealth, 1)
    near(inst.components.magicpoint.current, 49)
    assert(#inst.tasks == 1 and inst.tasks[1].cancelled)
    ticks(inst, 20)
    near(inst.components.magicpoint.current, 49)
end)

check("large_ticks_do_not_split_again", function()
    local inst = player(100, 2000)
    inst.components.health:DoDelta(-1200, false, "attack")
    ticks(inst, 12)
    near(inst.components.health.currenthealth, 1)
    near(inst.components.magicpoint.current, 899)
    assert(#inst.tasks == 1 and inst.tasks[1].cancelled)
end)

check("nonlethal_damage_is_not_lost", function()
    local inst = player(100, 150)
    inst.components.health:DoDelta(-31, false, "attack")
    near(inst.components.health.currenthealth, 90.7)
    ticks(inst, 11)
    assert(not inst.tasks[1].cancelled)
    ticks(inst, 1)
    near(inst.components.health.currenthealth, 69)
    near(inst.components.magicpoint.current, 150)
    assert(inst.tasks[1].cancelled)
end)

check("threshold_does_not_split", function()
    local inst = player(100, 150)
    inst.components.health:DoDelta(-30, false, "attack")
    near(inst.components.health.currenthealth, 70)
    assert(#inst.tasks == 0)
end)

check("fractional_hp_is_protected", function()
    local inst = player(10, 10)
    inst.components.health:DoDelta(-9.5, false, "attack")
    near(inst.components.health.currenthealth, 1)
    near(inst.components.magicpoint.current, 9.5)
end)

check("exact_mp_payment_keeps_one_hp", function()
    local inst = player(1, 20)
    inst.components.health:DoDelta(-20, false, "attack")
    near(inst.components.health.currenthealth, 1)
    near(inst.components.magicpoint.current, 0)
    inst.components.health:DoDelta(-1, false, "attack")
    assert(inst.components.health:IsDead())
end)

check("insufficient_mp_still_allows_death", function()
    local inst = player(100, 20)
    inst.components.health:DoDelta(-200, false, "attack")
    ticks(inst, 12)
    near(inst.components.magicpoint.current, 0)
    assert(inst.components.health:IsDead() and inst.tasks[1].cancelled)
end)

check("no_mp_still_allows_death", function()
    local inst = player(100, 0)
    inst.components.health:DoDelta(-200, false, "attack")
    ticks(inst, 12)
    assert(inst.components.health:IsDead() and inst.tasks[1].cancelled)
end)

check("locked_skill_does_not_protect", function()
    local inst = player(100, 150, false)
    inst.components.health:DoDelta(-200, false, "attack")
    assert(inst.components.health:IsDead() and #inst.tasks == 0)
    near(inst.components.magicpoint.current, 150)
end)

check("unrelated_dot_is_unchanged", function()
    local inst = player(1, 150)
    inst.components.health:DoDelta(-2, true, "hunger")
    assert(inst.components.health:IsDead() and #inst.tasks == 0)
    near(inst.components.magicpoint.current, 150)
end)

check("overlapping_delays_are_independent", function()
    local inst = player(100, 150)
    inst.components.health:DoDelta(-100, false, "attack")
    inst.components.health:DoDelta(-100, false, "attack")
    ticks(inst, 12)
    near(inst.components.health.currenthealth, 1)
    near(inst.components.magicpoint.current, 49)
    assert(#inst.tasks == 2 and inst.tasks[1].cancelled and inst.tasks[2].cancelled)
end)

check("dead_or_removed_player_cancels_delay", function()
    for _, removed in ipairs({ false, true }) do
        local inst = player(100, 150)
        inst.components.health:DoDelta(-100, false, "attack")
        if removed then inst.valid = false else inst.components.health.currenthealth = 0 end
        ticks(inst, 1)
        assert(inst.tasks[1].cancelled)
        near(inst.components.magicpoint.current, 150)
    end
end)

check("acid_reduction_is_not_applied_twice", function()
    local inst = player(100, 150)
    inst.acidresist = true
    inst.components.health:DoDelta(-200, false, "erosion")
    ticks(inst, 12)
    near(inst.components.health.currenthealth, 60)
    near(inst.components.magicpoint.current, 150)
end)
