function [dissimilarity_matrix] = dissimilarity(bags)

num_bags = length(bags);
dissimilarity_matrix = zeros(num_bags,num_bags);

% apply the Bag (dis)similarity in slide P35
% loop bags i,j and instances k,l
for i = 1:num_bags
    for j = 1: num_bags
        for k = 1:size(bags{i})
            for l = 1:size(bags{j})
                distance(k,l) = norm(bags{i}(k,:)-bags{j}(l,:),2);
            end
        end
        dissimilarity_matrix(i,j) = min(min(distance)); 
    end   
end

end