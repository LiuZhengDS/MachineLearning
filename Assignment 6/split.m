function [train_set, test_set] = split(bag_in,percent)
bag1 = bag_in(1:60,:);
bag2 = bag_in(61:end,:);
% set training and testing set
rand_bag1 = randperm(60);
rand_bag2 = randperm(60);
bag1_train_idx = rand_bag1(1:60*percent);
bag2_train_idx = rand_bag2(1:60*percent);
bag1_test_idx = rand_bag1(60*percent+1:end);
bag2_test_idx = rand_bag2(60*percent+1:end);
bag1_train = [];
bag1_test = [];
bag2_train = [];
bag2_test = [];
% train
for r_train = 1: percent*60
    bag1_train = [bag1_train; bag1(bag1_train_idx(r_train),:)];
    bag2_train = [bag2_train; bag2(bag2_train_idx(r_train),:)];
end
% test
for r_test = 1: uint8((1-percent)*60)
    bag1_test = [bag1_test; bag1(bag1_test_idx(r_test),:)];
    bag2_test = [bag2_test; bag2(bag2_test_idx(r_test),:)];
end

train_set = [bag1_train; bag2_train];
test_set = [bag1_test; bag2_test];

end