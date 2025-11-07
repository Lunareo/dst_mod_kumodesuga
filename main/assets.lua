Assets = {}

---@param atlas string
---@param ... string # image
AssetATLAS = function(atlas, ...)
    table.insert(Assets, Asset("ATLAS", atlas))
    table.insert(Assets, Asset("ATLAS_BUILD", atlas, 256))
    atlas = softresolvefilepath(atlas)
    for _, imagename in ipairs{...} do
        RegisterInventoryItemAtlas(atlas, imagename .. ".tex")
    end
end

AssetATLAS("images/inventoryimage_kmds.xml", "chips", "helheim_beyonder", "helheim_beyonder_hide", "kurikuta_dried", "spiderscythe")