mylabel = importdata('labels.csv');
truelabel = importdata('truelabels.csv');
dif = mylabel - truelabel(:,end);
true_dif = abs(dif);
error = sum(true_dif)/length(dif);
24-24*error