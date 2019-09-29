function [beta, para, w_matrix] = AdaBoost(data, label, T)
% input: dataset, label and number of iteration
% output: predicted label, beta and parameters for all base classifiers
[n, dim] = size(data);
% initialise weights
w = ones(n, 1) / n;
% to store T times iteration results
w_matrix = ones(n, T);
beta = zeros(T, 1);
para = zeros(T, 3);
% T times iteration (assignment requires 100 times)
for i = 1: T
    % p is current normalised weight
    p = w ./ sum(w);
    % store it in the matrix
    w_matrix(:, i) = p;
    % call WeightedWeakLearner() to access 
    [feature, theta, sign] = WeightedWeakLearn(data, label, p);
    para(i, 1) = feature;
    para(i, 2) = theta;
    para(i, 3) = sign;
    [error, pred] = e(feature, theta, sign, data, label, p);
    % if error is already error, then break
    if error == 0
        break;
    end
    % set beta value
    beta(i) = error / (1 - error);
    % set the new weights vector
    w = w .* (beta(i) .^ (1 - abs(pred - label)));
end
end
