------------------------------------------------------------------------------
-- Preprocessing to apply to each dataset
------------------------------------------------------------------------------
-- Alfredo Canziani May 2013, E. Culurciello June 2014
------------------------------------------------------------------------------

print(sys.COLORS.red ..  '==> preprocessing data')

local channels = {'r','g','b'}

local Width = 67  
local Height = 67  
-- Normalize each channel, and store mean/std
-- per channel. These values are important, as they are part of
-- the trainable parameters. At test time, test data will be normalized
-- using these values.
print(sys.COLORS.red ..  '==> preprocessing data: global normalization:')

local mean = {}
local std = {}
local numlbls=#trainData.data
local cnt=0

-- compute means/stds
for i,channel in ipairs(channels) do
  mean[i]=0
  std[i]=0
  cnt=0
  for j = 1, numlbls do
     for k=1, #trainData.data[j] do
     mean[i]=mean[i]+trainData.data[j][k][{ i,{},{} }]:mean()
     std[i]=std[i]+trainData.data[j][k][{ i,{},{} }]:std()
     cnt=cnt+1
     end
  end
  mean[i]=mean[i]/cnt
  std[i]=std[i]/cnt
end

-- Normalize each channel globally:
for i,channel in ipairs(channels) do
  for j = 1, numlbls do
     for k=1, #trainData.data[j] do
     trainData.data[j][k][{ i,{},{} }]:add(-mean[i])
     trainData.data[j][k][{ i,{},{} }]:div(std[i])
     end
  end
end




----------------------------------------------------------------------
print(sys.COLORS.red ..  '==> verify statistics:')



for i,channel in ipairs(channels) do
  trainMean=0
  trainStd=0
  cnt=0
  for j = 1, numlbls do
     for k=1, #trainData.data[j] do
     trainMean=trainMean+trainData.data[j][k][{ i,{},{} }]:mean()
     trainStd=trainStd+trainData.data[j][k][{ i,{},{} }]:std()
     cnt=cnt+1
     end
  end
  trainMean=trainMean/cnt
  trainStd=trainStd/cnt
  

   print('       training data, '..channel..'-channel, mean:                         ' .. trainMean)
   print('       training data, '..channel..'-channel, standard deviation:           ' .. trainStd)

   print('       prenormalized training data, '..channel..'-channel, mean:           ' .. mean[i])
end


torch.save('results/mean.dat',mean)
torch.save('results/std.dat',std)
----------------------------------------------------------------------
print(sys.COLORS.red ..  '==> visualizing data:')

-- Visualization is quite easy, using image.display(). Check out:
-- help(image.display), for more info about options.

if opt.visualize then
   -- Showing some training exaples
   local first128Samples = trainData.data[{ {1,128} }]
   image.display{image=first128Samples, nrow=16, legend='Some training examples'}
   -- Showing some testing exaples
   local first128Samples = testData.data[{ {1,128} }]
   image.display{image=first128Samples, nrow=16, legend='Some testing examples'}
end

   


