% initialisation
load twoGaussians.txt;
data_ori = twoGaussians;
g = gauss([1000 1000],[0,0;0,8],cat(3,eye(2),eye(2)));
g_data = getdata(g);
g_label = [ones(1000,1); -ones(1000,1)];
data_ori = [g_data g_label];
feature = data_ori(:,1:2);
label = data_ori(:,3);
[row,column] = size(feature);
beta = zeros(1, 3);
% % normalisation
% for i = 1: column
%     feature(:,i) = (feature(:, i) - min(feature(:,i)))/(max(feature(:,i))-min(feature(:,i)));
% end
% for beta_0
ones_column = ones(row, 1);
samples = [ones_column feature];

% separate data
plus = samples(1:1000,:);
minus = samples(1001:end,:);

repeats = 50;

unlabel = [0, 1, 2, 4, 8, 16, 32, 64, 128, 256, 512];
e_history_supervise_1 = zeros(size(unlabel, 2), repeats);
esl_history_supervise_1 = zeros(size(unlabel, 2), repeats);

% esl is expected square loss

% self-training
% unlabel = [10000];
e_history_self = zeros(size(unlabel, 2), repeats);
esl_history_self = zeros(size(unlabel, 2), repeats);

% supervised learning results
for ii = 1: repeats
    
    data = data_ori;
    plus_op = plus;
    minus_op = minus;
    label_index_plus = randperm(1000, 8);
    label_index_minus = randperm(1000, 8);
    label_plus = plus_op(label_index_plus,:);
    label_minus = minus_op(label_index_minus,:);
    plus_op(label_index_plus, :) = [];
    minus_op(label_index_minus, :) = [];
    label_data = [label_plus; label_minus];
    ini_label = [ones(8,1);ones(8,1).*-1];
    label_data = [label_data ini_label];
    test_plus = [plus_op ones(992,1)];
    test_minus = [minus_op -ones(992,1)];
    test = [test_plus; test_minus];
    
    for jj = 1: size(unlabel,2)
        
        test_data = test(randperm(1984, 500), :);
        [beta] = lrc_train(label_data);
        [e, esl] = lrc_test(test_data, beta);
        e_history_supervise_1(ii,jj) = e;
        esl_history_supervise_1(ii,jj) = esl;
    end
end

for i = 1: repeats
    % pick labeled data 8 per class, every iteration refresh
    data = data_ori;
    plus_op = plus;
    minus_op = minus;
    label_index_plus = randperm(1000, 8);
    label_index_minus = randperm(1000, 8);
    label_plus = plus_op(label_index_plus,:);
    label_minus = minus_op(label_index_minus,:);
    plus_op(label_index_plus, :) = [];
    minus_op(label_index_minus, :) = [];
    data(label_index_plus, :) = [];
    data(label_index_minus, :) = [];
    %     data_plus = [plus_op ones(4992,1)];
    %     data_minus = [minus_op -ones(4992,1)];
    label_data = [label_plus; label_minus];
    ini_label = [ones(8,1);ones(8,1).*-1];
    label_data = [label_data ini_label];
    
    for j = 1: size(unlabel, 2)
        data_test = [ones(1984, 1) data];
        label_input = label_data;
        unlabel_data = [plus_op; minus_op];
        unlabel_input = unlabel_data(randperm(1984, unlabel(j)), :);
        data_test(randperm(1984, unlabel(j)), :) = [];
        test_data = data_test(randperm(size(data_test, 1), 500), :);
        if j == 1
            [beta] = lrc_train(label_input);
            % pick random training set
            %         data_index_plus = randperm(4992, unlabel(j));
            %         data_index_minus = randperm(4992, unlabel(j));
            %         unlabel_data_plus = plus_op(data_index_plus, :);
            %         unlabel_data_minus = plus_op(data_index_minus, :);
            %         unlabel_data = [unlabel_data_plus; unlabel_data_minus];
            %             [e_su, esl_su] = lrc_test(test_data, beta);
            %             e_history_supervise(i,j) = e_su;
            %             esl_history_supervise(i,j) = esl_su;
        else
            while ~isempty(unlabel_input)
                [beta] = lrc_train(label_input);
                %                 unlabel_index = randperm(size(unlabel_data, 1), 1);
                %                 unlabel_data = randperm(9984, unlabel(j));
                %                 unlabel_input = unlabel_data(:, randperm(9984, unlabel(j)));
                [label_input, unlabel_input] = lrc_predict(beta, unlabel_input, label_input);
            end
            
        end
        [e_self, esl_self] = lrc_test(test_data, beta);
        e_history_self(i,j) = e_self;
        esl_history_self(i,j) = esl_self;
    end
