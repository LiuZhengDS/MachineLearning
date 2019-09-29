function [output_label] = combineinstlabels(input_label)

% conclude input label
labels = unique(input_label);
num = length(labels);
best_label_num = 0;

for i = 1:num
    if best_label_num < sum(input_label==labels(i))
        output_label = labels(i);
        best_label_num = sum(input_label==labels(i));
    end
end

end





