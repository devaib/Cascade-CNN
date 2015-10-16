require 'nn'

local fwrite = function(tensor, file)
  if not tensor then return false end
  local n = tensor:nElement()
  local s = tensor:storage()
  return assert(file:writeDouble(s) == n)
end

local m = nn.Linear(2, 2)

print(m.weight)
print(m.bias)

local file = torch.DiskFile("/Users/wbh/net.bin", "w"):binary()
fwrite(m.weight, file)
fwrite(m.bias, file)