end

%

e_history_self = e_history_self(:, 1:size(unlabel, 2));
esl_history_self = esl_history_self(:, 1:size(unlabel, 2));
e_history_supervise_1 = e_history_supervise_1(:, 1:size(unlabel, 2));
esl_history_supervise_1 = esl_history_supervise_1(:, 1:size(unlabel, 2));





% co-training

% initialisation
load twoGaussians.txt;
% data_cot = twoGaussians;
data_ori = [g_data g_label];
feature_co = data_ori(:,1:2);
feature_1 = feature_co(:, 1);
feature_2 = feature_co(:, 2);
label_co = data_ori(:,3);
[row_1, column_1] = size(feature_1);
[row_2, column_2] = size(feature_2);
% beta_co_1 = zeros(1, size(feature_1, 2));
% beta_co_2 = zeros(1, size(feature_2, 2));
data_aaa = data;
ones_column = ones(row_1, 1);
data_1 = [ones_column feature_1 label_co];
data_2 = [ones_column feature_2 label_co];

% repeats = 200;

unlabel = [0, 1, 2, 4, 8, 16, 32, 64, 128, 256, 512];
e_history_co = zeros(size(unlabel, 2), repeats);
esl_history_co = zeros(size(unlabel, 2), repeats);

% separate data
plus_1 = data_1(1: 1000, :);
minus_1 = data_1(1001: end, :);
plus_2 = data_2(1:1000, :);
minus_2 = data_2(1001: end, :);
final_train = [];
final_train_component = [];

