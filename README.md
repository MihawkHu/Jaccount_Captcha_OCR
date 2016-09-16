# Jaccount_Captcha_OCR
To recognize the captcha in Jaccount login page.

### Overview
This is the repository for SJTU jaccount login page. The chrome extension is put in the *./chrome_extension*, you can using chrome development mode to load it after downloading. 
Maybe I will submit it to chrome web store in one day.  
After you install this extension, the captcha in SJTU jaccount login page will be filled in 
automatically.

<img src="/demo/pic.png" width=800p> 

### Implementation
The core method for recognition is neural network. Get lot of captcha and processed them as traning set. Using two layer neural network. The final recognition accuracy is almost 99%. The code and results of each step is saved in each folded such as *./get_captcha/*.  

* Get captcha  
    Using python to get lot of captcha on login page.  
    ![captcha1](/get_captcha/captcha/captcha1.jpg)  
    
* process captcha  
    Clean and binarize single captcha.  
    ![captcha2](/process_captcha/captcha_processed/captcha1.jpg)  
    
* Split captcha  
    Split each captcha to single letter, then resize them to the same size.  
    ![tt1](/split_captcha/captcha_splited_resized/4.bmp)　　
    ![tt1](/split_captcha/captcha_splited_resized/5.bmp)　　
    ![tt1](/split_captcha/captcha_splited_resized/6.bmp)　　
    ![tt1](/split_captcha/captcha_splited_resized/7.bmp)　　
    ![tt1](/split_captcha/captcha_splited_resized/8.bmp)  
    
* Tag captcha  
    Tag each single letter. Use tessetact-ocr. The wrong tag results will be fixed by people.  
    
* Neural network  
    Using 2 layer neural network to train data set. The recognition accuracy of each single letter is almost 99.7%.
    
### Demo
Download the repository and you can using local captcha to test this recognition system.  

<img src="/demo/demo_pic.png" width=800p> 

