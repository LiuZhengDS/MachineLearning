clc;
clear;
data = load('/Users/zhengliu/ml/Assignment 1/digits.txt','X');
train = [];
test = [];
l = [];
for dd = 1:10
    data = load('/Users/zhengliu/ml/Assignment 1/digits.txt','X');
    % Train set / Test set split-up
    rand_count = 1000 / 2;

    class_1 = data(1:10000, :);
    class_2 = data(10001:size(data,1), :);

    c1 = randperm(size(class_1, 1),rand_count);
    c2 = randperm(size(class_2, 1),rand_count);

    % ---  Train Set ---
    train_c1 = class_1(c1,:);
    train_c2 = class_2(c2,:);

    trainset = [train_c1; train_c2];

    % ---  Test Set ---
    test_c1 = class_1;
    test_c1(c1,:) = [];
    test_c2 = class_2;
    test_c2(c2,:) = [];

    testset = [test_c1; test_c2];

    save('train_data','trainset','testset');
    
    m_plus = zeros(1, 21);
m_minus = zeros(1, 21);
a = 0;
% set this lambda value if need
lambda = 10000;
alpha = 0.00001;
% min_loss = 2e^03;

% Use test set
data = load('train_data');
data = data.trainset;
digits = data;
iteration_num = 0;
min_loss = 1e5;
tolerance = 5*1e-5;
% calculate loss function
for i = 1:1000
los = loss(m_plus, m_minus, lambda, digits);
% disp(l);
[m_plus, m_minus, a] = gradientDescent(m_plus, m_minus, lambda, alpha, digits);
iteration_num = iteration_num + 1;
if min_loss - los < tolerance || los > min_loss
    num_unchanging = num_unchanging + 1;
else
    num_unchanging = 0;
end

if los <= min_loss
    min_loss = los;
    m_p = m_plus;
    m_m = m_minus;
end

% stop iteration if the loss hasn't decreased much for many iterations
if num_unchanging > 30 
    break
end


end

%NmC Classifier Test

% trained_param = load('trained_m','M');
% trained_param = trained_param.M;

l = [l; min_loss];
m_1 = m_p;
m_2 = m_m;
a = a;

apparent_right_ans = 0;



% Apparent Error
% Use test set
data = load('train_data');
data = data.trainset;
class = [];

for i = 1:size(data,1)
    x_i = data(i,:);
    given_class = 0;
    if norm(m_1 - x_i , 2) <= norm(m_2 - x_i, 2) 
        given_class = 0;
    else
        given_class = 1;
    end
    
    if (given_class == 0 && i<=size(data,1)/2) || (given_class == 1 && i>size(data,1)/2)
        apparent_right_ans = apparent_right_ans + 1;
    end
    class = [class; given_class];
end

apparent_wrong_ans = size(data,1) - apparent_right_ans;

apparent_error_per = (apparent_wrong_ans/size(data,1)) * 100;

train = [train; apparent_error_per];

true_right_ans = 0;

% Test Error
data = load('train_data');
data = data.testset;

class = [];

for i = 1:size(data,1)
    x_i = data(i,:);
    given_class = 0;
    if norm(m_1 - x_i , 2) <= norm(m_2 - x_i, 2) 
        given_class = 0;
    else
        given_class = 1;
    end
    
    if (given_class == 0 && i<=size(data,1)/2) || (given_class == 1 && i>size(data,1)/2)
        true_right_ans = true_right_ans + 1;
    end
    class = [class; given_class];

end

true_wrong_ans = size(data,1) - true_right_ans;

true_error_per = (true_wrong_ans/size(data,1)) * 100;
test = [test; true_error_per];
end
error = [train test l];
e = [];
mean(m_plus)
mean(m_minus)
std(m_plus)
std(m_minus)
e = [mean(m_plus) mean(m_minus) std(m_plus) std(m_minus)];
Average_plus=mean(m_plus);
Variance_plus=std(m_plus);
Average_minus=mean(m_minus);
Variance_minus=std(m_minus);
%%
figure();
hold on;
title('Average Medians & Standard Deviation, 1000 samples, lambda=10000')
errorbar(1,Average_plus,Variance_plus,'Color','g','Marker','o','MarkerFaceColor','b','MarkerEdgeColor','b','MarkerSize',10,'LineWidth',1);
hold on;
errorbar(4,Average_minus,Variance_minus,'Color','r','Marker','o','MarkerFaceColor','b','MarkerEdgeColor','b','MarkerSize',10,'LineWidth',1);
legend({'m+','m-'},'Location','northeast');
xlim([0 5])

set(gca,'xtick',[])%去掉x轴的刻度

% xlabel('月份');
% ylabel('mean of median');


%%


figure();
hold on
title('Average Medians & Standard Deviation, 10 samples, lambda=0')
xlabel('Dimension')
ylabel('Mean & Std')

x=1:1:21;
y=[transpose(m_plus) ; transpose(m_minus)];
err=[transpose(std(m_minus)) ; transpose(std)];

errorbar(x,y(1,:),err(1,:),'o','MarkerSize',10,'MarkerEdgeColor','green','MarkerFaceColor','green', 'LineStyle','-')
errorbar(x,y(2,:),err(2,:),'o','MarkerSize',10,'MarkerEdgeColor','red','MarkerFaceColor','red', 'LineStyle','-')
xticks(x);
xticklabels({'1','2','3','4','5','6','7','8','9','10','11','12','13','14','15','16','17','18','19','20','21'})
legend({'m+','m-'},'Location','northeast');
hold off
