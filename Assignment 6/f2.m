%% trustworthy
% split the dataset with bags ID, and then use instances of related bags ID
% to train and test the classifier
bag_id = [1:size(bags_data,1)]';
dataset_bag = prdataset(bag_id,bags_label);
error = cell(2,1000);

for j = 1:size(error,2)
    j
    [train_bag,test_bag,train_bag_id,test_bag_id] = gendat(dataset_bag,0.75);
    train_instance_id = [];
    test_instance_id = [];
    
    for i = 1:size(train_bag,1)
        temp = find(getident(B,'milbag')==train_bag_id(i));
        train_instance_id = [train_instance_id;temp];
    end
    
    train_instance = B(train_instance_id,:);
    fisher = fisherc(train_instance);
    predict = [];
    
    for i = 1:size(test_bag,1)
        temp = find(getident(B,'milbag')==test_bag_id(i));
        result = labeld(B.data(temp,:),fisher);
        out_label = combineinstlabels(result);
        predict = [predict; out_label];
    end
    
    test_label = test_bag.labels;
    residule = test_label - predict;
    
    %apple error
    error{1,j} = sum(residule == -1);
    %banana error
    error{2,j} = sum(residule == 1);
end
count_1 = 0;
count_2 = 0;
for i = 1:1000
    count_1 = error{1,i}+count_1;
    count_2 = error{2,i}+count_2;
end
c=count_1+count_2;
error_1 = (count_1/1000)/15;
error_2 = (count_2/1000)/15;
e=(error_1+error_2)/2;
l=2