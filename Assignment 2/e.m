function [error pred] = e(feature, theta, sign, data, label, weight)
n = size(data, 1);
Theta = ones(n, 1) * theta;
if sign == 0
    pred = data(:, feature) - Theta <= 0;
    pred = pred + 1;
    error_current = weight' * abs(pred - label); 
else
    pred = data(:, feature) - Theta >= 0;
    pred = pred + 1;
    error_current = weight' * abs(pred - label);   
end
error = error_current;
end

% pred_lr = data(:, feature) - Theta <= 0;
% pred_gr = data(:, feature) - Theta >= 0;
% pred_lr = pred_lr + 1;
% pred_gr = pred_gr + 1;

% error_current_lr = sum(abs(pred_lr - label));
% error_current_gr = sum(abs(pred_gr - label));
% error_current_lr = weight' * abs(pred_lr - label);
% error_current_gr = weight' * abs(pred_gr - label);

% if error_current_lr >= error_current_gr
%     error_current = error_current_gr;
% else
%     error_current = error_current_lr;
% end
% error = error_current / n;

%calculateError calculate the error based on feature,theta and y
% if nargin==4
%     lab_test = getlab(data);
%     X_test = getdata(X_test);
%     weight = ones(size(X_test,1),1)/size(X_test,1);
% end
% 
% if nargin==5
%     lab_test = getlab(X_test);
%     X_test = getdata(X_test);
% end

% weight = weight/sum(weight);