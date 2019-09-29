% esl is expected square loss
function [fresh_data, rest_data, idx_out] = lrc_predict(beta, unlabel_data, label_data)
% w_i * x_i + w_0
plus = [];
minus = [];
target = beta' .* unlabel_data;
mid = [];
idx_out = [];
fresh_data = label_data;
rest_data = unlabel_data;
difference = zeros(size(target, 1), 1);
for i = 1: size(label_data, 1)
    if label_data(i, end) == 1
        plus = [plus; label_data(i, 1: size(unlabel_data, 2))];
    else
        minus = [minus; label_data(i, 1: size(unlabel_data, 2))];
    end
end

if size(unlabel_data, 1) < 5
% unlabel data size judge
    for h = 1: size(unlabel_data, 1)
        if sum(target(1, :)) > 0
            % give label
            mid = [unlabel_data(h, :), 1];
            fresh_data = [label_data; mid];
            rest_data(1, :) = [];
        else
            % give label
            mid = [unlabel_data(h, :), -1];
            fresh_data = [label_data; mid];
            rest_data(1, :) = [];
        end
    end
    
else
    
% calculate the mean of labeled set
plus_mean = mean(plus);
minus_mean = mean(minus);
% calculate distance of target to each mean value
for j = 1: size(unlabel_data, 1)
    if sum(target(j, :)) > 0
        difference(j) = sqrt(sum((beta' .* plus_mean - target(j, :)).^2));
        
    else
        difference(j) = sqrt(sum((beta' .* minus_mean - target(j, :)).^2));
        %         mid = [target(j, :), -1];
        %         fresh_data = [label_data; mid];
        %         rest_data(j, :) = [];
    end
end

% pick out best 5 and assign labels
for k = 1: 5
    idx = find(difference == min(difference));
    s=sum(target(idx, :));
    if sum(target(idx, :)) > 0
        mid = [unlabel_data(idx, :), 1];
    else
        mid = [unlabel_data(idx, :), -1];
    end
    fresh_data = [fresh_data; mid];
    rest_data(idx, :) = [];
    difference(idx, :) = [];
    target(idx, :) = [];
    idx_out = [idx_out idx];
    
end

end
