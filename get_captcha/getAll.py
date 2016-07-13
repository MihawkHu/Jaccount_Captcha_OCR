#  get all the content of the jaccount login page

import os
from urllib.request import urlretrieve
from urllib.request import urlopen
from bs4 import BeautifulSoup

downloadDirectory = "download"
baseUrl = "https://jaccount.sjtu.edu.cn/jaccount/login?sid=jaxuanke091229&returl=CHCAyMbLKOmHTa%2bSIG6pIhf7kKazckSmfmP8ZKFE0IfWjRA5myOI1VMl3fcqCwP2M3bSeMBCiO7v&se=CHZcS6A1pLRuwY9el85COxLihM2B7GsREHRgf7PNcRHQG1A%2bv3E8LkM%3d&v=null"


def getAbsoluteUrl(baseUrl, source):
    if source.startswith("http://www."):
        url = "http://" + source[11:]
    # elif source.startswith("https://www."):
        # url = "https://" + source[12:]
    elif source.startswith("http://"):
        url = source
    elif source.startswith("https://"):
        url = source
    elif source.startswith("www."):
        url = "http://" + source[4:]
    else:
        url = baseUrl + "/" + source
    if baseUrl not in url:
        return None
    return url
    
def getDownloadPath(baseUrl, absoluteUrl, downloadDirectory):
    path = absoluteUrl.replace("www.", "")
    path = path.replace(baseUrl, "")
    path = downloadDirectory + path
    directory = os.path.dirname(path)
    
    if not os.path.exists(directory):
        os.makedirs(directory)
    
    return path
    
html = urlopen(baseUrl)
bsObj = BeautifulSoup(html)
downLoadList = bsObj.findAll(src = True)

for download in downLoadList:
    fileUrl = getAbsoluteUrl(baseUrl, download["src"])
    if fileUrl is not None:
        print(fileUrl)
        urlretrieve(fileUrl, getDownloadPath(baseUrl, fileUrl, downloadDirectory))
    
    