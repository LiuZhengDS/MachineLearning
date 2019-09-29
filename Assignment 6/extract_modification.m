% This function segments image using Mean-Shift algorithm,
% computes target features for each certain image,
% and returns the resulting features in a small data matrix

function [ResultFeature, imLabel] = extract_modification(image,width)

image = double(image);
% calculate mean-shift value (matrix)
imLabel = im_meanshift(image,width);
% initialise feature cell
% ResultFeature = [];

% find the number of segments in image
num_ins = max(max(imLabel));
% initialise feature matrix for output cell
ResultFeature = zeros(num_ins,10);

for i = 1:num_ins
    % the following are the features
    r = sum(sum(image(:,:,1).*(imLabel==i)))/sum(sum(imLabel==i));
    g = sum(sum(image(:,:,2).*(imLabel==i)))/sum(sum(imLabel==i));
    b = sum(sum(image(:,:,3).*(imLabel==i)))/sum(sum(imLabel==i));
    ave = (r + g + b) / 3;
    r_max = max(max(image(:,:,1) .* (imLabel==i)));
    g_max = max(max(image(:,:,2) .* (imLabel==i)));
    b_max = max(max(image(:,:,3) .* (imLabel==i)));
    r_min = min(min(image(:,:,1) .* (imLabel==i)));
    g_min = min(min(image(:,:,2) .* (imLabel==i)));
    b_min = min(min(image(:,:,3) .* (imLabel==i)));
    % store and return
    ResultFeature(i,:) = [r,g,b,ave,r_max,g_max,b_max,r_min,g_min,b_min];
end

end
