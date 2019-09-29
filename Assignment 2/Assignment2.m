% b.
% Apply function WeakLearn()

%% c.
% generate data manualluy by applying function gendats() (prtools)
% make the decision line/boundary:
% based on the optimised dimension and theta value
% generate and input data_c based on the requirement:
% u1 = [0; 0] u2 = [2; 0]
data_2 = gendats([50 50], 2, 2);
scatterd(data_2);
hold on;
dat_2 = getdata(data_2);
lab_2 = getlab(data_2);
[feature, theta] = WeakLearn(dat_2, lab_2);
% because it is 2-d situation, so do simply as follow:
if feature == 1
    plot([theta theta], [-50 50]);
elseif feature == 2
    plot([-50 50], [theta theta]);
end
scatterd(prdataset(dat_2, lab_2),'legend');
%% c_rescale.

data_2 = gendats([50 50], 2, 2);
dat_2 = getdata(data_2);
dat_2(:,1) = dat_2(:,1) * 10;
lab_2 = getlab(data_2);
data_2 = prdataset(dat_2, lab_2);
subplot(1,2,1);
scatterd(data_2);
scatterd(prdataset(dat_2, lab_2),'legend');
title('Rescale feaeture 1 (\times10)');
hold on;
dat_2 = getdata(data_2);
lab_2 = getlab(data_2);
[feature, theta] = WeakLearn(dat_2, lab_2);
% because it is 2-d situation, so do simply as follow:
if feature == 1
    plot([theta theta], [-50 50]);
elseif feature == 2
    plot([-50 50], [theta theta]);
end
dat_2 = getdata(data_2);
dat_2(:,1) = dat_2(:,1) / 10;
dat_2(:,2) = dat_2(:,2) * 10;
lab_2 = getlab(data_2);
data_2 = prdataset(dat_2, lab_2);
subplot(1,2,2);
scatterd(data_2);
scatterd(prdataset(dat_2, lab_2),'legend');
title('Rescale feature 2 (\times10)');
hold on;
dat_2 = getdata(data_2);
lab_2 = getlab(data_2);
[feature, theta] = WeakLearn(dat_2, lab_2);
% because it is 2-d situation, so do simply as follow:
if feature == 1
    plot([theta theta], [-50 50]);
elseif feature == 2
    plot([-50 50], [theta theta]);
end


%% d.

data_d_train = dlmread('fashion57_train.txt');
data_d_test = dlmread('fashion57_test.txt');
lab_d_train = [ones(32,1);ones(28,1)+1];
lab_d_test = [ones(195,1);ones(205,1)+1];
[feature, theta] = WeakLearn(data_d_train, lab_d_train);
%%
e_apparent = Error(feature, theta, data_d_train, lab_d_train);
e_true = Error(feature, theta, data_d_test, lab_d_test);


