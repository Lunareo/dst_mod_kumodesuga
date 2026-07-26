local loading_bgs = {
    { .2, "loading_bg_shiro_1" },
    --{ .4, "loading_bg_ariel_1" },
}

for _, v in ipairs(loading_bgs) do
    table.insert(Assets, Asset("ATLAS", "images/" .. v[2] .. ".xml"))
    table.insert(PreloadAssets, Asset("ATLAS", "images/" .. v[2] .. ".xml"))
end
ReloadPreloadAssets()

local index = math.random()
local tex
for _, v in ipairs(loading_bgs) do
    if index <= v[1] then
        tex = v[2]
        break
    end
end

AddClassPostConstruct("widgets/redux/loadingwidget", function(self)
    ReloadPreloadAssets()
    if self.bg ~= nil then
        if tex == nil then return end
        self.bg:SetTexture("images/" .. tex .. ".xml", "" .. tex .. ".tex")
        if self.legacy_fg ~= nil then
            self.legacy_fg:Hide()
        end
        local KeepAlive = self.KeepAlive
        function self:KeepAlive(auto_increment, ...)
            KeepAlive(self, auto_increment, ...)
            if auto_increment then
                ReloadPreloadAssets()
            end
            self.bg:SetTexture("images/" .. tex .. ".xml", "" .. tex .. ".tex")
        end
    end
end)
