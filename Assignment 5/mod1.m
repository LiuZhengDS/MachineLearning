clc;
figure;
load("maze.mat");
% initialisation
gamma = 0.9;
% epsilon = [0.1 0.2 0.3 0.4 0.5];
epsilon = [0.1 0.3 0.5 0.7 0.9];


% epsilon = 0.9;
Q_i=0.005;
fig = 1;
alpha = 0.1;
epsilon_prime = 0.1:0.01:0.3;
reward = maze;
reward(2,4) = 1;
% q_l_new = zeros(9,7,4);
ini_row = 8;
ini_col = 6;
q_l_next = zeros(1,1,4);
steps = zeros(1,100);
% tolarence
tol = 1000;
d_1=zeros(100,10000);
d = zeros(100,10000);
d_com = zeros(100,10000);

it=5;
tic;
for ttt_1 = 1:it
    
    ttt_1
    dist_1 = [];
    q_l_new = zeros(9,7,4);
    for m = 1: 100000
        % for each time, go back to original position
        i = ini_row;
        j = ini_col;
%         steps_1(ttt_1) = steps_1(ttt_1) + 1;
        
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
        
        % inner loop
        for n = 1: tol
            
            rand_epsilon = rand(1);
            if rand_epsilon <= 0.25
                % generate random a, assign it to a
                a_temp = randi(4, 1, 1);
                
            else
                if a==1
                    [~, idx] = max(q_l_new(i-1,j,:));
                elseif a==2
                    [~, idx] = max(q_l_new(i+1,j,:));
                elseif a==3
                    [~, idx] = max(q_l_new(i,j+1,:));
                else
                    [~, idx] = max(q_l_new(i,j-1,:));
                end
                a_temp = idx;
            end
            
            
            
            if a == 1
                if reward(i - 1,j) ~= -1
                    q_l_next(:,:,:) = q_l_new(i - 1,j,:);
                    q_l_new(i,j,1) = q_l_new(i,j,1) + alpha * (reward(i - 1,j) + gamma * q_l_next(:,:,a_temp) - q_l_new(i,j,1));
                    i = i - 1;
                else
                    q_l_next(:,:,:) = q_l_new(i,j,:);
                    q_l_new(i,j,1) = q_l_new(i,j,1) + alpha * (reward(i,j) + gamma * q_l_next(:,:,a_temp) - q_l_new(i,j,1));
                end
                
                % down
            elseif a == 2
                
                if reward(i + 1, j) ~= -1
                    q_l_next(:,:,:) = q_l_new(i + 1,j,:);
                    q_l_new(i,j,2) = q_l_new(i,j,2) + alpha * (reward(i + 1,j) + gamma * q_l_next(:,:,a_temp) - q_l_new(i,j,2));
                    i = i + 1;
                else
                    q_l_next(:,:,:) = q_l_new(i,j,:);
                    q_l_new(i,j,2) = q_l_new(i,j,2) + alpha * (reward(i,j) + gamma * q_l_next(:,:,a_temp) - q_l_new(i,j,2));
                end
                % right
            elseif a == 3
                if reward(i, j + 1) ~= -1
                    q_l_next(:,:,:) = q_l_new(i,j + 1,:);
                    q_l_new(i,j,3) = q_l_new(i,j,3) + alpha * (reward(i,j + 1) + gamma * q_l_next(:,:,a_temp) - q_l_new(i,j,3));
                    j = j + 1;
                else
                    q_l_next(:,:,:) = q_l_new(i,j,:);
                    q_l_new(i,j,3) = q_l_new(i,j,3) + alpha * (reward(i,j) + gamma * q_l_next(:,:,a_temp) - q_l_new(i,j,3));
                end
                % left
            else
                if reward(i, j - 1) ~= -1
                    q_l_next(:,:,:) = q_l_new(i,j - 1,:);
                    q_l_new(i,j,4) = q_l_new(i,j,4) + alpha * (reward(i,j - 1) + gamma * q_l_next(:,:,a_temp) - q_l_new(i,j,4));
                    j= j - 1;
                else
                    q_l_next(:,:,:) = q_l_new(i,j,:);
                    q_l_new(i,j,4) = q_l_new(i,j,4) + alpha * (reward(i,j) + gamma * q_l_next(:,:,a_temp) - q_l_new(i,j,4));
                end
            end
            
            if (i==2 && j==4) || n==tol
                break;
            end
            
            a = a_temp;
            
        end
        
        dist_1 = [dist_1 sqrt(sum((max(q_l_new, [], 3) - q_ite).^2, "all"))];
        
        if dist_1(end) < 1e-6
            break;
        end
    end
%     subplot(4,5,ttt_1);
d_1(ttt_1,1:length(dist_1)) = dist_1;
    

end
t_1 = toc;
    
    clc;
q_l_new = zeros(9,7,4);
q_l_old = zeros(9,7,4);
q_l_next = zeros(1,1,4);


% d=zeros(100,10000);
d=zeros(100,10000);
dist = [];
for ttt= 1:it
    ttt
    dist = [];
    q_l_new = zeros(9,7,4);
