%% Question 2
syms m a;
ezplot(abs(1 - m) + abs(3 - m) + abs(a - m) == pi);
hold on;
% when 1 - x > 0 && 3 - x > 0, the equation can be described as follow
e = ezplot(4 - 2 * m + abs(a - m) == pi);
set(e, 'Color', 'red');
hold on;
ezplot(abs(1 - m) + abs(3 - m) + abs(a - m) == pi);
plot(m==a);
hold on;

%% Question 3
syms a b;
for i = 1:10
x1 = 1;
x2 = 2;
x3 = 3;
x4 = 4;
a = -5:5
b = abs(x1+a) + abs(x2+a) + abs(x3+a) + abs(x4+a);
plot(a,b);
hold on;
end
%%
syms x y;
for a = -3: 3
    % x = m1 - m2 on first dimension
    % y = m1 - m2 on second dimension
    ezplot(abs(x+a) + abs(y+a) == 2);
    hold on;
end
set(gca,'XAxisLocation','origin');
set(gca,'YAxisLocation','origin');
e = ezplot(abs(x) + abs(y) == 2);
set(e, 'Color', 'red');

%% Question 4
ori_digits = load('/Users/zhengliu/ml/Assignment 1/digits.txt');
iteration_num = 0;

%%
% initialise m_plus and m_minus
m_plus = zeros(1, 21);
m_minus = zeros(1, 21);
a = 0;
% set this lambda value if need
lambda = 1;
alpha = 0.0001;
% min_loss = 2e^03;

% Use test set
data = load('train_data');
data = data.trainset;
digits = data;

% calculate loss function
for i = 1:1000

l = loss(m_plus, m_minus, lambda, digits);
% disp(l);


[m_plus, m_minus, a] = gradientDescent(m_plus, m_minus, lambda, alpha, digits);
iteration_num = iteration_num + 1;
% if l_previous - l < 1e-4
%     break;x
% end
% if iteration_num > 1000
%     break;
% end
end




