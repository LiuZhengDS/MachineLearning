clear;clc;

[apple, banana, medal, box]=fileread();

% [ResultingFeatures] = extractinstances(apple{1,1},100);

AppleFeat = {};
BananaFeat = {};
MedalFeat = {};
BoxFeat = {};

MS_apple = {};
MS_banana = {};
MS_medal = {};
MS_box = {};

for i = 1:size(apple,1)
    i
    [result_apple, im_apple] = extractinstances(apple{i,1}, 30);
    [result_banana, im_banana] = extractinstances(banana{i,1}, 30);
%     [result_medal, im_medal] = extractinstances(medal{i,1}, 50);
%     [result_box, im_box] = extractinstances(box{i,1}, 50);
    AppleFeat{i,1} = result_apple;
    BananaFeat{i,1} = result_banana;
%     MedalFeat{i,1} = result_medal;
%     BoxFeat{i,1} = result_box;
    MS_apple{i,1} = im_apple;
    MS_banana{i,1} = im_banana;
%     MS_medal{i,1} = im_medal;
%     MS_box{i,1} = im_box;
end

%% test width parameter
figure;
for i = 2: 6
    i
   [R I] = extractinstances(banana{20,1}, i*10);
    subplot(1,5,i-1);
    str=['Width=',num2str(i*10)];
    imshow(I,[]);
    title(str);
end

figure;
for i = 2: 6
    i
   [R I] = extractinstances(apple{20,1}, i*10);
    subplot(1,5,i-1);
    str=['Width=',num2str(i*10)];
    imshow(I,[]);
    title(str);
end

figure;
for i = 2: 6
    i
   [R I] = extractinstances(banana{36,1}, i*10);
    subplot(1,5,i-1);
    str=['Width=',num2str(i*10)];
    imshow(I,[]);
    title(str);
end

figure;
for i = 2: 6
    i
   [R I] = extractinstances(apple{36,1}, i*10);
    subplot(1,5,i-1);
    str=['Width=',num2str(i*10)];
    imshow(I,[]);
    title(str);
end

%%
clc;clear;

load('data.mat');

[B, bags_data, bags_label] = gendatmilsival(AppleFeat, BananaFeat);

a = B.data(1:325,:);
b = B.data(326:end,:);

instance = B.data;

% figure;
% scatter3(a(:,1),a(:,2),a(:,3),'*');
% hold on;
% scatter3(b(:,1),b(:,2),b(:,3),'*');
% legend('apple','banana')

bagid = getident(B,'milbag');

% 
% for i = 1:120
%    bags_data{i,1}=bags_data{i,1};
% end

instance=instance*255;
sigma=50;
mB = bagembed(bags_data,instance,sigma);


%%
% 
% for i = 1:120
%    bags_data{i,1}=bags_data{i,1};
% end
% 
% instance=instance;
% sigma=25/16;
% mB = bagembed(bags_data,instance,sigma);
% %% L1-SVM
% prwarning off
% prwaitbar off
% 
% l = [zeros(60,1);ones(60,1)];
% mB_in = prdataset(mB,l);
% num=100;
% count_1 = 0;
% count_2 = 0;
error_test = [];
repeat = 50;
% per=0.75;
for s = 1:300
s
error_all = 0;
for r = 1:repeat
n1 = randperm(60);
n2 = randperm(60)+ 60*ones(1,60);
train_apple = {};
train_banana = {};
test_apple = {};
test_banana = {};

for i = 1:30
    train{i} = bags_data{n1(i)};
    train{i+30} = bags_data{n2(i)};
end

for i = 1:30
    test{i} = bags_data{n1(i+30)};
    test{i+30} = bags_data{n2(i+30)};
end

% test = [test_apple;test_banana];

instances = gendatmilsival(AppleFeat,BananaFeat);

% instances_train = gendatmilsival(train_apple,train_banana);
% instances_test = gendatmilsival(test_apple,test_banana);

% implement bagembed to get feature vectors
mB_train = bagembed(train,instances.data,s/100);
mB_test = bagembed(test,instances.data,s/100);

