function [apple_img, banana_img] = fileread()

% set path
path_apple = 'sival_apple_banana/apple/';
path_banana = 'sival_apple_banana/banana/';
apple_set = dir(strcat(path_apple,'*.jpg'));
banana_set = dir(strcat(path_banana,'*.jpg'));

% 4 classes share same number of objects
num = size(apple_set, 1);

apple_img = cell(num, 1);
banana_img = cell(num, 1);

for i = 1: num
   apple_img{i, 1} = imread(strcat(apple_set(i).folder, '/', apple_set(i).name));
   banana_img{i, 1} = imread(strcat(banana_set(i).folder, '/', banana_set(i).name));
end

end