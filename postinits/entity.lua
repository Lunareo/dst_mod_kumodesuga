local groggy_stacks = {}
UTIL.FnExtend(Entity, "AddTag", function(entity, tag)
    if tag == "groggy" then
        groggy_stacks[entity] = (groggy_stacks[entity] or 0) + 1
    end
end)
UTIL.FnExtend(Entity, "RemoveTag", function(entity, tag)
    if tag == "groggy" and groggy_stacks[entity] then
        groggy_stacks[entity] = groggy_stacks[entity] - 1
        if groggy_stacks[entity] <= 0 then
            groggy_stacks[entity] = nil
        else
            return nil, true
        end
    end
end)
