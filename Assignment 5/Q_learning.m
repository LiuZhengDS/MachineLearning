clc;
load("maze.mat");
% initialisation
gamma = 0.9;
% epsilon = [0.1 0.2 0.3 0.4 0.5];
epsilon = [0.1 0.3 0.5 0.7 0.9];
% epsilon = 0.9;
alpha = 0.3;

reward = maze;
reward(2,4) = 1;
q_l_new = zeros(9,7,4);
q_l_old = zeros(9,7,4);
ite_count = 0;
ini_row = 8;
ini_col = 6;
q_l_next = zeros(1,1,4);
steps = zeros(1,100);
% tolarence
tol = 2000;

tic;
% for ttt = 1:100
%     ttt
fig = 2
dist = [];
q_l_new = zeros(9,7,4);
for m = 1: 10000
    % for each time, go back to original position
    i = ini_row;
    j = ini_col;
    steps(ttt) = steps(ttt) + 1;
        
    for n = 1: tol
        % argmax operation
        [~, idx] = max(q_l_new(i,j,:));
        % assign argmax_a to a
        a = idx;
        % apply epsilon as probabiblity to reassign a or not
        rand_epsilon = rand(1);
        
        if rand_epsilon <= epsilon(fig)
            % generate random a, assign it to a
            rand_a = randi(4, 1, 1);
            a = rand_a;
        end
        
        % apply a
        % up
        if a == 1
            if reward(i - 1,j) ~= -1
                q_l_next(:,:,:) = q_l_new(i - 1,j,:);
                q_l_new(i,j,1) = q_l_new(i,j,1) + alpha * (reward(i - 1,j) + gamma * max(q_l_next(:,:,:)) - q_l_new(i,j,1));
                i = i - 1;
            else
                q_l_next(:,:,:) = q_l_new(i,j,:);
                q_l_new(i,j,1) = q_l_new(i,j,1) + alpha * (reward(i,j) + gamma * max(q_l_next(:,:,:)) - q_l_new(i,j,1));
            end
            
            % down
        elseif a == 2
            
            if reward(i + 1, j) ~= -1
                q_l_next(:,:,:) = q_l_new(i + 1,j,:);
                q_l_new(i,j,2) = q_l_new(i,j,2) + alpha * (reward(i + 1,j) + gamma * max(q_l_next(:,:,:)) - q_l_new(i,j,2));
                i = i + 1;
            else
                q_l_next(:,:,:) = q_l_new(i,j,:);
                q_l_new(i,j,2) = q_l_new(i,j,2) + alpha * (reward(i,j) + gamma * max(q_l_next(:,:,:)) - q_l_new(i,j,2));
            end
            % right
        elseif a == 3
            if reward(i, j + 1) ~= -1
                q_l_next(:,:,:) = q_l_new(i,j + 1,:);
                q_l_new(i,j,3) = q_l_new(i,j,3) + alpha * (reward(i,j + 1) + gamma * max(q_l_next(:,:,:)) - q_l_new(i,j,3));
                j = j + 1;
            else
                q_l_next(:,:,:) = q_l_new(i,j,:);
                q_l_new(i,j,3) = q_l_new(i,j,3) + alpha * (reward(i,j) + gamma * max(q_l_next(:,:,:)) - q_l_new(i,j,3));
            end
            % left
        else
            if reward(i, j - 1) ~= -1
                q_l_next(:,:,:) = q_l_new(i,j - 1,:);
                q_l_new(i,j,4) = q_l_new(i,j,4) + alpha * (reward(i,j - 1) + gamma * max(q_l_next(:,:,:)) - q_l_new(i,j,4));
                j= j - 1;
            else
                q_l_next(:,:,:) = q_l_new(i,j,:);
                q_l_new(i,j,4) = q_l_new(i,j,4) + alpha * (reward(i,j) + gamma * max(q_l_next(:,:,:)) - q_l_new(i,j,4));
            end
        end
        
        if (i==2 && j==4) || n==tol
            break;
        end
        
    end
    dist = [dist sqrt(sum((max(q_l_new, [], 3) - q_ite).^2, "all"))];
    
    if dist(end) < 1e-8
        break;
    end
end

semilogx(dist,'linewidth',1);
% plot(dist,'linewidth',1);
legend("\epsilon=0.1", "\epsilon=0.3", "\epsilon=0.5", "\epsilon=0.7", "\epsilon=0.9");
str=['Difference between Q-learning and Q-iteration (\alpha=',num2str(alpha),')'];
title(str);
title(str);
xlabel("Number of interaction steps (log)");
ylabel("Difference in Norm-2");
hold on;
% end
% end
t=toc;
% %%
% zz = zeros(1,10000);
% for z = 1:10000
%    zz(z) = randi(4,1,1); 
% end
% 
% one = size(find(zz == 1));
% two = size(find(zz == 2));
% three = size(find(zz == 3));
% four = size(find(zz == 4));










