function [feature, theta, sign] = WeightedWeakLearn(data, label, weight)
% Implement a weak learner WeakLearn,
% extend the implementation that it accepts a weight per object
% the decision stump, that is minimising the apparent error.
% To find the optimal feature f and threshold θ.
% input: dataset, label nad weight
% output: the optimised feature index and theta value
% %%%%%%
% initialise some parameter
error_min = 10000;
[n, dim] = size(data);
theta = 0;
% n is the number of objects/samples, dim is the number of features/dimensions
% th = min(data(:)) : 0.02 * (max(data(:)) - min(data(:))) : max(data(:));
% step_y = size(th, 2);
% for i = 1: step_y
for j = 1: dim
    % traverse the value of objects on each dimension
    for k = 1: n
        % use each value itself as theta
        t = ones(n, 1) * data(k, j);
        % if the value is graeter or lower than threshold
        pred_lr = data(:, j) - t <= 0;
        pred_gr = data(:, j) - t >= 0;
        pred_lr = pred_lr + 1;
        pred_gr = pred_gr + 1;
        % calculate error in two situation (greater or lower)
        error_current_lr = weight' * abs(pred_lr - label);
        error_current_gr = weight' * abs(pred_gr - label);
        % to check the relationship with label '1'/'2' and threshold,
        % the smaller error should be the real error
        if error_current_lr >= error_current_gr
            error_current = error_current_gr;
            sign = 1;
        else
            error_current = error_current_lr;
            sign = 0;
        end
        % if current feature i can reach a lower error (rate)
        if error_current < error_min
            % assign the current error to 'error_min' for further comparision
            error_min = error_current;
            % assign current feature index to 'feature'
            feature = j;
            theta = data(k, j);
        end
    end
    %     end
end
end





% if nargin < 3
%     lab = getlab(data);
%     data = getdata(data);
% end
%%%%%%% for testing
