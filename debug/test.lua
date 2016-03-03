require 'nn'
require 'nnx'
require 'image'
require 'torch'

-- load image
local filename = '/Users/wbh/cnn/test/img/group1.jpg'
local im =  image.load(filename):float()
im = image.rgb2y(im)
im = image.scale(im, 75, 50)

-- preprocess
local imean=im:mean()
local istd=im:std()
im:add(-imean)
im:div(istd)
print(im)

torch.setdefaulttensortype('torch.FloatTensor')
model = torch.load('/Users/wbh/faceClassifier/weights/model.net')


net12 = nn.Sequential()
net12:add(network1.modules[1])
net12:add(network1.modules[2])
net12:add(network1.modules[3])
net12:add(network1.modules[4])
net12:add(network1.modules[5])
net12:add(network1.modules[6])
net12:add(network1.modules[7])
net12:add(network1.modules[8])

--y=net12:forward(im)
--print(y)

--[[
network1:float()
net12 = nn.Sequential()
net12:add(network1.modules[1])
net12:add(network1.modules[2])
net12:add(network1.modules[3])
net12:add(network1.modules[4])
net12:add(network1.modules[5])
net12:add(network1.modules[6])
net12:add(network1.modules[7])
net12:add(network1.modules[8])

im=image.rgb2y(im)
y=net12:forward(im)
y = torch.exp(y)
print(y)
]]
