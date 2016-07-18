% calculate cost

function [J grad] = nnCostFunction(nn_params, input_layer_size, hidden_layer_size, num_labels, X, y, lambda)
    
    m = size(X, 1);
    
    % reshape Theta11 and Theta2
    Theta1 = reshape(nn_params(1:hidden_layer_size * (input_layer_size + 1)), ...
                    hidden_layer_size, (input_layer_size + 1));
                    
    Theta2 = reshape(nn_params((1 + (hidden_layer_size * (input_layer_size + 1))):end), ...
                    num_labels, (hidden_layer_size + 1));
                    
                    
    % calculate the cost
    X = [ones(m, 1) X];
    
    tmp = sigmoid(X * Theta1');
    tmp = [ones(m, 1), tmp];
    tmp = sigmoid(tmp * Theta2');
    
    Y = zeros(m, num_labels);
    for i = 1 : m
        Y(i, y(i)) = 1;
    end
    
    J = 0;
    for i = 1 : m
        J = J + sum(-Y(i, :)' .* log(tmp(i, :)') - (1 - Y(i, :)') .* log(1 - tmp(i, :)')) / m;
    end
    
    % implement regularization
    The1_2 = Theta1 .^ 2;
    The2_2 = Theta2 .^ 2;
    
    sumOfTheta = 0;
    for i = 1 : hidden_layer_size
        for j = 2 : input_layer_size + 1
               sumOfTheta = sumOfTheta + The1_2(i, j);
        end
    end
    
    for i = 1 : num_labels
        for j = 2 : hidden_layer_size + 1
            sumOfTheta = sumOfTheta + The2_2(i, j);
        end
    end
    
    re = lambda / 2 / m * sumOfTheta; %regularization
    
    J = J + re;
    
    
    % implement backpropagation algorithm
    Delta_1 = zeros(hidden_layer_size, input_layer_size + 1);
    Delta_2 = zeros();
    
    for t = 1 : m
        a_1 = X(t, :)';
        z_2 = Theta1 * a_1;
        a_2 = sigmoid(z_2);
        a_2 = [1; a_2];
        
        z_3 = Theta2 * a_2;
        a_3 = sigmoid(z_3);
        
        delta_3 = a_3 - Y(t, :)';
        
        z_2 = [1; z_2];
        delta_2 = Theta2' * delta_3 .* sigmoidGradient(z_2);
        
        delta_2 = delta_2(2 : end);
        Delta_1 = Delta_1 + delta_2 * a_1';
        
        Delta_2 = Delta_2 + delta_3 * a_2';
    end

    Theta1_grad = Delta_1 / m;
    Theta2_grad = Delta_2 / m;
    
    
    t1 = Theta1 * lambda / m;
    t2 = Theta2 * lambda / m;
    
    for i = 1 : size(t1, 1)
        t1(i, 1) = 0;
    end
    
    for i = 1 : size(t2, 1)
        t2(i, 1) = 0;
    end
    
    Theta1_grad = Theta1_grad + t1;
    Theta2_grad = Theta2_grad + t2;
    
    
    % unroll gradients and return 
    grad = [Theta1_grad(:) ; Theta2_grad(:)];
    
    
end
