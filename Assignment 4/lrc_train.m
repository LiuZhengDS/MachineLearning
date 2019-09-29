% input: samples and labels of current data
% output: the w vector, represented as beta here

function [beta] = lrc_train(label_data)
features = label_data(:,1:size(label_data, 2)-1);
labels = label_data(:,end);
beta = inv(features' * features) * features' * labels;
end
