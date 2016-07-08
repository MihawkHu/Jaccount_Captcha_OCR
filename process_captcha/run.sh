#!/bin/bash
path="../get_Captcha/captcha/captcha"

for((i=0;i<1000;i++))
do
    filePath=${path}${i}".jpg"
    python3 ./process_catpcha.py ${filePath}
done
