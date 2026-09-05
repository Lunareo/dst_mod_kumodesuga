STRINGS.NAMES.GODSPUNSILK = "神织丝"
--STRINGS.NAMES.GODSPUNSILK = "God Spun"

local function postfn(inst)
    inst:AddTag("reweaver")
    if not TheWorld.ismastersim then return end
    if inst.components.inventoryitem ~= nil then
        inst.components.inventoryitem:ChangeImageName("silk")
    end
end

return Derive("silk", "godspunsilk", postfn)