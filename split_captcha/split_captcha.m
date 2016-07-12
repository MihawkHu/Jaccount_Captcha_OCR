% clean image again, turn to 255 or 0
% split image to single letter, based on the interval of two letters
% sometimes there may be something wrong, because of two linked letters

function [num, max_wid, max_len] = split_captcha(filePath, idx)
    img = imread(filePath);
    row = size(img, 1);
    col = size(img, 2);
    
    % clead image, ture to every pix to 0 or 255
    for i = 1 : row
        for j = 1 : col
            if img(i, j) >= 150
                img(i, j) = 255;
            end
            if img(i, j) < 150
                img(i, j) = 0;
            end              
        end
    end

    % get pix(value = 0) number of each column 
    info = zeros(1, col);
    for j = 1 : col
        for i = 1 : row
            if img(i, j) == 0
                info(1, j) = info(1, j) + 1;
            end
        end
    end
    
    % get split line of each letter
    split_line = zeros(1, 10);
    cnt = 1;
    for j = 1 : col
        if info(1, j) ~= 0
            if j == 1 || j == col
                split_line(1, cnt) = j;
                cnt = cnt + 1;
            elseif ((info(1, j + 1) == 0 && info(1, j - 1) ~= 0) || 
                (info(1, j + 1) ~= 0 && info(1, j - 1) == 0))
                split_line(1, cnt) = j;
                cnt = cnt + 1;
            end
        end
    end
    num = (cnt - 1) / 2;
    
    % get and save splited image
    max_wid = 0;
    max_len = 0;
    for k = 1 : num
        splited_img = img(:, split_line(1, 2 * k - 1) : split_line(1, 2 * k));
        
        % remove top and bottom
        top = 1;
        bottom = row;
        flag = 0;
        for i = top : row
            for j = 1 : size(splited_img, 2)
                if splited_img(i, j) == 0
                    top = i;
                    flag = 1;
                end
                if flag == 1
                    break;
                end
            end
            if flag == 1
                break;
            end
        end
        flag = 0;
        i = row;
        while i > 1
            for j = 1 : size(splited_img, 2)
                if splited_img(i, j) == 0
                    bottom =  i;
                    flag = 1;
                end
                if flag == 1
                    break;
                end
            end
            if flag == 1
                break;
            end
            i = i - 1;
        end
        
        splited_img = splited_img(top : bottom, :);
        
        wid = bottom - top + 1;
        if wid > max_wid
            max_wid = wid;
        end
        len = split_line(1, 2 * k) - split_line(1, 2 * k - 1) + 1;
        if len > max_len
            max_len = len;
        end
        
        % save
        save_path = strcat("./captcha_splited/", num2str(idx + k - 1), ".bmp");
        imwrite(splited_img, save_path);
    end
    
end