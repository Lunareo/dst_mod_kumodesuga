local godspunable = {
    walrushat = true,
}

local inglist = {
    silk = true,
    beardhair = true,
    beefalowool = true,
    voidcloth = true,
    bearger_fur = true,
    tentaclespots = true,
}

local function SetUpGodSpunable(inst)
    if not TheWorld.ismastersim then return end
    inst:AddComponent("godspunable")
end

for k in pairs(godspunable) do
    AddPrefabPostInit(k, SetUpGodSpunable)
end

AddRecipePostInitAny(function(rec)
    local product = rec.product or rec.name
    if godspunable[product] then return end
    for _, ing in ipairs(rec.ingredients) do
        if inglist[ing.type] then
            godspunable[product] = true
            AddPrefabPostInit(product, SetUpGodSpunable)
            break
        end
    end
end)
