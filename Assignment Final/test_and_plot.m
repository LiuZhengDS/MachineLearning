predict_label_final = predict(ens, test_data);
csvwrite('label_version4.csv',predict_label_final);

%% 

l = importdata('labels.csv');
l_my = importdata('label_version4.csv');


%% label compare

dif = l - l_my;
num_dif = sum(abs(dif));
perc = num_dif / length(l);


%%
plt = [accuracy_matrix loss_matrix];
%%
plt = normalize(plt);
%%
scatterplot(plt);
% xlim([0 1])
% ylim([0 1])
hold on;

x = -3:1/100:3;
y = -0.9*x;
plot(x,y);
ylim([-2.5,2.5]);
xlabel('Accuracy');
ylabel('Loss');
