require 'nn'
require 'nnx'
require 'image'
require 'torch'

path = '/home/binghao'

-- load image
filename = path .. '/cnn/test/img/group1.jpg'
im =  image.load(filename):float()
im = image.rgb2y(im)
-- im = image.scale(im, 75, 50)
print(im)

--[[
-- preprocess
imean=im:mean()
istd=im:std()
im:add(-imean)
im:div(istd)

torch.setdefaulttensortype('torch.FloatTensor')
model = torch.load(path .. '/cnn/debug/model.net')

net12 = nn.Sequential()
net12:add(model.modules[1])
net12:add(model.modules[2])
net12:add(model.modules[3])
net12:add(model.modules[4])
net12:add(model.modules[5])
net12:add(model.modules[6])
net12:add(model.modules[7])
net12:add(model.modules[8])

y=net12:forward(im)
--print(y)

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
