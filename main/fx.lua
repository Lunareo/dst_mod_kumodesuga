for _, v in ipairs {
    {
        name = "airbase_lazer_fx",
        bank = "airbase_lazer",
        build = "airbase_lazer",
        anim = "fxlaser",
        fn = function(inst)
            if not TheWorld.ismastersim then return end
            StartThread(function()
                local pos = inst:GetPosition()
                Sleep(38 * FRAMES)
                SpawnAt("airbase_lazer_hit_fx", pos)
            end)
        end,
    },
    {
        name = "airbase_lazer_hit_fx",
        bank = "airbase_lazer",
        build = "airbase_lazer",
        anim = "fxground",
        fn = function(inst)
            inst.AnimState:SetOrientation(ANIM_ORIENTATION.OnGround)
        end,
    },
} do
    table.insert(require "fx", v)
end
