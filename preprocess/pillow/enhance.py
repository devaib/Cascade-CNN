from PIL import Image, ImageEnhance
import random

def contrastEnhance(lis):
    # split the list
    im = lis[0]
    imName = lis[1]
    # random number from 0.5 - 1.5
    #contrastIndex = random.uniform(.0, 3.0)
    contrastIndex = random.uniform(.5, 1.5)

    # enhance the image
    contrastEnhancer = ImageEnhance.Contrast(im)
    enhancedIm = contrastEnhancer.enhance(contrastIndex)

    # update image name
    imName = imName + "t" + str(int(contrastIndex)) +  str(contrastIndex - int(contrastIndex))[2:]

    return [enhancedIm, imName]

def brightnessEnhance(lis):
    im = lis[0]
    imName = lis[1]
    #brightnessIndex = random.uniform(.0, 3.0) 
    brightnessIndex = random.uniform(.5, 1.5)
    brightnessEnhancer = ImageEnhance.Brightness(im)
    enhancedIm = brightnessEnhancer.enhance(brightnessIndex)
    imName = imName + "b" + str(int(brightnessIndex)) + str(brightnessIndex - int(brightnessIndex))[2:]
    return [enhancedIm, imName]

def colorEnhance(lis):
    im = lis[0]
    imName = lis[1]
    #colorIndex = random.uniform(.0, 3.0)
    colorIndex = random.uniform(.5, 1.5)
    colorEnhancer = ImageEnhance.Color(im)
    enhancedIm = colorEnhancer.enhance(colorIndex)
    imName = imName + "c" + str(int(colorIndex)) + str(colorIndex - int(colorIndex))[2:]
    return [enhancedIm, imName]


# main function starts
inPath  = "/home/binghao/Desktop/"
outPath = "/home/binghao/Desktop/output/"
ext = ".png"

for i in range(0, 20):
    imageName = str(10)
    im = Image.open(inPath + imageName +".png")

    outImName = ""

    lis = [im, outImName]
    
    if int(random.uniform(1, 2)) == 1:
        out = contrastEnhance(brightnessEnhance(colorEnhance(lis)))

    outIm = out[0]
    outImName = out[1]
    outIm.save(outPath + imageName + "_" + outImName + ext)

    im.close()




