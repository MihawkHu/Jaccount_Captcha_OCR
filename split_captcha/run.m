% split all 1000 captcha
% and resize them to the same size
% wrong splited captcha will be coped with by people

max_wid = 0;
max_len = 0;
i = 0;
idx = 0;
for i = 0 : 999
    filePath = strcat("../process_captcha/captcha_processed/captcha", num2str(i), ".jpg");
    [num, wid, len] = split_captcha(filePath, idx);
    idx = idx + num;
    
    if max_wid < wid
        max_wid = wid;
    end
    if max_len < len
        max_len = len;
    end
end

% resize them to the same size
% save in ./captcha_splited_2/
% max_len = 30
% max_wid = 19
for i = 0 : 4436
    filePath = strcat("./captcha_splited/", num2str(i), ".bmp");
    img = imread(filePath);
    row = size(img, 1);
    col = size(img, 2);
    img_new = [255 * ones(floor((20 - row) / 2), 30); 255 * ones(row, floor((30 - col) / 2)), img, 255 * ones(row, ceil((30 - col) / 2)); 255 * ones(ceil((20 - row) / 2), 30)];
    
    save_path = strcat("./captcha_splited_resized/", num2str(i), ".bmp");
    imwrite(img_new, save_path);
end    
