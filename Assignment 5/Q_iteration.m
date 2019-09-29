load("maze.mat");
% initialisation
gamma = [0 0.1 0.5 0.9 1];
ite_num = 1000;
% isequal(a, b);
reward = maze;
q_new = zeros(9,7,4);
q_old = zeros(9,7,4);
ite_count = 0;
g=4;
reward(2,4) = 1;
% Q_iteartion
% for g = 1: 4
for ite = 1: ite_num
    for i = 1: 9
        for j = 1: 7
            % if it is wall, then skip
            if reward(i,j) == -1 || reward(i,j) == 1
                continue;
            else
                % up
                if reward(i - 1, j) ~= -1
                    q_new(i, j, 1) = reward(i - 1, j) + gamma(g) * max(q_old(i - 1, j, :));
                else
                    q_new(i, j, 1) = reward(i, j) + gamma(g) * max(q_old(i, j, :));
                end
                % down
                if reward(i + 1, j) ~= -1
                    q_new(i, j, 2) = reward(i + 1, j) + gamma(g) * max(q_old(i + 1, j, :));
                else
                    q_new(i, j, 2) = reward(i, j) + gamma(g) * max(q_old(i, j, :));
                end
                % right
                if reward(i, j + 1) ~= -1
                    q_new(i, j, 3) = reward(i, j + 1) + gamma(g) * max(q_old(i, j + 1, :));
                else
                    q_new(i, j, 3) = reward(i, j) + gamma(g) * max(q_old(i, j, :));
                end
                % left
                if reward(i, j - 1) ~= -1
                    q_new(i, j, 4) = reward(i, j - 1) + gamma(g) * max(q_old(i, j - 1, :));
                else
                    q_new(i, j, 4) = reward(i, j) + gamma(g) * max(q_old(i, j, :));
                end
            end
        end
    end
    
    if isequal(q_new, q_old)
        break;
    else
        q_old = q_new;
    end
    
    ite_count = ite_count + 1;
% end


% pick maximum value based on third dimension
q_ite = max(q_new, [], 3);
% draw
% subplot(2,2,g);
subaxis(1,4,g,'Spacing',0.025, 'Margin',0.035);
imagesc(q_ite);
str=['The optimal value function for \gamma = ',num2str(gamma(g))];
title(str);
colorbar;

[q_star, policy] = max(q_new, [], 3);


end













