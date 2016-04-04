require 'image'
filename = '../../../test/img/lena.jpg'

function randBSC(imag)  --random brightness/saturation/constrast of image
  local c = (torch.round(torch.mul(torch.rand(3),2))+1)/2
  local g = image.rgb2y(imag)
  local Gm = torch.Tensor(imag:size()):fill(g:mean())
  g = torch.repeatTensor(g,3,1,1)
  imag = torch.mul(imag,c:mean())+torch.mul(Gm,(1-c[1]))+torch.mul(g,(1-c[2]))
  return imag
end

function randlighting(imag,lbl)
  local r=torch.randn(3)*0.316227; -- r~N(0,sqrt(.1)I)
  imag= imag+torch.mul(P[lbl][1],r[1])+torch.mul(P[lbl][2],r[2])+torch.mul(P[lbl][3],r[3])
return imag
end

function randcropscale(img,ich,mdlH,mdlW)
  local  h = img:size(2)
  local  w = img:size(3)
  local a = math.abs(torch.rand(1)[1]+torch.rand(1)[1]-1)
  if h/mdlH<w/mdlW then
  w=torch.round((1-a)*w+a*w*mdlH/h)
  h=torch.round((1-a)*h+a*mdlH)
  elseif h/mdlH>=w/mdlW then
  w=torch.round((1-a)*w+a*mdlW)
  h=torch.round((1-a)*h+a*h*mdlW/w)
  end
  img=image.scale(img,w,h,'bicubic')
  local offsetH=torch.ceil((torch.abs(mdlH-h)+1)*torch.rand(1)[1])
  local offsetW=torch.ceil((torch.abs(mdlW-w)+1)*torch.rand(1)[1])
  local ima = torch.Tensor(ich,mdlH,mdlW):float()
  ima=img:sub(1,ich,offsetH,offsetH+mdlH-1,offsetW,offsetW+mdlW-1)
  return ima
end

im = image.load(filename)
image.display(im)

imNew = randcropscale(im, 3, 200, 250)
image.display(imNew)



