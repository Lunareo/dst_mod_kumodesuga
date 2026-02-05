local loading_bgs = {
    { .2, "loading_bg_shiro_1" },
    { .4,  "loading_bg_ariel_1" },
}

for _, v in ipairs(loading_bgs) do
    table.insert(Assets, Asset("ATLAS", "images/" .. v[2] .. ".xml"))
end

AddClassPostConstruct("widgets/redux/loadingwidget", function(self)
    local index = math.random()
    local tex
    for _, v in ipairs(loading_bgs) do
        if index <= v[1] then
            tex = v[2]
            break
        end
    end
    if tex == nil then return end
    if self.legacy_fg ~= nil then
        self.legacy_fg:SetTexture("images/" .. tex .. ".xml", "" .. tex .. ".tex")
        self._specialbg = false
    end
    if self.bg ~= nil then
        self.bg:SetTexture("images/" .. tex .. ".xml", "" .. tex .. ".tex")
        self._specialbg = false
    end
end)