for i = 1: repeats
    plus_1_op = plus_1;
    minus_1_op = minus_1;
    plus_2_op = plus_2;
    minus_2_op = minus_2;
    label_index_plus_1 = randperm(1000, 8);
    label_index_minus_1 = randperm(1000, 8);
    label_index_plus_2 = randperm(1000, 8);
    label_index_minus_2 = randperm(1000, 8);
    
    label_plus_1 = plus_1_op(label_index_plus_1, :);
    label_minus_1 = minus_1_op(label_index_minus_1, :);
    label_plus_2 = plus_2_op(label_index_plus_2, :);
    label_minus_2 = minus_2_op(label_index_minus_2, :);
    
    plus_1_op(label_index_plus_1, :) = [];
    minus_1_op(label_index_minus_1, :) = [];
    plus_2_op(label_index_plus_2, :) = [];
    minus_2_op(label_index_minus_2, :) = [];
    
    label_data_1 = [label_plus_1; label_minus_1];
    label_data_2 = [label_plus_2; label_minus_2];
    
    for j = 1: size(unlabel, 2)
        label_input_1 = [label_data_1, zeros(16,1)];
        label_input_2 = [label_data_2, zeros(16,1)];
        
        unlabel_data_1 = [plus_1_op; minus_1_op];
        unlabel_data_2 = [plus_2_op; minus_2_op];
        
        if j > 1
            hand_index = linspace(1,unlabel(j), unlabel(j))';
            
            %
            rand_perm = randperm(1984, unlabel(j));
            unlabel_input_1 = [unlabel_data_1(rand_perm, 1: end-1), hand_index];
            unlabel_input_2 = [unlabel_data_2(rand_perm, 1: end-1), hand_index];
            
            data_co_1 = [ones(unlabel(j), 1), data_aaa(rand_perm, :), hand_index];
            data_co_2 = [ones(unlabel(j), 1), data_aaa(rand_perm, :), hand_index];
            idx_list1 = [];
            idx_list2 = [];
        end
        
        if j == 1
            % converge common data set
            d_1 = label_input_1(:, 1: size(label_input_1, 2)-1);
            d_2 = label_input_2(:, 2: size(label_input_2, 2));
            d = [d_1(:, 1:end-1), d_2];
            zz=1
            [beta_co] = lrc_train_co(d);
        else
            
            while ~isempty(unlabel_input_1) || ~isempty(unlabel_input_2)
                z=1
                [beta_1] = lrc_train_co(label_input_1);
                [beta_2] = lrc_train_co(label_input_2);
                
                [unlabel_input_1, data_co_1, mid_1, idx_list1] = lrc_predict_coco(beta_1, unlabel_input_1, label_input_1, data_co_1, 1, idx_list1);
                [unlabel_input_2, data_co_2, mid_2, idx_list2] = lrc_predict_coco(beta_2, unlabel_input_2, label_input_2, data_co_2, 2, idx_list2);
                
                label_input_1 = [label_input_1; mid_2];
                label_input_2 = [label_input_2; mid_1];
            end

         end   
            final_train = [label_data];
            final_train_component = []; 
        
        
        for k = 1: unlabel(j)
            if idx_list1(find(idx_list1(:,end) == k)) == idx_list2(find(idx_list2(:,end) == k))
                final_train_component = [1, idx_list2(find(idx_list2(:,end) == k), 2: end-2), idx_list1(find(idx_list1(:,end) == k), 2: end-2), idx_list2(find(idx_list1(:,end) == k), end-1)];
            end
            final_train = [final_train; final_train_component];
        end
        
        [beta_co] = lrc_train(final_train);
        
        test_data_co = test(randperm(1984, 500), :);
        [e_co, esl_co] = lrc_test(test_data_co, beta_co);
        e_history_co(i,j) = e_co;
        esl_history_co(i,j) = esl_co; 
    end
end

for ii = 1: repeats
    
    data = data_ori;
    plus_op = plus;
    minus_op = minus;
    label_index_plus = randperm(1000, 8);
    label_index_minus = randperm(1000, 8);
    label_plus = plus_op(label_index_plus,:);
    label_minus = minus_op(label_index_minus,:);
    plus_op(label_index_plus, :) = [];
    minus_op(label_index_minus, :) = [];
    label_data = [label_plus; label_minus];
    ini_label = [ones(8,1);ones(8,1).*-1];
    label_data = [label_data ini_label];
    test_plus = [plus_op ones(992,1)];
    test_minus = [minus_op -ones(992,1)];
    test = [test_plus; test_minus];
    
    for jj = 1: size(unlabel,2)
        % add label data to do supervised learning
        plus_in = [plus_op(randperm(992, unlabel(jj)), :), ones(unlabel(jj),1)];
        minus_in = [minus_op(randperm(992, unlabel(jj)), :), -ones(unlabel(jj),1)];
        label_data = [label_data;plus_in;minus_in];
        
        test_data = test(randperm(1984, 500), :);
        [beta] = lrc_train(label_data);
        [e, esl] = lrc_test(test_data, beta);
        e_history_supervise_2(ii,jj) = e;
        esl_history_supervise_2(ii,jj) = esl;
    end
end

