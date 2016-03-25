require 'torch'
require 'image'
function randBSC(imag)  --random brightness/saturation/constrast of image
  local c = (torch.round(torch.mul(torch.rand(3),2))+1)/2
  local g = image.rgb2y(imag)
  local Gm = torch.Tensor(imag:size()):fill(g:mean())
  g = torch.repeatTensor(g,3,1,1)
  imag = torch.mul(imag,c:mean())+torch.mul(Gm,(1-c[1]))+torch.mul(g,(1-c[2]))
  return imag
end
function minBSC(imag)  --min brightness/saturation/constrast of image
  local c = torch.Tensor{.5,.5,.5}
  local g = image.rgb2y(imag)
  local Gm = torch.Tensor(imag:size()):fill(g:mean())
  g = torch.repeatTensor(g,3,1,1)
  imag = torch.mul(imag,c:mean())+torch.mul(Gm,(1-c[1]))+torch.mul(g,(1-c[2]))
  return imag
end
function maxBSC(imag)  --max brightness/saturation/constrast of image
  local c = torch.Tensor{1.5,1.5,1.5}
  local g = image.rgb2y(imag)
  local Gm = torch.Tensor(imag:size()):fill(g:mean())
  g = torch.repeatTensor(g,3,1,1)
  imag = torch.mul(imag,c:mean())+torch.mul(Gm,(1-c[1]))+torch.mul(g,(1-c[2]))
  return imag
end
l=image.lena()
for i=1,15 do
image.display(randBSC(l))
end

