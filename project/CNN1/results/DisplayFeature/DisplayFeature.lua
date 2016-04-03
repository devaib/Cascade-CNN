require 'torch'
require 'nn'
require 'image'
require 'csvigo'

W=45
H=37
ich=3
var=1
local labelstring={'Closed','Down','Left','Open','Right','Up'}
mdl=torch.load('../LDAresults/model.net')

function print_r ( t )  
    local print_r_cache={}
    local function sub_print_r(t,indent)
        if (print_r_cache[tostring(t)]) then
            print(indent.."*"..tostring(t))
        else
            print_r_cache[tostring(t)]=true
            if (type(t)=="table") then
                for pos,val in pairs(t) do
                    if (type(val)=="table") then
                        print(indent.."["..pos.."] => "..tostring(t).." {")
                        sub_print_r(val,indent..string.rep(" ",string.len(pos)+8))
                        print(indent..string.rep(" ",string.len(pos)+6).."}")
                    elseif (type(val)=="string") then
                        print(indent.."["..pos..'] => "'..val..'"')
                    else
                        print(indent.."["..pos.."] => "..tostring(val))
                    end
                end
            else
                print(indent..tostring(t))
            end
        end
    end
    if (type(t)=="table") then
        print(tostring(t).." {")
        sub_print_r(t,"  ")
        print("}")
    else
        sub_print_r(t,"  ")
    end
    print()
end


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

P = torch.load('./P.dat')

print(torch.add(P[2][1],-P[1][1]))
io.stdin:read'*l'
for i=1,1 do
r=torch.randn(3)*math.sqrt(.1)
for lbl=1,6 do


image.display(torch.reshape(torch.mul(P[lbl][1],r[1])+torch.mul(P[lbl][2],r[2])+torch.mul(P[lbl][3],r[3]),ich,H,W))
end
end
local im139=image.loadPNG('/home/jblan016/Desktop/project/TrainingData/Left/139.png') --I(3xHxW)
image.display(im139)
print('im139 size=',im139:size(1),im139:size(2),im139:size(3))
im=torch.Tensor(3,H,W)
im=image.scale(im139,W,H,'bicubic'):float() --BEWARE THIS IS A WARP change implementation to A.Howard's.
image.display(im)
print('im size=',im:size(1),im:size(2),im:size(3))
--print('P size=',P1:size(1),P1:size(2),P1:size(3))
local randLimage=torch.Tensor(im:size())
--[[
for i=1,10 do
r=torch.randn(3)*math.sqrt(var)
randLimage=im+torch.mul(P1,r[1])+torch.mul(P2,r[2])+torch.mul(P3,r[3])
image.display(randLimage)
end

--]]
