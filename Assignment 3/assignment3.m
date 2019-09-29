exp(-1)/(exp(-1)+exp(-0.1)+exp(-0.3));
exp(-0.1)/(exp(-1)+exp(-0.1)+exp(-0.3));
exp(-0.3)/(exp(-1)+exp(-0.1)+exp(-0.3));

%%
load('coin_data.mat');
% coin_data.mat:

% input: number of stocks (products): d
% input: time steps: n
% some initialisation
d_product = 5;
step = 213;
% (d) compute adversary moves
z = zeros(213,5);
z = -log(r);
% (e) compute the loss of each expert numercially
% apply the mix loss function
loss_expert = sum(z);
% (f) implement AA
% initialise strategy p
p(1,:) = [0.2, 0.2, 0.2, 0.2, 0.2];
p(2,:) = exp(-z(1,:))./sum(exp(-z(1,:)));
for i = 3: step
    cum_loss = sum(z(1:i-1,:));
    summation = sum(exp(-cum_loss));
    p(i,:) = exp(-cum_loss)./summation;
end
% (g) AA loss (our loss)
p_z = sum((p .* exp(-z)),2);
% calculate loss on each step
for i = 1: step
    loss(i,:) = -log(p_z(i,:));
end
loss_our = sum(loss);

% (h)
loss_expert_min = min(loss_expert);
regret = loss_our - loss_expert_min;





