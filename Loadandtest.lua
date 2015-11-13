require 'nn'
require 'image'
require 'torch'
-- local filename ='/home/binghao/cnn/cat12.jpg'
local filename ='/Users/wbh/cnn/cat12.jpg'
local im =  image.load(filename):float()
torch.setdefaulttensortype('torch.FloatTensor')
-- network1 = torch.load('/home/binghao/cnn/model.net')
network1 = torch.load('/Users/wbh/cnn/model.net')
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
-- print(im)
y=net12:forward(im)
print(y)
-- torch.save('test3.dat',y)
-- y=torch.load('test1.dat')
