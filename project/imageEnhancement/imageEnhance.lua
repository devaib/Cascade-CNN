require 'torch'
require 'image'

function brightnessEnhance(inputImage, enhanceVal)
    if type(inputImage) ~= "userdata"
        then error("input argument 1: unexpected type")
    end
    if type(enhanceVal) ~= "number"
        then error("input argument 2: unexpected type")
    end

    local outputImage = inputImage + enhanceVal
    return outputImage
end

function contrastEnhance(inputImage, enhanceRate)
    if type(inputImage) ~= "userdata"
        then error("input argument 1: unexpected type")
    end
    if type(enhanceRate) ~= "number"
        then error("input argument 2: unexpected type")
    end

    local outputImage = inputImage * enhanceRate
    return outputImage
end

local filename = '/home/binghao/Desktop/0.png'
local srcImage = image.load(filename)

local brightImage = brightnessEnhance(srcImage, .5)
local contrastImage = contrastEnhance(srcImage, 3.5)

image.save('./0_1.png', brightImage)
image.save('./0_2.png', contrastImage)


