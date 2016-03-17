require 'nn'

local fwrite = function(tensor, file)
    if not tensor then return false end
    local n = tensor:nElement()
    local s = tensor:storage()
    -- return assert(file:writeDouble(s) == n)
    file:writeFloat(s)
end

local mdl = torch.load('/home/binghao/cnn/debug/12cnet/model.net')
module1_weight = mdl.modules[1].weight
local module1_bias = mdl.modules[1].bias

--print(module1_weight)
--print(module1_bias)

local file = torch.DiskFile('/home/binghao/cnn/debug/12cnet/12cnet.bin', 'w'):binary()
fwrite(module1_weight, file)
fwrite(module1_bias, file)
