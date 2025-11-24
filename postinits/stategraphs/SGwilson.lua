local function CASTAOE_dest_post(inst, action)
    if action.invobject ~= nil then
        if action.invobject:HasTag("scythe") then
            return { "scythe" }, true
        elseif action.invobject:HasTag("spell_item") then
            return { "channelcast_oh_idle" }, true
        end
    end
end

AddStategraphPostInit("wilson", function(sg)
    UTIL.FnExtend(sg.actionhandlers[ACTIONS.CASTAOE], "deststate", CASTAOE_dest_post)
end)

AddStategraphPostInit("wilson_client", function(sg)
    UTIL.FnExtend(sg.actionhandlers[ACTIONS.CASTAOE], "deststate", CASTAOE_dest_post)
end)
