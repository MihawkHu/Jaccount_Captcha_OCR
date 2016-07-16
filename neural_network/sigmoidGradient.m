% sigmoid gradient function

function f = sigmoidGradient(z)
    
    f = sigmoid(z) .* (1 - sigmoid(z));
    
end
