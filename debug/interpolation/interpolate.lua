require "image"
require 'csvigo'

imageFileName = "../../test/img/38.png";
im = image.load(imageFileName):float()
-- im = image.rgb2y(im)

torchBilinear = image.scale(im, 200, 300, 'bilinear')
torchBicubic  = image.scale(im, 200, 300, 'bicubic')
torchSimple   = image.scale(im, 200, 300, 'simple')

image.save("./torchBilinear.png", torchBilinear)
image.save("./torchBicubic.png",  torchBicubic)
image.save("./torchSimple.png",   torchSimple)

--[[
thBilinear = {}
for i = 1, 300 do
    thBilinear[i] = {}
    for j = 1, 200 do
        thBilinear[i][j] = torchBilinear[1][i][j]
    end
end

thBicubic = {}
for i = 1, 300 do
    thBicubic[i] = {}
    for j = 1, 200 do
        thBicubic[i][j] = torchBicubic[1][i][j]
    end
end

thSimple= {}
for i = 1, 300 do
    thSimple[i] = {}
    for j = 1, 200 do
        thSimple[i][j] = torchSimple[1][i][j]
    end
end

csvigo.save({path = './thBilinear.csv', data = thBilinear, mode = 'raw'})
csvigo.save({path = './thBicubic.csv',  data = thBicubic,  mode = 'raw'})
csvigo.save({path = './thSimple.csv',   data = thSimple,   mode = 'raw'})
]]
