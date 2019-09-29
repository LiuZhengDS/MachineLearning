% Exercise: Aggregating Algorithm (AA)
clear all;
load coin_data;
d = 5;
n = 213;
% (d) compute adversary movez z_t
z = zeros(213,5);
z = -log(r);
% (e) compute losses of experts
loss_expert = sum(z);
% compute strategy p_t (see slides)
p(1,:) = [0.2, 0.2, 0.2, 0.2, 0.2];
p(2,:) = exp(-z(1, :)) ./ sum(exp(-z(1, :)));
for i = 3: n
    cum_loss = sum(z(1:i-1, :));
    summation = sum(exp(-cum_loss));
    p(i,:) = exp(-cum_loss) ./ summation;
end
% compute loss of strategy p_t
% (g) AA loss (our loss)
p_z = sum((p .* exp(-z)), 2);
% calculate loss on each step
loss_our = 0;
for i = 1: n
    loss(i, :) = -log(p_z(i, :));
    loss_our = loss(i, :) + loss_our;
end
% pick out best expert
loss_expert_min = min(loss_expert);
% (j) compute regret
regret = loss_our - loss_expert_min;
% (n) compute total gain of investing with strategy p_t
increase = p(n, :) * s(n, :)' - p(1, :) * s0(1, :)';
gain = exp(-loss_our);


%% plot of the strategy p and the coin data
% if you store the strategy in the matrix p (size n * d)
% this piece of code will visualize your strategy
figure
subplot(1, 2, 1);
plot(p, 'LineWidth', 1)
legend(symbols_str)
title('rebalancing strategy AA')
xlabel('date')
ylabel('confidence p_t in the experts')
subplot(1, 2, 2);
plot(s,'LineWidth', 1)
legend(symbols_str)
title('worth of coins')
xlabel('date')
ylabel('USD')