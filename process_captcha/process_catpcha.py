# clean and binarization single captcha, then resize them to larger scale
# in order to increase reconiziton accuracy

import sys
import re
import os
from PIL import Image

if __name__ != '__main__':
    print("Error1: Not itself.")

filePath = str(sys.argv[1])
download = "captcha_processed"
# image = Image.open(imagePath)

def getSavePath(filePath):
    cap = str(re.findall("captcha[0-9]+.jpg", filePath)[0])
    savePath = download + "/" + cap;
    directory = os.path.dirname(savePath)
    
    if not os.path.exists(directory):
        os.makedirs(directory)
    
    return savePath
    
    
#  binarization
def binarize(image):
    pixdata = image.load()
    for y in range(image.size[1]):
        for x in range(image.size[0]):
            if pixdata[x, y][0] < 136:
                pixdata[x, y] = (0, 0, 0, 255)
                
    for y in range(image.size[1]):
        for x in range(image.size[0]):
            if pixdata[x, y][1] < 136:
                pixdata[x, y] = (0, 0, 0, 255)
                
    for y in range(image.size[1]):
        for x in range(image.size[0]):
            if pixdata[x, y][2] > 0:
                pixdata[x, y] = (255, 255, 255, 255)
                
    return image


# enlarge image
def larger(image):
    image = image.resize((1000, 500), Image.NEAREST)
    return image


img = Image.open(filePath)
savePath = getSavePath(filePath)
img = img.convert("RGBA")
binarize(img)
# larger(img)
img.save(savePath)

    
