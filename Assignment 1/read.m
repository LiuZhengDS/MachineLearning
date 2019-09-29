data = load('/Users/zhengliu/ml/Assignment 1/digits.txt','X');


    % Train set / Test set split-up
    rand_count = 1000 / 2;

    class_1 = data(1:10000, :);
    class_2 = data(10001:size(data,1), :);

    c1 = randperm(size(class_1, 1),rand_count);
    c2 = randperm(size(class_2, 1),rand_count);

    % ---  Train Set ---
    train_c1 = class_1(c1,:);
    train_c2 = class_2(c2,:);

    trainset = [train_c1; train_c2];

    % ---  Test Set ---
    test_c1 = class_1;
    test_c1(c1,:) = [];
    test_c2 = class_2;
    test_c2(c2,:) = [];

    testset = [test_c1; test_c2];

    save('train_data','trainset','testset');