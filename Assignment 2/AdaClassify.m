function [AdaLabel] = AdaClassify(data, beta, para)
% input: beta, para (including feature, theta and sign) and data
% output: classification result
% initialise number of object and number of iterations
n = size(data, 1);
T = size(beta, 1);
hypo = zeros(n, T); 
% apply the hypothesis to calculate the baseline to be compared
baseline = 0.5 * sum(log(1 ./ beta));
for i = 1: T
    % load feature, theta and sign
    feature = para(i, 1);
    theta = para(i, 2);
    sign = para(i, 3);
    Theta = ones(n, 1) * theta;
    % prevent error occuring
    if feature == 0
        break;
    end
    % to check the relationship with label '1'/'2' and threshold
    if sign == 1
        hypo(:, i) = data(:, feature) - Theta >= 0;
    else
        hypo(:, i) = data(:, feature) - Theta <= 0;
    end
    hypo(:, i) = hypo(:, i) * log(1 / beta(i));
end
% fulfill the hypothesis equation or otherwise, 0/1
AdaLabel = sum(hypo, 2) >= baseline;
% two class labels are 1 and 2 respectively, so need +1
AdaLabel = AdaLabel + 1;
end