% This function segments image using Mean-Shift algorithm,
% computes the average red, green and blue color per segment,
% and returns the resulting features in a small data matrix

function [ResultingFeatures, im] = extractinstances(image, width)

im = im_meanshift(image, width);
% plot the segments to find the width parameter
% imshow(im,[]);

FeatSize = size(unique(im),1);

% 3 for r,g,b
ResultingFeatures = zeros(FeatSize, 3);

% compute mean for each segment
SegCell = cell(0);
SegIndex = [];
SegNum = [];
Img = im2double(image);

for i = 1: size(im, 1)
    for j = 1:size(im, 2)
        if ~ismember(im(i,j),SegIndex)
            SegIndex = [SegIndex im(i,j)];
            SegNum = [SegNum 1];
            SegCell{size(SegCell,2)+1} = reshape(Img(i,j,:),1,3);
        else
            idx = find(SegIndex == im(i,j));
            SegCell{idx} = SegCell{idx} + reshape(Img(i,j,:),1,3);
            SegNum(idx) = SegNum(idx) + 1;
        end
    end
end

% return the resulting_features matrix
for i = 1:FeatSize
    SegCell{i} = SegCell{i}./SegNum(i);
    % rgb
    for j = 1:3
        ResultingFeatures(i,j) = SegCell{i}(1,j);
    end
end

end