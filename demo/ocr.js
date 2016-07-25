// function ocr that can recongnize the context of input image
// input image is the captcha of jaccount
// using the trained parameters in ../neural_network
// you can see this file as the javascript easy implementation of some work I have done before

function ocr(img) {
    var canvas = document.createElement('canvas');
    var ctxt = canvas.getContext('2d');
    
    col = 100;
    row = 40;
    
    ctxt.drawImage(img, 0, 0);
    var data = ctxt.getImageData(0, 0, col, row).data;
    
    
    // get image pix data
    var cnt = 0;
    pixdata = new Array();
    for (i = 0; i < row; ++i) {
        pixdata[i] = new Array();
        for (j = 0; j < col; ++j) {
            pixdata[i][j] = new Array();
            for (k = 0; k < 4; ++k) {
                pixdata[i][j][k] = data[cnt++];
            }
        }
    }
    
    
    // binarize
    for (i = 0; i < row; ++i) {
        for (j = 0; j < col; ++j) {
            if (pixdata[i][j][0] < 136) {
                pixdata[i][j][0] = 0;
                pixdata[i][j][1] = 0;
                pixdata[i][j][2] = 0;
                pixdata[i][j][3] = 255;
            }
            if (pixdata[i][j][1] < 136) {
                pixdata[i][j][0] = 0;
                pixdata[i][j][1] = 0;
                pixdata[i][j][2] = 0;
                pixdata[i][j][3] = 255;
            }
            if (pixdata[i][j][2] > 0) {
                pixdata[i][j][0] = 255;
                pixdata[i][j][1] = 255;
                pixdata[i][j][2] = 255;
                pixdata[i][j][3] = 255;
            }
        }
    }
    
    
    // clean image, turn each pix to 0 or 255
    tt = new Array();
    for (i = 0; i < row; ++i) {
        tt[i] = new Array();
        for (j = 0; j < col; ++j) {
            tt[i][j] = pixdata[i][j][0];
        }
    }
    
    
    // split each captcha to single letter
    info = new Array(col);
    for (i = 0; i < col; ++i) info[i] = 0;
    for (j = 0; j < col; ++j) {
        for (i = 0; i < row; ++i) {
            if (tt[i][j] == 0) {
                info[j] = info[j] + 1;
            }
        }
    }
    
    split_line = new Array(10);
    for (i = 0; i < 10; ++i) split_line[i] = 0;
    var cnt = 0;
    for (j = 0; j < col; ++j) {
        if (info[j] != 0) {
            if (j == 0 || j == col) {
                split_line[cnt++] = j;
            }
            else if ((info[j + 1] == 0 && info[j - 1] != 0) || (info[j + 1] != 0 && info[j - 1] == 0)) {
                split_line[cnt++] = j;
            }
        }
    }
    num = cnt / 2;
    
    splited_img = new Array(num);
    for (k = 0; k < num; ++k) {
        // get splited single letter
        gg = new Array(row);
        var wid = split_line[2 * k + 1] - split_line[2 * k] + 1;
        for (i = 0; i < row; ++i) {
            gg[i] = new Array(wid);
            for (j = 0; j < wid; ++j) {
                gg[i][j] = tt[i][j + split_line[2 * k]];
            }
        }
        
        // remove top and bottom
        var topp = 0; 
        var bottom = row - 1;
        var flag = 0;
        for (i = topp; i < row; ++i) {
            for (j = 0; j < wid; ++j) {
                if (gg[i][j] == 0) {
                    topp = i;
                    flag = 1;
                }
                if (flag == 1) {
                    break;
                }
            }
            if (flag == 1){
                break;
            }
        }
        flag = 0;
        for (i = bottom; i >=0; --i) {
            for (j = 0; j < wid; ++j) {
                if (gg[i][j] == 0) {
                    bottom = i;
                    flag = 1;
                }
                if (flag == 1) {
                    break;
                }
            }
            if (flag == 1) {
                break;
            }
        }
        
        var hgt = bottom - topp + 1;
        gg_new = new Array(hgt);
        for (i = 0; i < hgt; ++i) {
            gg_new[i] = new Array(wid);
            for (j = 0; j < wid; ++j) {
                gg_new[i][j] = gg[i + topp][j];
            }
        }
        
        // resize each single letter image to 20 * 30
        max_wid = 30;
        max_hgt = 20;
        gg_final = new Array(max_hgt);
        for (i = 0; i < max_hgt; ++i) {
            gg_final[i] = new Array(max_wid);
            for (j = 0; j < max_wid; ++j) {
                gg_final[i][j] = 1;
            }
        }
        for (i = Math.floor((max_hgt - hgt) / 2); i < Math.floor((max_hgt - hgt) / 2) + hgt; ++i) {
            for (j = Math.floor((max_wid - wid) / 2); j < Math.floor((max_wid - wid) / 2) + wid; ++j) {
                gg_final[i][j] = gg_new[i - Math.floor((max_hgt - hgt) / 2)][j - Math.floor((max_wid - wid) / 2)] / 255;
            }
        }
        
        // reshape each single image matrix to vector
        splited_img[k] = new Array(max_hgt * max_wid + 1);
        splited_img[k][0] = 1;  // colonm one should all be 1
        var cnt = 1;
        for (j = 0; j < max_wid; ++j) {
            for (i = 0; i < max_hgt; ++i) {
                splited_img[k][cnt++] = gg_final[i][j];
            }
        }
        
    }
    
    
    // using neural network forward to recongnize each number
    // Theta1 and Theta2 are store in ./theta1.js and ./theta2.js
    // splited_img * Theta1' * Theta2'
    temp = new Array(num);
    for (i = 0; i < num; ++i) {
        temp[i] = new Array(51);
        temp[i][0] = 1;
    }
    
    // [ones(m, 1), splited_img * Theta1']
    for (i = 0; i < num; ++i) {
        for (j = 0; j < 50; ++j) {
            var dd = 0.0;

            // reduced 4 to accelerate
            for (k = 0; k < 600; k += 4) {
                dd += splited_img[i][k] * Theta1[j][k];
                dd += splited_img[i][k + 1] * Theta1[j][k + 1];
                dd += splited_img[i][k + 2] * Theta1[j][k + 2];
                dd += splited_img[i][k + 3] * Theta1[j][k + 3];
            }
            for (; k < 601; ++k) {
                dd += splited_img[i][k] * Theta1[j][k];
            } 
            
            temp[i][j + 1] = 1 / (1 + Math.exp(-dd));
        }
    }
    result = new Array(num);
    for (i = 0; i < num; ++i) {
        result[i] = new Array(26);
    }
    
    // temp * Theta2'
    for (i = 0; i < num; ++i) {
        for (j = 0; j < 26; ++j) {
            var dd = 0.0;
            
            // reduced 4 to accelerate
            for (k = 0; k < 48; k += 4) {
                dd += temp[i][k] * Theta2[j][k];
                dd += temp[i][k + 1] * Theta2[j][k + 1];
                dd += temp[i][k + 2] * Theta2[j][k + 2];
                dd += temp[i][k + 3] * Theta2[j][k + 3];
            }
            for (; k < 51; ++k) {
                dd += temp[i][k] * Theta2[j][k];
            }
            
            result[i][j] = 1 / (1 + Math.exp(-dd));
        }
    }
    
    
    // get recongnize result
    // it is the max value place of each row of result
    ans = new Array(num);
    for (i = 0; i < num; ++i) {
        max = 0;
        pos = 0;
        for (j = 0; j < 26; ++j) {
            if (result[i][j] > max) {
                max = result[i][j];
                pos = j;
            }
        }
        ans[i] = pos;
    }
    
    var num2letter = ["a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z"];
    
    var text = "";
    for (i = 0; i < num; ++i) {
        text = text + num2letter[ans[i]];
    }
    
    
    return text;
}
