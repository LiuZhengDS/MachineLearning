% esl is expected square loss
function [rest_data, data_co, mid_out, idx_list] = lrc_predict_coco(beta, unlabel_data, label_data, data_co, flag, idx_list)
% w_i * x_i + w_0
plus = [];
minus = [];
target = beta' .* unlabel_data(:, 1: end - 1);
mid = [];
mid_out = [];
% idx_list = [];
fresh_data = label_data;
rest_data = unlabel_data;
difference = zeros(size(target, 1), 1);
for i = 1: size(label_data, 1)
    if label_data(i, end-1) == 1
        plus = [plus; label_data(i, 1: end)];
    else
        minus = [minus; label_data(i, 1: end)];
    end
end

if size(unlabel_data, 1) < 5
    % unlabel data size judge
    for h = 1: size(unlabel_data, 1)
        if sum(target(1, :)) > 0
            
            if flag == 1
                mid = [data_co(1, 1), data_co(1, 3), 1, data_co(1, end)];
                %             mid = [unlabel_data(h, 1: end - 1), 1, unlabel_data(h, end)];
            else
                mid = [data_co(1, 1), data_co(1, 2), 1, data_co(1, end)];
            end
            
        else
            if flag == 1
                mid = [data_co(1, 1), data_co(1, 3), -1, data_co(1, end)];
                
                %             mid = [unlabel_data(h, 1: end - 1), 1, unlabel_data(h, end)];
            else
                mid = [data_co(1, 1), data_co(1, 2), -1, data_co(1, end)];
            end
            
            %             mid = [unlabel_data(h, :), 1];
            %             fresh_data = [label_data; mid];
            %             rest_data(1, :) = [];
            %         else
            %             % give label
            %             mid = [unlabel_data(h, :), -1];
            %             fresh_data = [label_data; mid];
            %             rest_data(1, :) = [];
        end
        mid_out = [mid_out; mid];
        idx_list = [idx_list; mid];
        rest_data(1, :) = [];
        data_co(1, :) = [];
    end
    
else
    
    % calculate the mean of labeled set
    plus_mean = mean(plus(:, 1:end-2));
    minus_mean = mean(minus(:, 1:end-2));
    % calculate distance of target to each mean value
    for j = 1: size(unlabel_data, 1)
        if sum(target(j, 1: end-1)) > 0
            difference(j) = sqrt(sum((beta' .* plus_mean - target(j, 1: end)).^2));
            
        else
            difference(j) = sqrt(sum((beta' .* minus_mean - target(j, 1: end)).^2));
            
        end
    end
    
    % pick out best 5 and assign labels
    for k = 1: 5
        idx = find(difference == min(difference));
        s=sum(target(idx, :));
        if sum(target(idx, :)) > 0
            if flag == 1
                mid = [data_co(idx, 1), data_co(idx, 3), 1, data_co(idx, end)];
            else
                mid = [data_co(idx, 1), data_co(idx, 2), 1, data_co(idx, end)];
            end
        else
            if flag == 1
                mid = [data_co(idx, 1), data_co(idx, 3), -1, data_co(idx, end)];
            else
                mid = [data_co(idx, 1), data_co(idx, 2), -1, data_co(idx, end)];
            end
            
        end
        %     fresh_data = [fresh_data; mid];
        idx_list = [idx_list; mid];
        mid_out = [mid_out; mid];
        rest_data(idx, :) = [];
        difference(idx, :) = [];
        target(idx, :) = [];
        data_co(idx, :) = [];
        
        
    end
    
end
