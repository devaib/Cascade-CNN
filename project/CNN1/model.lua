require 'torch'   -- torch
require 'image'   -- to visualize the dataset
require 'nn'      -- provides all sorts of trainable modules/layers

print('Model')
torch.setdefaulttensortype('torch.FloatTensor')
local mdlH=37
local mdlW=45
if  (opt.load ~= "") then
    model = torch.load(opt.load)
    print(sys.COLORS.blue .. '**Pre-trained model loaded**') 
else	
model = nn.Sequential()
model:add(nn.SpatialConvolutionMM(3,64,12,4,1,1)) --I(3x37x45)->O(64x34x34)
model:add(nn.SpatialMaxPooling(3,3,2,2,1,1))--I(64x34x34)->O(16x17x17)
model:add(nn.ReLU())
model:add(nn.SpatialConvolutionMM(64,64,3,3,1,1,1,1))--I(64x17x17)->O(64x17x17)
model:add(nn.ReLU())
model:add(nn.SpatialConvolutionMM(64,64,3,3,1,1,1,1))--I(64x17x17)->O(64x17x17)
model:add(nn.SpatialMaxPooling(3,3,2,2,1,1))--I(64x17x17)->O(64x9x9)
model:add(nn.ReLU())
model:add(nn.SpatialConvolutionMM(64,256,9,9,1,1))--I(64x9x9)->O(256x1x1)
model:add(nn.Dropout())
model:add(nn.ReLU())
model:add(nn.Reshape(256))
model:add(nn.Linear(256,6))
model:add(nn.LogSoftMax())
--[[
    --LDA model
model:add(nn.SpatialConvolutionMM(3,6,mdlW,mdlH,1,1)) --I(1x12x12)->O(16x10x10)
model:add(nn.Reshape(6))
model:add(nn.LogSoftMax())
--]]
end


-- Loss: NLL
loss = nn.ClassNLLCriterion()
----------------------------------------------------------------------
print(sys.COLORS.red ..  '==> here is the CNN:')
print(model)

if opt.type == 'cuda' then
   model:cuda()
   loss:cuda()
end

-- return package:
return {
   model = model,
   loss = loss,
}

