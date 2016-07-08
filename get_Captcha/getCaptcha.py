# get the a lot of captcha in jaccount login page and save them
# These captcha will used as training examples in the next

import re
import os
import time
import random
from urllib.request import Request
from urllib.request import urlretrieve
from urllib.request import urlopen
from bs4 import BeautifulSoup
from PIL import Image
from PIL import ImageOps


baseUrl = "https://jaccount.sjtu.edu.cn/jaccount/login?sid=jaxuanke091229&returl=CCPoaC0FB2F2d9T5tCzRgtb9jd2LkMjK4CXRISrL1OL5bP2er1nAn55elInmTOaIij6r4u3dfy9V&se=COp1UwVpS05MnZQcTVLvNzrZIfGd23i3VYmFDLh8qHuFfltxZmFXINA%3d&v=null"
head = {'User-Agent':'Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.1.6) Gecko/20091201 Firefox/3.5.6'}

req = Request(url = baseUrl, headers = head)
html = urlopen(req)
bsObj = BeautifulSoup(html)

download = "captcha"
def getPath(downloadDir, num):
    path = downloadDir + "/captcha" + str(num) + ".jpg"
    directory = os.path.dirname(path)
    
    if not os.path.exists(directory):
        os.makedirs(directory)
    
    return path

# simplely clean the image
# I managed to single-value these images in the next
def cleanImage(imagePath):
    image = Image.open(imagePath)
    image = image.point(lambda x: 0 if x < 143 else 255)
    borderImage = ImageOps.expand(image, border = 20, fill = "white")
    borderImage.save(imagePath)


for i in range(0, 1000):
    link = bsObj.findAll("img", src = re.compile("captcha.*"))[0]["src"]
    fileUrl = "https://jaccount.sjtu.edu.cn/jaccount/" + link
    savePath = getPath(download, i)
    urlretrieve(fileUrl, savePath)
    # cleanImage(savePath)
    waitTime = random.randint(2, 5) # wait for a moment to avoid checking water meter
    print(i, ":", "wait", waitTime, "seconds")
    time.sleep(waitTime)
    
    