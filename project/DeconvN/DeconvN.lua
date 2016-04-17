require 'torch'
require 'image'
require 'nn'
require 'cunn'
require 'cudnn'

---------------------------------
function filterTranspose(W,indim,outdim,h,w)
local Wr=torch.reshape(  W  , torch.LongStorage{indim, outdim, h, w})
local Wrt=torch.reshape(  Wr:transpose(1,2)  , torch.LongStorage{indim, outdim*h*w})
return Wrt
end

--------------------------------




imglbl={'114','87','64','31','16','66'}
for k,lbl in ipairs(imglbl) do
channels={'r','g','b'}
labels={'C','D','L','O','R','U'}
torch.setdefaulttensortype('torch.FloatTensor')
mdldir='/home/jblan016/Desktop/project/DeconvN/conv/results/modelV.net'
mdl = torch.load(mdldir)
mdl:evaluate()
mdl:float()
local mean =torch.load('/home/jblan016/Desktop/project/CNNFinal/results/mean.dat',mean)
local std = torch.load('/home/jblan016/Desktop/project/CNNFinal/results/std.dat',std)
direct='/home/jblan016/Desktop/project/NewRandomizedTestData/'
imgaddress=direct..lbl..'.png'

img=image.loadPNG(imgaddress):float()--will return a --I(3xHxW)
img=image.scale(img,63,63,'bicubic')
for i,channel in ipairs(channels) do
img[i]=img[i]:add(-mean[i])
img[i]=img[i]:div(std[i])
end
print(mdl)
p=torch.exp(mdl:forward(img))
--print(out)
mdl:remove()
unpool2=nn.SpatialMaxUnpooling(mdl.modules[2])
unpool1=nn.SpatialMaxUnpooling(mdl.modules[5])
out=mdl:forward(img)

deconv=nn.Sequential()

deconv:add(nn.Linear(6,256))
deconv.modules[1].weight=(mdl.modules[11].weight):t()
deconv.modules[1].bias:fill(0)

deconv:add(nn.ReLU())

deconv:add(nn.Linear(256, 64 * 14 * 14))
deconv.modules[3].weight=(mdl.modules[8].weight):t()
deconv.modules[3].bias:fill(0)

deconv:add(nn.ReLU())
deconv:add(nn.Reshape(64,14,14))

inhat=deconv:forward(out)
--print(inhat:size())
--print(inhat[1])
inhat2=unpool1:forward(inhat)
--inhat2=inhat2[{{},{1,28},{1,28}}]  --Definetly a bug... unpooling adds zero padding in the last columns and row for no reason
--print(inhat2:size())
--print(inhat2[1])



dcv2=nn.SpatialConvolutionMM(64,64,3,3,1,1,2,2)
dcv2.weight=filterTranspose(mdl.modules[4].weight,64,64,3,3)
dcv2.bias:fill(0)
inhat3=dcv2:forward(inhat2)--not akin to gradient ascent
--print(inhat3:size())
--print(inhat3[1])

R=nn.ReLU()
imhat3=R:forward(inhat3)
print(inhat3:size())
print(inhat3[1])

inhat4=unpool2:forward(imhat3)
print(inhat4:size())
--print(inhat4[1])



dcv3=nn.SpatialConvolutionMM(64,3,4,4,1,1,0,0)
--print(dcv3.weight)
dcv3.weight=filterTranspose(mdl.modules[1].weight,3,64,4,4)
dcv3.bias:fill(0)
--print(dcv3.weight)
inhat5=dcv3:forward(inhat4)--not akin to gradient ascent
print(inhat5:size())
print(p)
image.display(inhat5:float())
end
--deconv:add(nn.Linear(256, 64 * 15 * 15))
--deconv.modules[3].bias:fill(0)
--w=filterTranspose(  mdl.modules[7].weight  ,256, 64, 15, 15) 
--print(w:size())


--deconv.modules[3].weight=w
--

--]]
--print(out)
--print(mdl.modules[11].weight)
--[[
bias11=mdl.modules[11].bias
bxo=torch.dot(bias11,out)
bxo=torch.Tensor{bxo}
weight11=mdl.modules[11].weight
inhat=torch.mv(weight11:t(), out)
inhat=torch.cat(bxo,inhat)
inhat=(nn.ReLU()):forward(inhat)
--]]
