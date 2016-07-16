% main file
% 2 layer neural network
% using backforward algorithm
% using splited captcha in ../tag_captcha/captcha_tagged/


% load training set and test set
tt = importdata("../tag_captcha/tag_results_new.txt");
y = tt(1 : 4000, 2);
y_test = tt(4001: end, 2);

idx_set = tt(1 : 4000, 1);
for i = 1 : size(idx_set, 1);
    filePath = strcat("../split_captcha/captcha_splited_resized/", num2str(idx_set(i, 1)), ".bmp");
    img = imread(filePath);
    
    img = double(img(:)') / 255.0;
    
    if i == 1
        X = img;
    end
    
    if i ~= 1
        X = [X; img];
    end
    
end

idx_set_test = tt(4001: end, 1);
for i = 1 : size(idx_set_test, 1);
    filePath = strcat("../split_captcha/captcha_splited_resized/", num2str(idx_set_test(i, 1)), ".bmp");
    img = imread(filePath);
    
    img = double(img(:)') / 255.0;
    
    if i == 1
        X_test = img;
    end
    
    if i ~= 1
        X_test = [X_test; img];
    end
    
end


% size of nn
input_layer_size  = 600;  % size of each image
hidden_layer_size = 50;  % it can also be other value
num_labels = 26;  % there are 26 letters, a--0, b--1, c--2, ..., z--25


% randomly initialize parameters
initial_Theta1 = randInitializeWeights(input_layer_size, hidden_layer_size);
initial_Theta2 = randInitializeWeights(hidden_layer_size, num_labels);
initial_nn_params = [initial_Theta1(:) ; initial_Theta2(:)];


% using fimnunc to train nn, iteration number can be set large
options = optimset('MaxIter', 50);


% train them, lambda can also be other number to get optimal result
lambda = 1;

costFunction = @(p) nnCostFunction(p, input_layer_size, ...
                                    hidden_layer_size, num_labels, X, y, lambda);
                                    
[nn_params, cost] = fmincg(costFunction, initial_nn_params, options);


% reshape and get theta of each layer
Theta1 = reshape(nn_params(1:hidden_layer_size * (input_layer_size + 1)), ...
                 hidden_layer_size, (input_layer_size + 1));
                 
Theta2 = reshape(nn_params((1 + (hidden_layer_size * (input_layer_size + 1))):end), ...
                 num_labels, (hidden_layer_size + 1));


% get training result, using other test set to test it
pred = predict(Theta1, Theta2, X);
fprintf('Traing accuracy: %f\n', mean(double(pred == y)) * 100);









