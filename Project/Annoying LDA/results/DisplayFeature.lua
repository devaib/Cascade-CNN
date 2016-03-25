require 'torch'
require 'nn'
require 'image'
require 'csvigo'

W=45
H=38
ich=3
local labelstring={'Closed','Down','Left','Open','Right','Up'}
mdl=torch.load('LDAmodel.net')
for feat = 1,6 do
ftr=mdl.modules[1].weight[feat]
--ftr=mdl.modules[1].bias[feat]
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
