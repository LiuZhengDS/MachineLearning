load("maze.mat");
clc;
% initialisation
gamma_1 = 0.9;
epsilon_1 = [0.1 0.3 0.5 0.7 0.9];
% alpha = [0.1 0.3 0.5 0.7 0.9];
% epsilon = 0.9;
alpha_1 = 0.5;
reward_1 = maze;
reward_1(2,4) = 1;
q_l_new_1 = zeros(9,7,4);
ini_row = 8;
ini_col = 6;
q_l_next_1 = zeros(1,1,4);
steps_1 = zeros(1,100);
% tolarence
tol_1 = 2000;


tic;
for ttt_1 = 1:100
    ttt_1
    fig_1 = 3
    dist_1 = [];
    q_l_new_1 = zeros(9,7,4);
    
    for m_1 = 1: 10000
        % for each time, go back to original position
        i_1 = ini_row;
        j_1 = ini_col;
        steps_1(ttt_1) = steps_1(ttt_1) + 1;
        
        for n = 1: tol_1
            % argmax operation
            [~, idx_a] = max(q_l_new_1(i_1,j_1,:));
            % assign argmax_a to a
            a_1 = idx_a;
            % apply epsilon as probabiblity to reassign a or not
            rand_epsilon = rand(1);
            
            if rand_epsilon <= epsilon_1(fig_1)
                % generate random a, assign it to a
                rand_a = randi(4, 1, 1);
                a_1 = rand_a;
            end
            
            % apply a
            % up
            rand_epsilon = rand(1);
            if a_1 == 1
                if reward_1(i_1 - 1,j_1) ~= -1
                    
                    q_l_next_1(:,:,:) = q_l_new_1(i_1 - 1,j_1,:);
                    
                    [~, idx_b] = max(q_l_new_1(i_1 - 1,j_1,:));
                    % assign argmax_a to a
                    b_1 = idx_b;
                    
                    % sarsa in
                    if rand_epsilon <= epsilon_1(fig_1)
                        % generate random a, assign it to a
                        rand_b = randi(4, 1, 1);
                        b_1 = rand_b;
                    end
                    
                    if b_1 == 1
                        if reward_1(i_1 - 2,j_1) ~= 0
                            q_l_new_1(i_1,j_1,1) = q_l_new_1(i_1,j_1,1) + alpha_1 * (reward_1(i_1 - 1,j_1) + gamma_1 * q_l_next_1(:,:,b_1) - q_l_new_1(i_1,j_1,1));
                        else
                            q_l_new_1(i_1,j_1,1) = q_l_new_1(i_1,j_1,1) + alpha_1 * (reward_1(i_1 - 1,j_1) + gamma_1 * max(q_l_next_1(:,:,:)) - q_l_new_1(i_1,j_1,1));
                        end
                        
                    elseif b_1 == 2
                        if reward_1(i_1,j_1) ~= 0
                            q_l_new_1(i_1,j_1,1) = q_l_new_1(i_1,j_1,1) + alpha_1 * (reward_1(i_1 - 1,j_1) + gamma_1 * q_l_next_1(:,:,b_1) - q_l_new_1(i_1,j_1,1));
                        else
                            q_l_new_1(i_1,j_1,1) = q_l_new_1(i_1,j_1,1) + alpha_1 * (reward_1(i_1 - 1,j_1) + gamma_1 * max(q_l_next_1(:,:,:)) - q_l_new_1(i_1,j_1,1));
                        end
                        
                    elseif b_1 == 3
                        if reward_1(i_1 - 1,j_1 + 1) ~= 0
                            q_l_new_1(i_1,j_1,1) = q_l_new_1(i_1,j_1,1) + alpha_1 * (reward_1(i_1 - 1,j_1) + gamma_1 * q_l_next_1(:,:,b_1) - q_l_new_1(i_1,j_1,1));
                        else
                            q_l_new_1(i_1,j_1,1) = q_l_new_1(i_1,j_1,1) + alpha_1 * (reward_1(i_1 - 1,j_1) + gamma_1 * max(q_l_next_1(:,:,:)) - q_l_new_1(i_1,j_1,1));
                        end
                        
                    else
                        if reward_1(i_1 - 1,j_1 - 1) ~= 0
                            q_l_new_1(i_1,j_1,1) = q_l_new_1(i_1,j_1,1) + alpha_1 * (reward_1(i_1 - 1,j_1) + gamma_1 * q_l_next_1(:,:,b_1) - q_l_new_1(i_1,j_1,1));
                        else
                            q_l_new_1(i_1,j_1,1) = q_l_new_1(i_1,j_1,1) + alpha_1 * (reward_1(i_1 - 1,j_1) + gamma_1 * max(q_l_next_1(:,:,:)) - q_l_new_1(i_1,j_1,1));
                        end
                    end
                    i_1 = i_1 - 1;
                    
                else
                    q_l_next_1(:,:,:) = q_l_new_1(i_1,j_1,:);
                    
                    [~, idx_b] = max(q_l_new_1(i_1,j_1,:));
                    % assign argmax_a to a
                    b_1 = idx_b;
                    
                    % sarsa in
                    if rand_epsilon <= epsilon_1(fig_1)
                        % generate random a, assign it to a
                        rand_b = randi(4, 1, 1);
                        b_1 = rand_b;
                    end
                    
                    if b_1 == 1
                        if reward_1(i_1 - 1,j_1) ~= 0
                            q_l_new_1(i_1,j_1,1) = q_l_new_1(i_1,j_1,1) + alpha_1 * (reward_1(i_1,j_1) + gamma_1 * q_l_next_1(:,:,b_1) - q_l_new_1(i_1,j_1,1));
                        else
                            q_l_new_1(i_1,j_1,1) = q_l_new_1(i_1,j_1,1) + alpha_1 * (reward_1(i_1,j_1) + gamma_1 * max(q_l_next_1(:,:,:)) - q_l_new_1(i_1,j_1,1));
                        end
                    elseif b_1 == 2
                        if reward_1(i_1 + 1,j_1) ~= 0
                            q_l_new_1(i_1,j_1,1) = q_l_new_1(i_1,j_1,1) + alpha_1 * (reward_1(i_1,j_1) + gamma_1 * q_l_next_1(:,:,b_1) - q_l_new_1(i_1,j_1,1));
                        else
                            q_l_new_1(i_1,j_1,1) = q_l_new_1(i_1,j_1,1) + alpha_1 * (reward_1(i_1,j_1) + gamma_1 * max(q_l_next_1(:,:,:)) - q_l_new_1(i_1,j_1,1));
                        end
                    elseif b_1 == 3
                        if reward_1(i_1,j_1 + 1) ~= 0
                            q_l_new_1(i_1,j_1,1) = q_l_new_1(i_1,j_1,1) + alpha_1 * (reward_1(i_1,j_1) + gamma_1 * q_l_next_1(:,:,b_1) - q_l_new_1(i_1,j_1,1));
                        else
                            q_l_new_1(i_1,j_1,1) = q_l_new_1(i_1,j_1,1) + alpha_1 * (reward_1(i_1,j_1) + gamma_1 * max(q_l_next_1(:,:,:)) - q_l_new_1(i_1,j_1,1));
                        end
                    else
                        
                        if reward_1(i_1,j_1 - 1) ~= 0
                            q_l_new_1(i_1,j_1,1) = q_l_new_1(i_1,j_1,1) + alpha_1 * (reward_1(i_1,j_1) + gamma_1 * q_l_next_1(:,:,b_1) - q_l_new_1(i_1,j_1,1));
                        else
                            q_l_new_1(i_1,j_1,1) = q_l_new_1(i_1,j_1,1) + alpha_1 * (reward_1(i_1,j_1) + gamma_1 * max(q_l_next_1(:,:,:)) - q_l_new_1(i_1,j_1,1));
                        end
                    end
                    
                end
                
                % down
            elseif a_1 == 2
                
                
                if reward_1(i_1 + 1,j_1) ~= -1
                    
                    q_l_next_1(:,:,:) = q_l_new_1(i_1 + 1,j_1,:);
                    
                    [~, idx_b] = max(q_l_new_1(i_1 + 1,j_1,:));
                    % assign argmax_a to a
                    b_1 = idx_b;
                    
                    % sarsa in
                    if rand_epsilon <= epsilon_1(fig_1)
                        % generate random a, assign it to a
                        rand_b = randi(4, 1, 1);
                        b_1 = rand_b;
                    end
                    
                    if b_1 == 1
                        if reward_1(i_1,j_1) ~= 0
                            q_l_new_1(i_1,j_1,2) = q_l_new_1(i_1,j_1,2) + alpha_1 * (reward_1(i_1 + 1,j_1) + gamma_1 * q_l_next_1(:,:,b_1) - q_l_new_1(i_1,j_1,2));
                        else
                            q_l_new_1(i_1,j_1,2) = q_l_new_1(i_1,j_1,2) + alpha_1 * (reward_1(i_1 + 1,j_1) + gamma_1 * max(q_l_next_1(:,:,:)) - q_l_new_1(i_1,j_1,2));
                        end
                        
                    elseif b_1 == 2
                        if reward_1(i_1 + 2,j_1) ~= 0
                            q_l_new_1(i_1,j_1,2) = q_l_new_1(i_1,j_1,2) + alpha_1 * (reward_1(i_1 + 1,j_1) + gamma_1 * q_l_next_1(:,:,b_1) - q_l_new_1(i_1,j_1,2));
                        else
                            q_l_new_1(i_1,j_1,2) = q_l_new_1(i_1,j_1,2) + alpha_1 * (reward_1(i_1 + 1,j_1) + gamma_1 * max(q_l_next_1(:,:,:)) - q_l_new_1(i_1,j_1,2));
                        end
                        
                    elseif b_1 == 3
                        if reward_1(i_1 + 1,j_1 + 1) ~= 0
                            q_l_new_1(i_1,j_1,2) = q_l_new_1(i_1,j_1,2) + alpha_1 * (reward_1(i_1 + 1,j_1) + gamma_1 * q_l_next_1(:,:,b_1) - q_l_new_1(i_1,j_1,2));
                        else
                            q_l_new_1(i_1,j_1,2) = q_l_new_1(i_1,j_1,2) + alpha_1 * (reward_1(i_1 + 1,j_1) + gamma_1 * max(q_l_next_1(:,:,:)) - q_l_new_1(i_1,j_1,2));
                        end
                        
                    else
                        if reward_1(i_1 + 1,j_1 - 1) ~= 0
                            q_l_new_1(i_1,j_1,2) = q_l_new_1(i_1,j_1,2) + alpha_1 * (reward_1(i_1 + 1,j_1) + gamma_1 * q_l_next_1(:,:,b_1) - q_l_new_1(i_1,j_1,2));
                        else
                            q_l_new_1(i_1,j_1,2) = q_l_new_1(i_1,j_1,2) + alpha_1 * (reward_1(i_1 + 1,j_1) + gamma_1 * max(q_l_next_1(:,:,:)) - q_l_new_1(i_1,j_1,2));
                        end
                    end
                    i_1 = i_1 + 1;
                    
                else
                    q_l_next_1(:,:,:) = q_l_new_1(i_1,j_1,:);
                    
                    [~, idx_b] = max(q_l_new_1(i_1,j_1,:));
                    % assign argmax_a to a
                    b_1 = idx_b;
                    
                    % sarsa in
                    if rand_epsilon <= epsilon_1(fig_1)
                        % generate random a, assign it to a
                        rand_b = randi(4, 1, 1);
                        b_1 = rand_b;
                    end
                    
                    if b_1 == 1
                        if reward_1(i_1 - 1,j_1) ~= 0
                            q_l_new_1(i_1,j_1,2) = q_l_new_1(i_1,j_1,2) + alpha_1 * (reward_1(i_1,j_1) + gamma_1 * q_l_next_1(:,:,b_1) - q_l_new_1(i_1,j_1,2));
                        else
                            q_l_new_1(i_1,j_1,2) = q_l_new_1(i_1,j_1,2) + alpha_1 * (reward_1(i_1,j_1) + gamma_1 * max(q_l_next_1(:,:,:)) - q_l_new_1(i_1,j_1,2));
                        end
                    elseif b_1 == 2
                        if reward_1(i_1 + 1,j_1) ~= 0
                            q_l_new_1(i_1,j_1,2) = q_l_new_1(i_1,j_1,2) + alpha_1 * (reward_1(i_1,j_1) + gamma_1 * q_l_next_1(:,:,b_1) - q_l_new_1(i_1,j_1,2));
                        else
                            q_l_new_1(i_1,j_1,2) = q_l_new_1(i_1,j_1,2) + alpha_1 * (reward_1(i_1,j_1) + gamma_1 * max(q_l_next_1(:,:,:)) - q_l_new_1(i_1,j_1,2));
                        end
                    elseif b_1 == 3
                        if reward_1(i_1,j_1 + 1) ~= 0
                            q_l_new_1(i_1,j_1,2) = q_l_new_1(i_1,j_1,2) + alpha_1 * (reward_1(i_1,j_1) + gamma_1 * q_l_next_1(:,:,b_1) - q_l_new_1(i_1,j_1,2));
                        else
                            q_l_new_1(i_1,j_1,2) = q_l_new_1(i_1,j_1,2) + alpha_1 * (reward_1(i_1,j_1) + gamma_1 * max(q_l_next_1(:,:,:)) - q_l_new_1(i_1,j_1,2));
                        end
                    else
                        
                        if reward_1(i_1,j_1 - 1) ~= 0
                            q_l_new_1(i_1,j_1,2) = q_l_new_1(i_1,j_1,2) + alpha_1 * (reward_1(i_1,j_1) + gamma_1 * q_l_next_1(:,:,b_1) - q_l_new_1(i_1,j_1,2));
                        else
                            q_l_new_1(i_1,j_1,2) = q_l_new_1(i_1,j_1,2) + alpha_1 * (reward_1(i_1,j_1) + gamma_1 * max(q_l_next_1(:,:,:)) - q_l_new_1(i_1,j_1,2));
                        end
                    end
                    
                end
                
                % right
            elseif a_1 == 3
                
                
                if reward_1(i_1,j_1 + 1) ~= -1
                    
                    q_l_next_1(:,:,:) = q_l_new_1(i_1,j_1 + 1,:);
                    
                    [~, idx_b] = max(q_l_new_1(i_1,j_1 + 1,:));
                    % assign argmax_a to a
                    b_1 = idx_b;
                    
                    % sarsa in
                    if rand_epsilon <= epsilon_1(fig_1)
                        % generate random a, assign it to a
                        rand_b = randi(4, 1, 1);
                        b_1 = rand_b;
                    end
                    
                    if b_1 == 1
                        if reward_1(i_1 - 1,j_1 + 1) ~= 0
                            q_l_new_1(i_1,j_1,3) = q_l_new_1(i_1,j_1,3) + alpha_1 * (reward_1(i_1,j_1 + 1) + gamma_1 * q_l_next_1(:,:,b_1) - q_l_new_1(i_1,j_1,3));
                        else
                            q_l_new_1(i_1,j_1,3) = q_l_new_1(i_1,j_1,3) + alpha_1 * (reward_1(i_1,j_1 + 1) + gamma_1 * max(q_l_next_1(:,:,:)) - q_l_new_1(i_1,j_1,3));
                        end
                        
                    elseif b_1 == 2
                        if reward_1(i_1 + 1,j_1 + 1) ~= 0
                            q_l_new_1(i_1,j_1,3) = q_l_new_1(i_1,j_1,3) + alpha_1 * (reward_1(i_1,j_1 + 1) + gamma_1 * q_l_next_1(:,:,b_1) - q_l_new_1(i_1,j_1,3));
                        else
                            q_l_new_1(i_1,j_1,3) = q_l_new_1(i_1,j_1,3) + alpha_1 * (reward_1(i_1,j_1 + 1) + gamma_1 * max(q_l_next_1(:,:,:)) - q_l_new_1(i_1,j_1,3));
                        end
                        
                    elseif b_1 == 3
                        if reward_1(i_1,j_1 + 2) ~= 0
                            q_l_new_1(i_1,j_1,3) = q_l_new_1(i_1,j_1,3) + alpha_1 * (reward_1(i_1,j_1 + 1) + gamma_1 * q_l_next_1(:,:,b_1) - q_l_new_1(i_1,j_1,3));
                        else
                            q_l_new_1(i_1,j_1,3) = q_l_new_1(i_1,j_1,3) + alpha_1 * (reward_1(i_1,j_1 + 1) + gamma_1 * max(q_l_next_1(:,:,:)) - q_l_new_1(i_1,j_1,3));
                        end
                        
                    else
                        if reward_1(i_1,j_1) ~= 0
                            q_l_new_1(i_1,j_1,3) = q_l_new_1(i_1,j_1,3) + alpha_1 * (reward_1(i_1,j_1 + 1) + gamma_1 * q_l_next_1(:,:,b_1) - q_l_new_1(i_1,j_1,3));
                        else
                            q_l_new_1(i_1,j_1,3) = q_l_new_1(i_1,j_1,3) + alpha_1 * (reward_1(i_1,j_1 + 1) + gamma_1 * max(q_l_next_1(:,:,:)) - q_l_new_1(i_1,j_1,3));
                        end
                    end
                    j_1 = j_1 + 1;
                    
                else
                    q_l_next_1(:,:,:) = q_l_new_1(i_1,j_1,:);
                    
                    [~, idx_b] = max(q_l_new_1(i_1,j_1,:));
                    % assign argmax_a to a
                    b_1 = idx_b;
                    
                    % sarsa in
                    if rand_epsilon <= epsilon_1(fig_1)
                        % generate random a, assign it to a
                        rand_b = randi(4, 1, 1);
                        b_1 = rand_b;
                    end
                    
                    if b_1 == 1
                        if reward_1(i_1 - 1,j_1) ~= 0
                            q_l_new_1(i_1,j_1,3) = q_l_new_1(i_1,j_1,3) + alpha_1 * (reward_1(i_1,j_1) + gamma_1 * q_l_next_1(:,:,b_1) - q_l_new_1(i_1,j_1,3));
                        else
                            q_l_new_1(i_1,j_1,3) = q_l_new_1(i_1,j_1,3) + alpha_1 * (reward_1(i_1,j_1) + gamma_1 * max(q_l_next_1(:,:,:)) - q_l_new_1(i_1,j_1,3));
                        end
                    elseif b_1 == 2
                        if reward_1(i_1 + 1,j_1) ~= 0
                            q_l_new_1(i_1,j_1,3) = q_l_new_1(i_1,j_1,3) + alpha_1 * (reward_1(i_1,j_1) + gamma_1 * q_l_next_1(:,:,b_1) - q_l_new_1(i_1,j_1,3));
                        else
                            q_l_new_1(i_1,j_1,3) = q_l_new_1(i_1,j_1,3) + alpha_1 * (reward_1(i_1,j_1) + gamma_1 * max(q_l_next_1(:,:,:)) - q_l_new_1(i_1,j_1,3));
                        end
                    elseif b_1 == 3
                        if reward_1(i_1,j_1 + 1) ~= 0
                            q_l_new_1(i_1,j_1,3) = q_l_new_1(i_1,j_1,3) + alpha_1 * (reward_1(i_1,j_1) + gamma_1 * q_l_next_1(:,:,b_1) - q_l_new_1(i_1,j_1,3));
                        else
                            q_l_new_1(i_1,j_1,3) = q_l_new_1(i_1,j_1,3) + alpha_1 * (reward_1(i_1,j_1) + gamma_1 * max(q_l_next_1(:,:,:)) - q_l_new_1(i_1,j_1,3));
                        end
                    else
                        
                        if reward_1(i_1,j_1 - 1) ~= 0
                            q_l_new_1(i_1,j_1,3) = q_l_new_1(i_1,j_1,3) + alpha_1 * (reward_1(i_1,j_1) + gamma_1 * q_l_next_1(:,:,b_1) - q_l_new_1(i_1,j_1,3));
                        else
                            q_l_new_1(i_1,j_1,3) = q_l_new_1(i_1,j_1,3) + alpha_1 * (reward_1(i_1,j_1) + gamma_1 * max(q_l_next_1(:,:,:)) - q_l_new_1(i_1,j_1,3));
                        end
                    end
                    
                end
                
                
                
                
                
                
                % left
            else
                
                
                if reward_1(i_1,j_1 - 1) ~= -1
                    
                    q_l_next_1(:,:,:) = q_l_new_1(i_1,j_1 - 1,:);
                    
                    [~, idx_b] = max(q_l_new_1(i_1,j_1 - 1,:));
                    % assign argmax_a to a
                    b_1 = idx_b;
                    
                    % sarsa in
                    if rand_epsilon <= epsilon_1(fig_1)
                        % generate random a, assign it to a
                        rand_b = randi(4, 1, 1);
                        b_1 = rand_b;
                    end
                    
                    if b_1 == 1
                        if reward_1(i_1 - 1,j_1 - 1) ~= 0
                            q_l_new_1(i_1,j_1,4) = q_l_new_1(i_1,j_1,4) + alpha_1 * (reward_1(i_1,j_1 - 1) + gamma_1 * q_l_next_1(:,:,b_1) - q_l_new_1(i_1,j_1,4));
                        else
                            q_l_new_1(i_1,j_1,4) = q_l_new_1(i_1,j_1,4) + alpha_1 * (reward_1(i_1,j_1 - 1) + gamma_1 * max(q_l_next_1(:,:,:)) - q_l_new_1(i_1,j_1,4));
                        end
                        
                    elseif b_1 == 2
                        if reward_1(i_1 + 1,j_1 - 1) ~= 0
                            q_l_new_1(i_1,j_1,4) = q_l_new_1(i_1,j_1,4) + alpha_1 * (reward_1(i_1,j_1 - 1) + gamma_1 * q_l_next_1(:,:,b_1) - q_l_new_1(i_1,j_1,4));
                        else
                            q_l_new_1(i_1,j_1,4) = q_l_new_1(i_1,j_1,4) + alpha_1 * (reward_1(i_1,j_1 - 1) + gamma_1 * max(q_l_next_1(:,:,:)) - q_l_new_1(i_1,j_1,4));
                        end
                        
                    elseif b_1 == 3
                        if reward_1(i_1,j_1) ~= 0
                            q_l_new_1(i_1,j_1,4) = q_l_new_1(i_1,j_1,4) + alpha_1 * (reward_1(i_1,j_1 - 1) + gamma_1 * q_l_next_1(:,:,b_1) - q_l_new_1(i_1,j_1,4));
                        else
                            q_l_new_1(i_1,j_1,4) = q_l_new_1(i_1,j_1,4) + alpha_1 * (reward_1(i_1,j_1 - 1) + gamma_1 * max(q_l_next_1(:,:,:)) - q_l_new_1(i_1,j_1,4));
                        end
                        
                    else
                        if reward_1(i_1,j_1 - 2) ~= 0
                            q_l_new_1(i_1,j_1,4) = q_l_new_1(i_1,j_1,4) + alpha_1 * (reward_1(i_1,j_1 - 1) + gamma_1 * q_l_next_1(:,:,b_1) - q_l_new_1(i_1,j_1,4));
                        else
                            q_l_new_1(i_1,j_1,4) = q_l_new_1(i_1,j_1,4) + alpha_1 * (reward_1(i_1,j_1 - 1) + gamma_1 * max(q_l_next_1(:,:,:)) - q_l_new_1(i_1,j_1,4));
                        end
                    end
                    j_1 = j_1 - 1;
                    
                else
                    q_l_next_1(:,:,:) = q_l_new_1(i_1,j_1,:);
                    
                    [~, idx_b] = max(q_l_new_1(i_1,j_1,:));
                    % assign argmax_a to a
                    b_1 = idx_b;
                    
                    % sarsa in
                    if rand_epsilon <= epsilon_1(fig_1)
                        % generate random a, assign it to a
                        rand_b = randi(4, 1, 1);
                        b_1 = rand_b;
                    end
                    
                    if b_1 == 1
                        if reward_1(i_1 - 1,j_1) ~= 0
                            q_l_new_1(i_1,j_1,4) = q_l_new_1(i_1,j_1,4) + alpha_1 * (reward_1(i_1,j_1) + gamma_1 * q_l_next_1(:,:,b_1) - q_l_new_1(i_1,j_1,4));
                        else
                            q_l_new_1(i_1,j_1,4) = q_l_new_1(i_1,j_1,4) + alpha_1 * (reward_1(i_1,j_1) + gamma_1 * max(q_l_next_1(:,:,:)) - q_l_new_1(i_1,j_1,4));
                        end
                    elseif b_1 == 2
                        if reward_1(i_1 + 1,j_1) ~= 0
                            q_l_new_1(i_1,j_1,4) = q_l_new_1(i_1,j_1,4) + alpha_1 * (reward_1(i_1,j_1) + gamma_1 * q_l_next_1(:,:,b_1) - q_l_new_1(i_1,j_1,4));
                        else
                            q_l_new_1(i_1,j_1,4) = q_l_new_1(i_1,j_1,4) + alpha_1 * (reward_1(i_1,j_1) + gamma_1 * max(q_l_next_1(:,:,:)) - q_l_new_1(i_1,j_1,4));
                        end
                    elseif b_1 == 3
                        if reward_1(i_1,j_1 + 1) ~= 0
                            q_l_new_1(i_1,j_1,4) = q_l_new_1(i_1,j_1,4) + alpha_1 * (reward_1(i_1,j_1) + gamma_1 * q_l_next_1(:,:,b_1) - q_l_new_1(i_1,j_1,4));
                        else
                            q_l_new_1(i_1,j_1,4) = q_l_new_1(i_1,j_1,4) + alpha_1 * (reward_1(i_1,j_1) + gamma_1 * max(q_l_next_1(:,:,:)) - q_l_new_1(i_1,j_1,4));
                        end
                    else
                        
                        if reward_1(i_1,j_1 - 1) ~= 0
                            q_l_new_1(i_1,j_1,4) = q_l_new_1(i_1,j_1,4) + alpha_1 * (reward_1(i_1,j_1) + gamma_1 * q_l_next_1(:,:,b_1) - q_l_new_1(i_1,j_1,4));
                        else
                            q_l_new_1(i_1,j_1,4) = q_l_new_1(i_1,j_1,4) + alpha_1 * (reward_1(i_1,j_1) + gamma_1 * max(q_l_next_1(:,:,:)) - q_l_new_1(i_1,j_1,4));
                        end
                    end
                end
            end
        end
        
        %         a_1 = b_1;
        
        
        if (i_1==2 && j_1==4) || n==tol_1
            break;
        end
        
    end
    dist_1 = [dist_1 sqrt(sum((max(q_l_new_1, [], 3) - q_ite).^2, "all"))];
    if dist_1(end) < 1e-8
        break;
    end
    
    semilogx(dist_1, 'linewidth', 1.5);
    % plot(dist,'linewidth',1);
    legend("\epsilon=0.1", "\epsilon=0.3", "\epsilon=0.5", "\epsilon=0.7", "\epsilon=0.9");
    str=['Difference between Q-learning and Q-iteration (\alpha=',num2str(alpha_1),')'];
    title(str);
    title(str);
    xlabel("Number of interaction steps (log)");
    ylabel("Difference in Norm-2");
    hold on;
    
end

t1=toc;