for m = 1: 100000
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
    
    if dist(end) < 1e-6
        break;
    end
    
end
    d(ttt,1:length(dist)) = dist;
end 

t = toc;

clc;

for ttt_com = 1:it
    
    ttt_com
    dist_com = [];
    q_l_new = ones(9,7,4).*Q_i;
    for m = 1: 100000
        % for each time, go back to original position
        i = ini_row;
        j = ini_col;
%         steps_1(ttt_1) = steps_1(ttt_1) + 1;
        
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
        
        % inner loop
        for n = 1: tol
            
            rand_epsilon = rand(1);
            if rand_epsilon <= 0.25
                % generate random a, assign it to a
                a_temp = randi(4, 1, 1);
                
            else
                if a==1
                    [~, idx] = max(q_l_new(i-1,j,:));
                elseif a==2
                    [~, idx] = max(q_l_new(i+1,j,:));
                elseif a==3
                    [~, idx] = max(q_l_new(i,j+1,:));
                else
                    [~, idx] = max(q_l_new(i,j-1,:));
                end
                a_temp = idx;
            end
            
            
            
            if a == 1
                if reward(i - 1,j) ~= -1
                    q_l_next(:,:,:) = q_l_new(i - 1,j,:);
                    q_l_new(i,j,1) = q_l_new(i,j,1) + alpha * (reward(i - 1,j) + gamma * q_l_next(:,:,a_temp) - q_l_new(i,j,1));
                    i = i - 1;
                else
                    q_l_next(:,:,:) = q_l_new(i,j,:);
                    q_l_new(i,j,1) = q_l_new(i,j,1) + alpha * (reward(i,j) + gamma * q_l_next(:,:,a_temp) - q_l_new(i,j,1));
                end
                
                % down
            elseif a == 2
                
                if reward(i + 1, j) ~= -1
                    q_l_next(:,:,:) = q_l_new(i + 1,j,:);
                    q_l_new(i,j,2) = q_l_new(i,j,2) + alpha * (reward(i + 1,j) + gamma * q_l_next(:,:,a_temp) - q_l_new(i,j,2));
                    i = i + 1;
                else
                    q_l_next(:,:,:) = q_l_new(i,j,:);
                    q_l_new(i,j,2) = q_l_new(i,j,2) + alpha * (reward(i,j) + gamma * q_l_next(:,:,a_temp) - q_l_new(i,j,2));
                end
                % right
            elseif a == 3
                if reward(i, j + 1) ~= -1
                    q_l_next(:,:,:) = q_l_new(i,j + 1,:);
                    q_l_new(i,j,3) = q_l_new(i,j,3) + alpha * (reward(i,j + 1) + gamma * q_l_next(:,:,a_temp) - q_l_new(i,j,3));
                    j = j + 1;
                else
                    q_l_next(:,:,:) = q_l_new(i,j,:);
                    q_l_new(i,j,3) = q_l_new(i,j,3) + alpha * (reward(i,j) + gamma * q_l_next(:,:,a_temp) - q_l_new(i,j,3));
                end
                % left
            else
                if reward(i, j - 1) ~= -1
                    q_l_next(:,:,:) = q_l_new(i,j - 1,:);
                    q_l_new(i,j,4) = q_l_new(i,j,4) + alpha * (reward(i,j - 1) + gamma * q_l_next(:,:,a_temp) - q_l_new(i,j,4));
                    j= j - 1;
                else
                    q_l_next(:,:,:) = q_l_new(i,j,:);
                    q_l_new(i,j,4) = q_l_new(i,j,4) + alpha * (reward(i,j) + gamma * q_l_next(:,:,a_temp) - q_l_new(i,j,4));
                end
            end
            
            if (i==2 && j==4) || n==tol
                break;
            end
            
            a = a_temp;
            
        end
        
        dist_com = [dist_com sqrt(sum((max(q_l_new, [], 3) - q_ite).^2, "all"))];
        
        if dist_com(end) < 1e-6
            break;
        end
    end
%     subplot(4,5,ttt_1);
d_com(ttt_com,1:length(dist_com)) = dist_com;
    

end

%%
    d_1_vec = mean(d_1(1:5,:));
semilogx(d_1_vec,'linewidth',2);
% plot(d_1_vec,'linewidth',2);
    hold on;
    
    d_vec = mean(d(1:5,:));
    semilogx(d_vec,'linewidth',2);
%     plot(d_vec,'linewidth',2);
    hold on;
    
    d_com_vec = mean(d_com(1:5,:));
    semilogx(d_com_vec,'linewidth',2);
%     plot(d_vec,'linewidth',2);
    hold on;
%     %%
%     semilogx(dist,'linewidth',1);
%     hold on;
    legend("SARSA", "Q-learning","Combination");
%     str=['Difference between Q-learning and Q-iteration (\alpha=',num2str(alpha),')'];
str=['Difference between Q-learning/SARSA/Combination and Q-iteration (\alpha,\epsilon=0.1)'];    
title(str);
    xlabel("Number of interaction steps (log)");
    ylabel("Difference in Norm-2");
    
    
%     end
% t=toc;