%%
e_history_self = e_history_self(:, 1:size(unlabel, 2));
esl_history_self = esl_history_self(:, 1:size(unlabel, 2));
e_history_supervise_1 = e_history_supervise_1(:, 1:size(unlabel, 2));
esl_history_supervise_1 = esl_history_supervise_1(:, 1:size(unlabel, 2));
e_history_supervise_2 = e_history_supervise_2(:, 1:size(unlabel, 2));
esl_history_supervise_2 = esl_history_supervise_2(:, 1:size(unlabel, 2));
e_history_co = e_history_co(:, 1:size(unlabel, 2));
esl_history_co = esl_history_co(:, 1:size(unlabel, 2));
%%
% plot(log(unlabel), mean(e_history_self, 1));
% hold on
% plot(log(unlabel), mean(e_history_supervise, 1));
% hold on
% loglog(log(unlabel), mean(e_history_co, 1));

loglog(unlabel,  mean(e_history_self, 1), 'b--o',unlabel, mean(e_history_supervise_1, 1), 'r--o',unlabel, mean(e_history_co, 1), 'g--o');

legend('Self-training','Supervised Sethod','Co-training');
xlabel("(log) Number of unlabeled training data");
ylabel("Error Rate");
title("True Error Curve");
%%
% plot(log(unlabel), mean(esl_history_self, 1));
% hold on
% plot(log(unlabel), mean(esl_history_supervise, 1));
% hold on
loglog(unlabel, mean(esl_history_self, 1), 'b--o',unlabel, mean(esl_history_supervise_2, 1), 'r--o',unlabel, mean(esl_history_co, 1), 'g--o');
legend('Self-training','Supervised Method','Co-training');
xlabel("(log) Number of unlabeled training data");
ylabel("Expected Squared Loss");
title("Loss Function Curve");











% for j = 1: size(unlabel, 2)
%         label_input_1 = [label_data_1 zeros(16, 1)];
%         label_input_2 = [label_data_2 zeros(16, 1)];
%         
%         unlabel_data_1 = [plus_1_op; minus_1_op];
%         unlabel_data_2 = [plus_2_op; minus_2_op];
%         
%         if j > 1
%             hand_index = linspace(1, unlabel(j), unlabel(j))';
%         end
%         
%         rand_perm = randperm(9984, unlabel(j));
%         unlabel_input_1 = unlabel_data_1(rand_perm, :);
%         unlabel_input_2 = unlabel_data_2(rand_perm, :);
%         
%         unlabel_input_1 = [unlabel_data_1(rand_perm, :) hand_index];
%         unlabel_input_2 = [unlabel_data_2(rand_perm, :) hand_index];
%         
%         judge_1 = unlabel_input_1;
%         judge_2 = unlabel_input_2;
%         
%         if j == 1
%             % converge common data set
%             d_1 = label_input_1(:, 1: size(label_input_1, 2)-1);
%             d_2 = label_input_2(:, 2: size(label_input_2, 2));
%             d = [d_1 d_2];
%             [beta] = lrc_train(d);
%         else
%             while ~isempty(unlabel_input_1) || ~isempty(unlabel_input_2)
%                 [beta_1] = lrc_train(label_input_1);
%                 [beta_2] = lrc_train(label_input_2);
%                 %                 unlabel_index = randperm(size(unlabel_data, 1), 1);
%                 %                 unlabel_data = randperm(9984, unlabel(j));
%                 %                 unlabel_input = unlabel_data(:, randperm(9984, unlabel(j)));
%                 [ind_1, unlabel_input_1] = lrc_predict(beta_1, unlabel_input_1, label_input_1);
%                 [ind_2, unlabel_input_2] = lrc_predict(beta_2, unlabel_input_2, label_input_2);
%                 
%                 
%                 refresh_1 = judge_1(judge_1(:, end)==ind_1);
%                 refresh_2 = judge_2(judge_2(:, end)==ind_2);
%                 
%                 refresh_cut_1 = refresh_1();
%                 refresh_cut_2 = refresh_2();
%                 
%                 label_input_1 = [label_input_1; refresh_cut_2];
%                 label_input_2 = [label_input_2; refresh_cut_1];
%                 
%             end
%             
%         end
%         
%     end
%     
% end

















 
