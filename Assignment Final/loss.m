% generate one hot coding

col = size(train_origin, 1);
ohc_7 = zeros(col, numel(unique(train_origin(:,7))));
ohc_8 = zeros(col, numel(unique(train_origin(:,8))));
ohc_9 = zeros(col, numel(unique(train_origin(:,9))));
ohc_10 = zeros(col, numel(unique(train_origin(:,10))));
ohc_11 = zeros(col, numel(unique(train_origin(:,11))));
ohc_12 = zeros(col, numel(unique(train_origin(:,12))));
ohc_13 = zeros(col, numel(unique(train_origin(:,13))));

for i = 1:size(ohc_7, 1)

        ohc_7(i,train_origin(i,7))=1;

end

for i = 1:size(ohc_8, 1)

        ohc_8(i,train_origin(i,8))=1;

end

for i = 1:size(ohc_9, 1)

        ohc_9(i,train_origin(i,9))=1;

end

for i = 1:size(ohc_10, 1)

        ohc_10(i,train_origin(i,10))=1;

end

for i = 1:size(ohc_11, 1)

        ohc_11(i,train_origin(i,11))=1;

end

for i = 1:size(ohc_12, 1)

        ohc_12(i,train_origin(i,12))=1;

end

for i = 1:size(ohc_13, 1)

        ohc_13(i,train_origin(i,13))=1;

end

train_origin = [train_origin(:, 1:6) ohc_7 ohc_8 ohc_9 ohc_10 ohc_11 ohc_12 ohc_13];