%%
%After T iterations, predict labels using T weighted classifiers
%% f.
[beta, para, w_matrix_f] = AdaBoost(dat_2, lab_2, 100);
AdaLabel_f = AdaClassify(dat_2, beta, para);
%%
figure;
subplot(1,2,1);
scatterd(data_2);
scatterd(data_2,'legend');
title('Gaussian Dataset');
subplot(1,2,2);
imagesc(w_matrix_f'),colorbar;
title('Colorbar of weights');
%%

error_f = sum(abs(AdaLabel_f - lab_2)) / size(dat_2, 1);
%%
plot(w_matrix_f(:,100));
title('Weight Distribution');
%% g
[beta, para, w_matrix_g] = AdaBoost(data_d_train, lab_d_train, 100);
AdaLabel_g = AdaClassify(data_d_test, beta, para);
error_g = sum(abs(AdaLabel_g - lab_d_test)) / size(data_d_test, 1);
%%

error_g_loop = zeros(100, 1);
%%

% for c = 1:100
[beta, para, w_matrix_g] = AdaBoost(data_d_train, lab_d_train, 60);
AdaLabel_g_loop = AdaClassify(data_d_test, beta, para);
error_g_loop(c, 1) = sum(abs(AdaLabel_g_loop - lab_d_test)) / size(data_d_test, 1);
% end

%%

for c = 1:100
[beta, para, w_matrix_g] = AdaBoost(data_d_train, lab_d_train, c);
AdaLabel_g_loop = AdaClassify(data_d_train, beta, para);
error_g_loop_train(c, 1) = sum(abs(AdaLabel_g_loop - lab_d_train)) / size(data_d_train, 1);
end
%%
hold on;
plot(error_g_loop,'LineWidth',1.5);
plot(error_g_loop_train,'LineWidth',1.5);
xlabel('Iteration numbers');
ylabel('Error rate')
title('Train error and test error');
legend('Test Error', 'Train Error');
%%
plot(w_matrix_g(:,60));
title('Weight Distribution');
%%
% feature = para(:,1);
% theta = para(:,2);
% theta = theta(100);
% %%
% sign = para(:,3);
% 
% weight = w_matrix_g(:,100);
% error_train_g = e(feature, theta, sign, data_d_train, lab_d_train, weight);
% error_test_g = e(feature, theta, sign, data_d_train, lab_d_train, weight);

%% h.
error_h_train_2 = zeros(100, 1);
error_h_test_2 = zeros(100, 1);
error_h_train_4 = zeros(100, 1);
error_h_test_4 = zeros(100, 1);
error_h_train_6 = zeros(100, 1);
error_h_test_6 = zeros(100, 1);
error_h_train_10 = zeros(100, 1);
error_h_test_10 = zeros(100, 1);
error_h_train_15 = zeros(100, 1);
error_h_test_15 = zeros(100, 1);
error_h_train_20 = zeros(100, 1);
error_h_test_20 = zeros(100, 1);


%%
n = 2;

r_1 = randi([1 32], 1, n);
r_2 = randi([33 60], 1, n);

trndata_1 = [data_d_train(r_1, :) zeros(n, 1)+1];
trndata_2 = [data_d_train(r_2, :) ones(n, 1)+1];

tstdata_1 = [data_d_test(1: 195,:) zeros(195, 1)+1];
tstdata_2 = [data_d_test(196: end, :) ones(205, 1)+1];

train_data = [trndata_1; trndata_2];
test_data = [tstdata_1; tstdata_2];

for c = 1:100
[beta, para, w_matrix_h] = AdaBoost(train_data(:,1:end-1), train_data(:,end), c);
AdaLabel_h_train = AdaClassify(train_data(:,1:end-1), beta, para);
AdaLabel_h_test = AdaClassify(test_data(:,1:end-1), beta, para);
error_h_train_2(c, 1) = sum(abs(AdaLabel_h_train - train_data(:,end))) / size(train_data, 1);
error_h_test_2(c, 1) = sum(abs(AdaLabel_h_test - test_data(:,end))) / size(test_data, 1);
end
%%
subplot(1,2,1);
hold on;
plot(error_h_train_2,'LineWidth',1.5);
plot(error_h_train_4,'LineWidth',1.5);
plot(error_h_train_6,'LineWidth',1.5);
plot(error_h_train_10,'LineWidth',1.5);
plot(error_h_train_15,'LineWidth',1.5);
plot(error_h_train_20,'LineWidth',1.5);
xlabel('Iteration numbers');
ylabel('Error rate')
title('Train Error');
legend('Size=2', 'Size=4', 'Size=6', 'Size=10', 'Size=15', 'Size=20');

subplot(1,2,2);
hold on;
plot(error_h_test_2,'LineWidth',1.5);
plot(error_h_test_4,'LineWidth',1.5);
plot(error_h_test_6,'LineWidth',1.5);
plot(error_h_test_10,'LineWidth',1.5);
plot(error_h_test_15,'LineWidth',1.5);
plot(error_h_test_20,'LineWidth',1.5);
xlabel('Iteration numbers');
ylabel('Error rate')
title('Test Error');
legend('Size=2', 'Size=4', 'Size=6', 'Size=10', 'Size=15', 'Size=20');