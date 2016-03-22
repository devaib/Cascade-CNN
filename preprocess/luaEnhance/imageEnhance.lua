require 'torch'
require 'image'

function brightnessEnhance(inputImage, enhanceVal)
    if type(inputImage) ~= "userdata" then error("input argument 1: unexpected type") end
    if type(enhanceVal) ~= "number" then error("input argument 2: unexpected type") end
    if math.abs(enhanceVal) > 1 then error("input argument 2: enhanceVal must range from -1 to 1") end

    local outputImage = inputImage + enhanceVal
    
    outputImage:apply(function(x)
            if x < 0 then return 0 end
            if x > 1 then return 1 end 
        end)

    return outputImage
end

function contrastEnhance(inputImage, enhanceVal)
    if type(inputImage) ~= "userdata" then error("input argument 1: unexpected type") end
    if type(enhanceVal) ~= "number" then error("input argument 2: unexpected type") end
    if math.abs(enhanceVal) > 1 then error("input argument 2: enhanceVal must range from -1 to 1") end

    local correctionFactor = 259 * (enhanceVal + 1) / (259 - enhanceVal * 255)
    local outputImage = torch.mul((inputImage - 0.5), correctionFactor) + 0.5 

    outputImage:apply(function(x)
            if x < 0 then return 0 end
            if x > 1 then return 1 end
        end)

    return outputImage
end

-- test
local filename = './38.png'
local srcImage = image.load(filename)

local tBrightness = 0
local tContrast = 0

local saveImage = true 
t0 = os.time()
for i = -10, 10 do
    local brightImage = brightnessEnhance(srcImage, i/10)
    local contrastImage = contrastEnhance(srcImage, i/10)

    if (saveImage) then
        image.save('./brightnessEnhanced/38#'..i..'.png', brightImage)
        image.save('./contrastEnhanced/38#'..i..'.png', contrastImage)
    end
end

print("time: "..os.difftime(os.time(), t0).."s")
print("done")


