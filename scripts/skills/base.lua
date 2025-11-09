local Base = Class(function(self, inst, root)
    self.inst = inst
    self.root = root
    makereadonly(self, "inst")
    makereadonly(self, "root")
end, nil, {})
