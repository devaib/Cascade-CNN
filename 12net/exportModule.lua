require 'nn'

local fwrite = function(tensor, file)
    if not tensor then return false end
    local n = tensor:nElement()
    local s = tensor:storage()
    -- return assert(file:writeDouble(s) == n)
    file:writeFloat(s)
end

local mdl = torch.load('/Users/wbh/cnn/model.net')
local module4_weight = mdl.modules[4].weight
local module4_bias = mdl.modules[4].bias

print(module4_weight)
print(module4_bias)

local file = torch.DiskFile('/Users/wbh/cnn/module.bin', 'w'):binary()
-- it writes the whole model into file for 2 times
-- mdl.modules[1].weight:storage() == mdl_modules[1].bias:storage() == mdl_modules[4].weight:storage() == mdl_modules[4].bias
fwrite(module4_weight, file)
