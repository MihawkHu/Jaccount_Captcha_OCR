% sigmoid function

function f = sigmoid(z)
    
    f = 1.0 ./ (1.0 + exp(-z));
    
end
