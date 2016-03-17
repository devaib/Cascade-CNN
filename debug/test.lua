require 'nn'
require 'nnx'
require 'image'
require 'torch'

path = '/home/binghao'

-- load image
filename = path .. '/cnn/debug/demo/images/group1.jpg'
--filename = path .. '/cnn/debug/resize.jpg'
-- filename = path .. '/cnn/debug/2_1_111.jpg'
im = image.load(filename):float()
im = image.rgb2y(im)
-- preprocess
-- imean=torch.load('./mean().dat')[1]
-- istd=torch.load('./std().dat')[1]
imean = im:mean()
istd = im:std()
im:add(-imean)
im:div(istd)
print('mean:', imean, 'std:', istd)

--image.display(im)
im = image.scale(im, 75, 50)

--image.save('./resize.jpg', im)
--image.display(im)
torch.setdefaulttensortype('torch.FloatTensor')
model = torch.load(path .. '/cnn/debug/12cnet/model.net')

--[[
net12 = nn.Sequential()
for i=1,7 do
    net12:add(model.modules[i])
end
classifier1 = nn.Sequential()
for i=8,10 do 
    classifier1:add(model.modules[i])
end
classifier = nn.SpatialClassifier(classifier1)
net12:add(classifier)
net12:evaluate()
net12.modules[8].modules[1]:evaluate()
net12:float()

]]
model:evaluate()

net = nn.Sequential()
net:add(model.modules[1])
net:add(model.modules[2])
net:add(model.modules[3])
net:add(model.modules[4])
segment = torch.reshape(im[{1,{1, 12},{1, 12}}],1,12,12)
counter = 0
out = 0
y = model:forward(segment)
print(torch.exp(y))
print(model)
print(net)

--[[
for i = 1,39,4 do
  for j = 1,64,4 do
        segment = torch.reshape(im[{1,{i, i+11},{j, j+11}}],1,12,12)
        --image.display(segment)
        y=net12:forward(segment)
        if torch.exp(y[1]) > 0.0 then
            print(y)
            -- print(counter , ": ", 6*(i-1), 6*(j-1) ,torch.exp(y[1]))
        end
        counter = counter + 1
    end
end
]]

--print(y[1])
-- print(segment)
-- y=model:forward(segment)
-- print(torch.exp(y))

-- segment = torch.Tensor(1,12,12):fill(0.5):float()
-- segment = im
-- print(segment)

--[[
net12 = nn.Sequential()
net12:add(model.modules[1])
net12:add(model.modules[3])
net12:add(model.modules[4])
net12:add(model.modules[5])
net12:add(model.modules[7])
net12:add(model.modules[8])
net12:add(model.modules[9])
net12:add(model.modules[10])

y=net12:forward(segment)
]]


