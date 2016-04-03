----------------------------------------------------------------------
-- This script implements a test procedure, to report accuracy
-- on the test data. Nothing fancy here...
--
-- Clement Farabet
----------------------------------------------------------------------

require 'torch'   -- torch
require 'xlua'    -- xlua provides useful tools, like progress bars
require 'optim'   -- an optimization package, for online and batch methods

----------------------------------------------------------------------
print(sys.COLORS.red .. '==> defining some tools')

-- model:
local t = require 'model'
local model = t.model
--model:evaluate()
local loss = t.loss
-- model input dimensions
local mdlH=37
local mdlW=45
local ich=3

-- This matrix records the current confusion across classes
local confusion = optim.ConfusionMatrix(classes)
-- Logger:
local testLogger = optim.Logger(paths.concat(opt.save, 'test_'..opt.fold..'.log'))
local testvldLogger = optim.Logger(paths.concat(opt.save, 'testvld_'..opt.fold..'.log'))
local maxaverageValid=0;--initialisation in percent
-- Batch test:
local inputs = torch.Tensor(opt.batchSize,ich, 
         mdlH, mdlW) -- get size from data
local targets = torch.Tensor(opt.batchSize)

--Unwrap labels
local flippedlabels = torch.LongTensor{1,2,5,4,3,6}

local indx = torch.LongTensor((#testData.labels[1])[1],2)

local indxtmp = torch.LongTensor()
indx[{{},1}] = testData.labels[1]
indx[{{},2}] = torch.range(1,(#testData.labels[1])[1]):type('torch.LongTensor')

for i=2,#testData.labels do
  indxtmp = torch.LongTensor((#testData.labels[i])[1],2)
  indxtmp[{{},1}] = testData.labels[i]
  indxtmp[{{},2}] = torch.range(1,(#testData.labels[i])[1]):type('torch.LongTensor')
  indx=torch.cat(indx,indxtmp,1)
end
indxtmp = nil
--Data augmentation functions

function maxmiddlecrop(img,ich,mdlH,mdlW)
  local  h = img:size(2)
  local  w = img:size(3)
  if h/mdlH<w/mdlW then
  w=torch.round(w*mdlH/h)
  h=mdlH
  elseif h/mdlH>=w/mdlW then
  w=mdlW
  h=torch.round(h*mdlW/w)
  end
  img=image.scale(img,w,h,'bicubic')
  local offsetH=torch.floor(torch.abs(mdlH-h))
  local offsetW=torch.floor(torch.abs(mdlW-w))
  local ima = torch.Tensor(ich,mdlH,mdlW):float()
  ima=img:sub(1,ich,offsetH+1,offsetH+mdlH,offsetW+1,offsetW+mdlW)
  return ima
end


----------------------------------------------------------------------
print(sys.COLORS.red .. '==> defining test procedure')

-- test function
function test(testData)
   -- local vars
   local time = sys.clock()

   -- test over test data
   print(sys.COLORS.red .. '==> testing on test set:')
   for t = 1,testData:size(),opt.batchSize do
      -- disp progress
      xlua.progress(t, testData:size())

      -- batch fits?
      if (t + opt.batchSize - 1) > testData:size() then
         break
      end

      -- create mini batch
      local idx = 1

      for i = t,t+opt.batchSize-1 do
         targets[idx] = indx[i][1]
         --inputs[idx] = maxmiddlecrop(testData.data[targets[idx]][indx[i][2]],ich,mdlH,mdlW)
         inputs[idx] = testData.data[targets[idx]][indx[i][2]]
         --flipping
         if torch.rand(1)[1]>.5 then
          targets[idx] = flippedlabels[targets[idx]]
          inputs[idx] = image.hflip(inputs[idx])
         end
         idx = idx + 1
      end
      
      if opt.type == 'cuda' then 
         inputs = inputs:cuda()
         targets = targets:cuda()
      end
      -- test sample
      model:evaluate()
      local preds = model:forward(inputs)
      model:training()
--print(targets[1])	
--print(math.exp(preds[1][1]))
--print(math.exp(preds[1][2]))
      -- confusion
      for i = 1,opt.batchSize do
         confusion:add(preds[i], targets[i])
      end
      if opt.type == 'cuda' then 
         inputs = inputs:float()
         targets = targets:float()
      end
   end

   -- timing
   time = sys.clock() - time
   time = time / testData:size()
   print("\n==> time to test 1 sample = " .. (time*1000) .. 'ms')

   -- print confusion matrix
   print(confusion) --sys.COLORS.red ..
   
   -- update log/plot
   testLogger:add{['% mean class accuracy (test set)'] = confusion.averageValid * 100}
   testvldLogger:add{['% total class accuracy (test set)'] = confusion.totalValid * 100}
   if opt.plot then
      testLogger:style{['% mean class accuracy (test set)'] = '-'}
      testLogger:plot()
   end

   if maxaverageValid<confusion.averageValid * 100 then
     maxaverageValid=confusion.averageValid * 100
     local filename = paths.concat(opt.save, 'model'..opt.fold..'.net')
     os.execute('mkdir -p ' .. sys.dirname(filename))
     print(sys.COLORS.blue ..'==> saving model to '..filename)
     model1 = model:clone()
     --netLighter(model1) --
     torch.save(filename, model1)
   end
print(' + best average Valid: '..maxaverageValid..'%')

   confusion:zero()
   
end

-- Export:
return test

