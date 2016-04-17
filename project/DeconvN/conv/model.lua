require 'torch'   -- torch
require 'image'   -- to visualize the dataset
require 'nn'      -- provides all sorts of trainable modules/layers

print('Model')
torch.setdefaulttensortype('torch.FloatTensor')
local mdlH=63
local mdlW=63
if  (opt.load ~= "") then
    model = torch.load(opt.load)
    print(sys.COLORS.blue .. '**Pre-trained model loaded**') 
else

model = nn.Sequential()
model:add(nn.SpatialConvolutionMM(3,64,4,4,1,1,0,0)) --I(3x63x63)->O(64x60x60)
model:add(nn.SpatialMaxPooling(2,2,2,2,0,0))--I(64x60x60)->O(64x30x30)
model:add(nn.ReLU())
model:add(nn.SpatialConvolutionMM(64,64,3,3,1,1,0,0))--I(64x30x30)->O(64x28x28)
model:add(nn.SpatialMaxPooling(2,2,2,2,0,0))--I(64x28x28)->O(64x14x14)
model:add(nn.ReLU())
model:add(nn.Reshape(64*14*14))
model:add(nn.Linear(64*14*14,256))--I(64x15x15)->O(256x1x1)
model:add(nn.Dropout())
model:add(nn.ReLU())
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

