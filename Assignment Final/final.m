clc;clear;

%%
train_origin = importdata('train.csv');
test_origin = importdata('test.csv');
labels = importdata('labels.csv');
true_l = importdata('truelabels.csv');
%% data normalisation (features 1-6)
train_origin = [normalize(train_origin(:,1:6)) train_origin(:,7:end)];
test_origin = [normalize(test_origin(:,1:6)) test_origin(:,7:end)];

%% generate one hot coding

col = size(train_origin, 1);
ohc_7 = zeros(col, numel(unique(train_origin(:,7))));
ohc_8 = zeros(col, numel(unique(train_origin(:,8))));
ohc_9 = zeros(col, numel(unique(train_origin(:,9))));
ohc_10 = zeros(col, numel(unique(train_origin(:,10))));
ohc_11 = zeros(col, numel(unique(train_origin(:,11))));
ohc_12 = zeros(col, numel(unique(train_origin(:,12))));
ohc_13 = zeros(col, numel(unique(train_origin(:,13))));

%%
for i = 1:size(ohc_7, 1)

        ohc_7(i,train_origin(i,7))=1;

end

for i = 1:size(ohc_8, 1)

        ohc_8(i,train_origin(i,8))=1;

end

for i = 1:size(ohc_9, 1)

        ohc_9(i,train_origin(i,9))=1;

end

for i = 1:size(ohc_10, 1)

        ohc_10(i,train_origin(i,10))=1;

end

for i = 1:size(ohc_11, 1)

        ohc_11(i,train_origin(i,11))=1;

end

for i = 1:size(ohc_12, 1)

        ohc_12(i,train_origin(i,12))=1;

end

% for i = 1:size(ohc_13, 1)
% 
%         ohc_13(i,train_origin(i,13))=1;
% 
% end


train_origin = [train_origin(:, 1:6) ohc_7 ohc_8 ohc_9 ohc_10 ohc_11 ohc_12 train_origin(:,end-2:end)];

%%
accuracy_knn = 0;
accuracy_rf = 0;
accuracy_nb = 0;
accuracy_ens = 0;
accuracy_lda = 0;
accuracy_lr = 0;
accuracy_svm = 0;

p2_11_sum = 0;
p2_12_sum = 0;
p1_21_sum = 0;
p1_22_sum = 0;

p2_11_mat = [];
p2_12_mat = [];
p1_21_mat = [];
p1_22_mat = [];

count = 0;

methods = [];

loss_modify = 5;
loss_current = 0;
loss_matrix = [];
accuracy_matrix = [];
%%
for j = 1:1000
%     j
    
    % randomly assign training and validation set 0.8/0.2
    rd = randperm(size(train_origin,1));
    train = train_origin(rd(1:size(rd,2)*0.8),1:end);
    validation = train_origin(rd(size(rd,2)*0.8+1:end),1:end);
    
    %
    % num_ones_in_train = sum(train_origin(:, 15) - 1);
    % num_zeros_in_train = size(train_origin, 1) - num_ones_in_train;
    
    % transfer 14th feature to none
    
    train_in = train;
    validation_in = validation;
    train_in(:, end-1) = [];
    validation_in(:, end-1) = [];
    
    % % prtools
    %
    train_data = train_in(:, 1:end-1);
    train_label = train_in(:, end);
    validation_data = validation_in(:, 1:end-1);
    validation_label = validation_in(:, end);
    % train_pr = prdataset(train_data, train_label);
    % validation_pr = prdataset(validation_data, validation_label);
    
    
    %% KNN
    
%         knn = ClassificationKNN.fit(train_data, train_label, 'NumNeighbors', 1);
%         predict_label = predict(knn, validation_data);
%     
%         accuracy = length(find(predict_label == validation_label))/length(validation_label);
%         accuracy_knn = accuracy + accuracy_knn;
    
        %% Random Forest
% %     
%         nTree = 5;
%         b = TreeBagger(nTree, train_data, train_label);
%         predict_label_cell = predict(b, validation_data);
%     
%         predict_label = zeros(4000, 1);
%     
%         for i = 1: size(validation, 1)
%             predict_label(i) = predict_label_cell{i,1} - 48;
%         end
%     
%         accuracy = length(find(predict_label == validation_label))/length(validation_label);
%         accuracy_rf = accuracy_rf + accuracy;
    %
    %     %% Naive Bayes
    
%         nb = ClassificationNaiveBayes.fit(train_data, train_label);
%         predict_label = predict(nb, validation_data);
%     
%         accuracy = length(find(predict_label == validation_label))/length(validation_label);
%         accuracy_nb = accuracy_nb + accuracy;
    
