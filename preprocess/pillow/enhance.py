from PIL import Image, ImageEnhance
import random
import shutil
import os

def contrastEnhance(lis):
    # split the list
    im = lis[0]
    imName = lis[1]
    # random number from 0.5 - 1.5
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
    brightnessIndex = random.uniform(.5, 1.5)
    brightnessEnhancer = ImageEnhance.Brightness(im)
    enhancedIm = brightnessEnhancer.enhance(brightnessIndex)
    imName = imName + "b" + str(int(brightnessIndex)) + str(brightnessIndex - int(brightnessIndex))[2:]
    return [enhancedIm, imName]

def colorEnhance(lis):
    im = lis[0]
    imName = lis[1]
    colorIndex = random.uniform(.5, 1.5)
    colorEnhancer = ImageEnhance.Color(im)
    enhancedIm = colorEnhancer.enhance(colorIndex)
    imName = imName + "c" + str(int(colorIndex)) + str(colorIndex - int(colorIndex))[2:]
    return [enhancedIm, imName]


# main function starts
inPath  = "/home/binghao/Desktop/TrainingData/Closed/"
outPath = "/home/binghao/Desktop/output/"
ext = ".png"

shutil.rmtree("/home/binghao/Desktop/output/")
if not os.path.exists(outPath):
    os.makedirs(outPath)

totalImageNum = 1000
for imageNum in range(0, totalImageNum):
    imageName = str(imageNum)
    im = Image.open(inPath + imageName +".png")

    for i in range(0, 10):

        outImName = ""

        lis = [im, outImName]

        randomNum = random.uniform(1, 7)
        if int(randomNum) == 1:
            out = contrastEnhance(brightnessEnhance(colorEnhance(lis)))
        elif int(randomNum) == 2:
            out = contrastEnhance(colorEnhance(brightnessEnhance(lis)))
        elif int(randomNum) == 3:
            out = brightnessEnhance(contrastEnhance(colorEnhance(lis)))
        elif int(randomNum) == 4:
            out = brightnessEnhance(colorEnhance(contrastEnhance(lis)))
        elif int(randomNum) == 5:
            out = colorEnhance(contrastEnhance(brightnessEnhance(lis)))
        elif int(randomNum) == 6:
            out = colorEnhance(brightnessEnhance(contrastEnhance(lis)))

        outIm = out[0]
        outImName = out[1]
        outIm.save(outPath + imageName + "_" + outImName + ext)

    im.close()

    print(str(int(float(imageNum) / float(totalImageNum) * 100)) + '%')




