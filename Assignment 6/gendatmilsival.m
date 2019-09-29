function [bag_dataset, bags_data, bags_label] = gendatmilsival(class_1, class_2)

% assign 120 labels, 0 for apple, 1 for banana
label_1 = zeros(size(class_1,1),1);
label_2 = ones(size(class_2,1),1);
bags_label = [label_1; label_2];

% combine data cell
bags_data = [class_1; class_2];

% storing them in a Prtools dataset
bag_dataset = bags2dataset(bags_data,bags_label);

end