%     %% Ensembles for Boosting, Bagging, or Random Subspace
    ens = fitensemble(train_data,train_label,'AdaBoostM1' ,100,'tree','type','classification');
    predict_label = predict(ens, validation_data);
    
    accuracy = length(find(predict_label == validation_label))/length(validation_label);
%     accuracy_ens = accuracy_ens + accuracy;
    %
%         %% Discriminant Analysis Classifier
%     
%         obj = ClassificationDiscriminant.fit(train_data, train_label, 'discrimType','pseudoLinear');
%         predict_label = predict(obj, validation_data);
%     
%         accuracy = length(find(predict_label == validation_label))/length(validation_label);
%         accuracy_lda = accuracy_lda + accuracy;

     
% [predict_label, err]=classify(validation_data, train_data, train_label, 'quadratic');


    
    num_11 = intersect(find(validation_label(:,1)==1), find(validation_data(:,end)==1));
    num_12 = intersect(find(validation_label(:,1)==1), find(validation_data(:,end)==2));
    num_21 = intersect(find(validation_label(:,1)==2), find(validation_data(:,end)==1));
    num_22 = intersect(find(validation_label(:,1)==2), find(validation_data(:,end)==2));
    
    p2_11_current = numel(intersect(find(predict_label==2), num_11)) / numel(num_11);
    p2_12_current = numel(intersect(find(predict_label==2), num_12)) / numel(num_12);
    p1_21_current = numel(intersect(find(predict_label==1), num_21)) / numel(num_21);
    p1_22_current = numel(intersect(find(predict_label==1), num_22)) / numel(num_22);
    
    loss_current = 3 * max(p2_11_current, p2_12_current) + max(p1_21_current, p1_22_current);
    
    loss_matrix = [loss_matrix; loss_current];
    accuracy_matrix = [accuracy_matrix; accuracy];
    
    if loss_current < loss_modify
       
        loss_modify = loss_current;
%         methods = lr;
        p2_11 = p2_11_current;
        p2_12 = p2_12_current;
        p1_21 = p1_21_current;
        p1_22 = p1_22_current;
        count = count + 1
        loss_modify
        accuracy_ens = accuracy_ens + accuracy;
        train_memo = train;
        validation_memo = validation;
        
    end
    
%     if (abs(p2_11_current - p2_12_current) < 0.1 && abs(p1_21_current - p1_22_current) < 0.1)
%         
%         p2_11_sum = p2_11_sum + p2_11_current;
%         p2_12_sum = p2_12_sum + p2_12_current;        
%         p1_21_sum = p1_21_sum + p1_21_current;
%         p1_22_sum = p1_22_sum + p1_22_current;
%         
%         methods = ens;
%         
%         p2_11_mat = [p2_11_mat; p2_11_current];
%         p2_12_mat = [p2_12_mat; p2_12_current];
%         p1_21_mat = [p1_21_mat; p1_21_current];
%         p1_22_mat = [p1_22_mat; p1_22_current];
%         
%         count = count + 1
%         
%     end


end

%% calculate average error rate
accuracy_knn = accuracy_knn/20;
accuracy_rf = accuracy_rf/20;
accuracy_nb = accuracy_nb/20;
accuracy_ens = accuracy_ens/count;
accuracy_lda = accuracy_lda/20;
accuracy_lr = accuracy_lr/20;
accuracy_svm = accuracy_svm/20;

%% calculate conditional probability

% num_11 = intersect(find(validation_label(:,1)==1), find(validation_data(:,13)==1));
% num_12 = intersect(find(validation_label(:,1)==1), find(validation_data(:,13)==2));
% num_21 = intersect(find(validation_label(:,1)==2), find(validation_data(:,13)==1));
% num_22 = intersect(find(validation_label(:,1)==2), find(validation_data(:,13)==2));
% 
% p2_11 = numel(intersect(find(predict_label==2), num_11)) / numel(num_11);
% p2_12 = numel(intersect(find(predict_label==2), num_12)) / numel(num_12);
% p1_21 = numel(intersect(find(predict_label==1), num_21)) / numel(num_21);
% p1_22 = numel(intersect(find(predict_label==1), num_22)) / numel(num_22);
% 
% p2_11 = p2_11_sum / count;
% p2_12 = p2_12_sum / count;
% p1_21 = p1_21_sum / count;
% p1_22 = p1_22_sum / count;
% 
% loss = 3 * max(p2_11, p2_12) + max(p1_21, p1_22);
% 
% p2_compare = [p2_11_mat p2_12_mat];
% 
% p1_compare = [p1_21_mat p1_22_mat];

loss = loss_modify;

%%











