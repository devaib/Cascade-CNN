require 'torch'
require 'nn'
require 'image'
require 'csvigo'

W=45
H=38
ich=3
local labelstring={'Closed','Down','Left','Open','Right','Up'}
mdl=torch.load('../model.net')
for feat = 1,6 do
ftr=mdl.modules[1].weight[feat]
--ftr=mdl.modules[1].bias[feat]
print(ftr)

im=torch.mul(torch.reshape(ftr,ich,H,W),20)+.3
image.display(im)
image.savePNG('./Featureimage_'..labelstring[feat]..'.png',im)
               tabled={}

		for i=1,im:size(2) do
		tabled[i] = {}
			for j=1,im:size(3) do
		  		tabled[i][j]=im[1][i][j]
			end
		end
                csvigo.save({ path = './feature1R_'..labelstring[feat]..'.csv', data = tabled, mode = 'raw'})
tabled={}
for i=1,im:size(2) do
		tabled[i] = {}
			for j=1,im:size(3) do
		  		tabled[i][j]=im[2][i][j]
			end
		end


                csvigo.save({ path = './feature1G_'..labelstring[feat]..'.csv', data = tabled, mode = 'raw'})
tabled={}
for i=1,im:size(2) do
		tabled[i] = {}
			for j=1,im:size(3) do
		  		tabled[i][j]=im[3][i][j]
			end
		end


                csvigo.save({ path = './feature1B_'..labelstring[feat]..'.csv', data = tabled, mode = 'raw'})
end

P1 = torch.load('./P1.dat')
P2 = torch.load('./P2.dat')
P3 = torch.load('./P3.dat')
print(P1:size(1),P1:size(2),P1:size(3))
--[[
for i=1,10 do
r=torch.randn(3)*math.sqrt(.1)
image.display(torch.reshape(torch.mul(P1,r[1])+torch.mul(P2,r[2])+torch.mul(P3,r[3]),ich,H,W))
end
--]]
local im139=image.loadPNG('/home/jblan016/Desktop/project/TrainingData/Left/139.png')
im139=image.scale(im139,W,H)
local randLimage=torch.Tensor(im139:size())
print(im139:size(2),im139:size(3))
print(P3:size(2),P3:size(3))

--[[
for i=1,10 do
r=torch.randn(3)*math.sqrt(.1)
randLimage=im139+torch.mul(P1,r[1])+torch.mul(P2,r[2])+torch.mul(P3,r[3])

image.display(torch.reshape(randLimage,ich,H,W))
end
--]]