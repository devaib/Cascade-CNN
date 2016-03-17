require 'torch'
require 'nn'
require 'nnx'
require 'image'

net12_path = './model.net'

network_temp = torch.load(net12_path)
print(network_temp)
net12 = nn.Sequential()
for i=1,7 do
    net12:add(network_temp.modules[i])
end
classifier1 = nn.Sequential()
for i=8,10 do 
    classifier1:add(network_temp.modules[i])
end
classifier = nn.SpatialClassifier(classifier1)
net12:add(classifier)
net12:evaluate()
net12.modules[8].modules[1]:evaluate()
net12:float()
print(net12)
print(classifier1)

net12.modules[8].spatialOutput = false

im = image.load('/home/binghao/cnn/debug/demo/images/group1.jpg')
im = image.rgb2y(im)
    local imean = im:mean()
    local istd = im:std()
    im:add(-imean)
    im:div(istd)
im = image.scale(im, 75, 50)


a = net12:updateOutput(im:float())


--print(a)
print(torch.exp(a[{1,{},{}}]))

