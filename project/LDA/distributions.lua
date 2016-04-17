--require('mobdebug').start()
require 'image'   -- to visualize the dataset
require 'math'
require 'nn'
require 'csvigo'
----------------------------------------------------------------------
mean=torch.load('results/mean.dat')
std=torch.load('results/std.dat')
channels={'r','g','b'}
torch.manualSeed(1234)
TotNumberperLbl=500000
setSplit=.05
mdl=torch.load('results/LDAmodel.net'):float()
--mdl:remove(3)
print(mdl)
featurenumber=2
function loadDataFiles(class_dir)
    local i,t,popen = 0, {}, io.popen
    for filename in popen('ls -A "'..class_dir..'"' ):lines() do
	i = i + 1
	t[i]=class_dir..filename
    end
    return t, i
end

function ShuffleAndDivideSets(List,SizeImageList)
  local shuffle=torch.randperm(SizeImageList)
  local MaxSize=math.min(SizeImageList,TotNumberperLbl)
  local TrainSize=math.ceil((1-setSplit)*MaxSize)
  local TestSize=MaxSize-TrainSize
  local trainList={}
  local testList={}
  for i=1,TrainSize do
  trainList[i]=List[shuffle[i]]
  end
  for i=TrainSize+1,MaxSize do
  testList[i-TrainSize]=List[shuffle[i]]
  end
return trainList, testList, TrainSize, TestSize
end
-----------------------------------------------------------------------


local desImaX = 45  --Image Width
local desImaY = 38  --Image Height
local ivch = 3
local numblbls=6 -- eventually... put a function that counts the number of folders to make the numblbls reading automatic
local crdnlty=torch.Tensor(numblbls,2)-- to store training/test data lengths  respectively [#trainData_i,#testData_i],i in [1,6]
local labelstring={'Closed','Down','Left','Open','Right','Up'}
local flippedlabel=torch.Tensor{1,2,5,4,3,6}
---------loop to load ALL data
for lbl=1,numblbls do --labels
imageslist, SizeImageList = loadDataFiles('/home/binghao/Desktop/TrainingData/'..labelstring[lbl]..'_Flipped/')
imageslist, imageslistt, crdnlty[{lbl,1}], crdnlty[{lbl,2}] = ShuffleAndDivideSets(imageslist,SizeImageList)


		      trdata = torch.FloatTensor(crdnlty[{lbl,1}], ivch, desImaX, desImaY):fill(0)
		      tedata = torch.FloatTensor(crdnlty[{lbl,2}], ivch, desImaX, desImaY):fill(0)


		for j,filename in ipairs(imageslist) do
			print(filename)

			local im =  image.loadPNG(filename):float()

			trdata[j] =  image.scale(im,desImaX,desImaY)
		end
		imageslist = nil
			for v,channel in ipairs(channels) do
			   -- normalize each channel globally:
			   trdata[{ {},v,{},{} }]:add(-mean[v])
			   trdata[{ {},v,{},{} }]:div(std[v])
			end
   		print('train data loaded for label '..lbl)

		for j,filename in ipairs(imageslistt) do
                        print(filename)

			local im =  image.loadPNG(filename):float()
			tedata[j] =  image.scale(im,desImaX,desImaY)

		end
		print('test data loaded for label '..lbl)
	   	imageslistt = nil
                local vec = mdl:forward(trdata)[{{},{featurenumber}}]
                tabled={}
print(vec)
		tabled[1] = {}
		for i=1,vec:size(1) do
		  tabled[1][i]=vec[i][1]
		end

print(type(tabled))

                csvigo.save({data = tabled, path = './results/distsCLASS'..lbl..'.csv', mode = 'raw'})
data=nil
tabled=nil
collectgarbage()

end