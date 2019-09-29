%%

[training_in, testing_in] = split(AppleFeat,BananaFeat);


[train_dissimilarities] = dissimilarity(training_in);
[test_dissimilarities] = dissimilarity(testing_in);

% make prdatdaset

training_data = prdataset();
testing_set = prdataset();