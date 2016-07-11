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

%  TODO
% resize them to the same size
% max_len = 30
% max_wid = 19

