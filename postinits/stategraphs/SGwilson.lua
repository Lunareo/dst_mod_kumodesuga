local function CASTAOE_dest_post(inst, action)
    if action.invobject ~= nil and action.invobject.prefab == "spiderscythe" then
        return {"scythe"}, true
    end
end

AddStategraphPostInit("wilson", function(sg)
    UTIL.FnExtend(sg.actionhandlers[ACTIONS.CASTAOE], "deststate", CASTAOE_dest_post)
end)

AddStategraphPostInit("wilson_client", function(sg)
    UTIL.FnExtend(sg.actionhandlers[ACTIONS.CASTAOE], "deststate", CASTAOE_dest_post)
end)