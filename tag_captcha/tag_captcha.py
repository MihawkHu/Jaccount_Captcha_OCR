# tag each single splited resized captcha got in ../split_captcha/captcha_splited_resized/
# based on tessetact-ocr, an open project
# I tried to use ocrad.js at first but failed
# the tag results of each letter will be saved in their file names
# I managed to use neural network to train them at next step
# the wrong tag results will be removed by people

import Image
from pytesseract import image_to_string


tag_results = open("./tag_results.txt", "w")

for i in range(0, 4437):
    filePath = "../split_captcha/captcha_splited_resized/" + str(i) + ".bmp"
    img = Image.open(filePath)
    
    ans = image_to_string(img, lang='eng', config='-psm 10 digits')
    
    savePath = "./captcha_tagged/" + str(i) + ans + ".bmp"
    img.save(savePath)
    
    write_str = str(i) + " " + ans + "\n"
    tag_results.write(write_str)
    