% make prdataset
mB_train_dataset = prdataset(mB_train, [zeros(30,1);ones(30,1)]);
mB_test_dataset = prdataset(mB_test, [zeros(30,1);ones(30,1)]);

% train Liknon classifier
W = liknonc(mB_train_dataset,30);

% test trained Liknon classifier
labels = labeld(mB_test_dataset,W);

% accuracy
error_a = 0;
error_b = 0;

for i = 1:30
    if labels(i) == 1
        error_a = error_a + 1;
    end
    
    if labels(i+30) == 0
        error_b = error_b + 1;
    end
end

error_rate = (error_a+error_b)/60;
accuracy = 1-error_rate;

error_all = error_all+error_rate;

end
error_test = [error_test error_all/repeat];
end

%% 
x = 1:300;
x = x*255/100;

plot(x,error_test,'linewidth',2);
xlabel('\sigma');
ylabel('error rate');
title('Curve of error rate changing with different \sigma value');



% for m =1:num
    
    
    
%     [train_in,test_in,train_in_id,test_in_id] = gendat(mB_in,per);
% [train_in_raw,test_in_raw,train_in_id,test_in_id] = gendat(mB_in_raw,0.75);
% Pca_Coeff = pcam(train_in_raw, 0.95);
% train_in_extracted = train_in_raw * Pca_Coeff;
% test_in_extracted = test_in_raw * Pca_Coeff;
% featnum = [1:size(train_in_extracted, 2)];
% mf = max(featnum);
% [Sel_Mapping_Eval, r_Eval_1] = featself(train_in_extracted,'eucl-m', mf);
% featnum = [1:size(train_in_extracted, 2)];
% mf = max(featnum);
% train_in = train_in_extracted * Sel_Mapping_Eval;
% test_in = test_in_extracted * Sel_Mapping_Eval;



% [w, C] = liknonc(train_in, 5);
% 
% 
% %         temp = find(getident(B,'milbag')==test_bag_id(i));
%         result = labeld(test_in.data,w);
% %         result = labeld(B.data(temp,:),fisher);
% %         out_label = combineinstlabels(result);
% %         predict = [predict; result];
%     test_label = test_in.labels;
%     residule = test_label - result;
%     error_a = sum(residule == -1)
%     %banana error
%     error_b = sum(residule == 1)
% 
% % count_1 = 0;
% % count_2 = 0;
% 
% % for i = 1:num
%     count_1 = error_a+count_1;
%     count_2 = error_b+count_2;
% % end
% 
% % c=count_1+count_2;
% error_1 = (count_1/num)/(120*(1-per));
% error_2 = (count_2/num)/(120*(1-per));
% e=(error_1+error_2);
% 
% end






% %%
% 
% e_1_1 = clevalf(train_in,ldc,featnum,[],1,test_in);
% e_1_2 = clevalf(train_in,qdc,featnum,[],1,test_in);
% e_1_3 = clevalf(train_in,fisherc,featnum,[],1,test_in);
% e_1_4 = clevalf(train_in, parzenc,featnum,[],1,test_in);
% e_1_5 = clevalf(train_in, nmc,featnum,[],1,test_in);
% e_1_6 = clevalf(train_in,knnc,featnum,[],1,test_in);
% %%
% % to illustrate errors for the classifiers mentioned above on scenario 1
% figure('Name','Feature Curve on large data size','NumberTitle','off');
% plot(1:mf, e_1_1.error(1:mf), 'linewidth', 1);
% hold on;
% plot(1:mf, e_1_2.error(1:mf), 'linewidth', 1);
% hold on;
% plot(1:mf, e_1_3.error(1:mf), 'linewidth', 1);
% hold on;
% plot(1:mf, e_1_3.error(1:mf), 'linewidth', 1);
% hold on;
% plot(1:mf, e_1_4.error(1:mf), 'linewidth', 1);
% hold on;
% plot(1:mf, e_1_5.error(1:mf), 'linewidth', 1);
% hold on;
% plot(1:mf, e_1_6.error(1:mf), 'linewidth', 1);
% legend({'ldc', 'qdc', 'fisherc', 'parzenc', 'nmc', 'knnc'});









