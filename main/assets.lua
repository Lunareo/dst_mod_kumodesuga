Assets = {}

---@param atlas string
LoadAtlas = function(atlas)
    table.insert(Assets, Asset("ATLAS", atlas))
    table.insert(Assets, Asset("ATLAS_BUILD", atlas, 256))
    atlas = softresolvefilepath(atlas)
    local file = io.open(atlas, "r")
    if file == nil then return end
    local str = file:read("*a"):gsub("%s+", "")
    file:close()
    for tex in string.gmatch(str, [[Elementname="(.-)"]]) do
        RegisterInventoryItemAtlas(atlas, tex)
        RegisterInventoryItemAtlas(atlas, hash(tex))
    end
end

LoadAtlas("images/inventoryimage_kmds.xml")
LoadAtlas("images/charactor_ingredients.xml")