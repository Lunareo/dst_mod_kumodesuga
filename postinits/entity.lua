local TAGSTACK = { groggy = {}, }
UTIL.FnExtend(Entity, "AddTag", function(entity, tag)
    if TAGSTACK[tag] ~= nil then
        TAGSTACK[tag][entity] = (TAGSTACK[tag][entity] or 0) + 1
    end
end)
UTIL.FnExtend(Entity, "RemoveTag", function(entity, tag)
    if TAGSTACK[tag] ~= nil and TAGSTACK[tag][entity] ~= nil then
        TAGSTACK[tag][entity] = TAGSTACK[tag][entity] - 1
        if TAGSTACK[tag][entity] <= 0 then
            TAGSTACK[tag][entity] = nil
        else
            return nil, true
        end
    end
end)
