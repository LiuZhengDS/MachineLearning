% function [error_final] = new_method()

prwarning off;
[apple, banana]=fileread();

% feature result initialisation
AppleFeat = {};
BananaFeat = {};
% mean-shift result initialisaiton
MS_apple = {};
MS_banana = {};

width = 30;

for i = 1:size(apple,1)
    i
    [result_apple, im_apple] = extract_modification(apple{i,1}, width);
    [result_banana, im_banana] = extract_modification(banana{i,1}, width);
    % features
    AppleFeat{i,1} = result_apple;
    BananaFeat{i,1} = result_banana;
    % mean-shit label
    MS_apple{i,1} = im_apple;
    MS_banana{i,1} = im_banana;
end
% combine apple and banana for dissimilarity
in = [AppleFeat;BananaFeat];
% calculate (dis)similarity
[dissimilarities] = dissimilarity(in);
%% split dataset, taking 80% as training set and rest fo testing
percent = 0.5;
repeat = 1000;
error_rate_all = 0;
prwarning off;
for rep = 1:repeat
[train_in, test_in] = split(dissimilarities,percent);
% make prdataset
n_train = 60*percent;
n_test = uint8((1-percent)*60);
training_data = prdataset(train_in,[zeros(n_train,1);ones(n_train,1)]);
testing_data = prdataset(test_in,[zeros(n_test,1);ones(n_test,1)]);

% feature extraction and get extraction mapping %
Pca_Coeff = pcam(training_data, 0.90);
% extract training data %
training_data = training_data * Pca_Coeff;
% extract testing data
testing_data = testing_data * Pca_Coeff;

% train & test
[w, C] = liknonc(training_data,10);
label = labeld(testing_data, w);
error_a = 0;
error_b = 0;
for i = 1:n_test
    if label(i) == 1
        error_a = error_a + 1;
    end
    
    if label(i+n_test) == 0
        error_b = error_b + 1;
    end
end

error_rate = (error_a+error_b)/double(n_test*2);
error_rate_all = error_rate_all+error_rate;
end
error_final = error_rate_all/repeat;

% end

