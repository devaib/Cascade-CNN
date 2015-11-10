require 'nn'
require 'image'
require 'torch'
local filename ='/home/binghao/cnn/src/1.jpg'
local im =  image.load(filename):float()
torch.setdefaulttensortype('torch.FloatTensor')
network1 = torch.load('/home/binghao/cnn/model.net')
net12 = nn.Sequential()
net12:add(network1.modules[1])
im=image.rgb2y(im)
print(im)
y=net12:forward(im)
print(y)
torch.save('test2.dat',y)
--y=torch.load('test1.dat')
