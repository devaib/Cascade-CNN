require 'torch'   -- torch
require 'image'   -- to visualize the dataset
require 'nn'      -- provides all sorts of trainable modules/layers

print('Model')
torch.setdefaulttensortype('torch.FloatTensor')

if  (opt.load ~= "") then
    model = torch.load(opt.load)
    print(sys.COLORS.blue .. '**Pre-trained model loaded**') 
else	
model = nn.Sequential()
model:add(nn.SpatialConvolutionMM(3,6,38,45,1,1)) --I(1x12x12)->O(16x10x10)
model:add(nn.Reshape(6))
model:add(nn.LogSoftMax())

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
