function f = nmc_objectivefn(x)

iter = 0;

f = 0;
lamda = 10;
class_median = zeros(21,1);

% Data Make - %%%%%

data = load('digit_data','X');
data = data.X;

for i = 1:size(data,2)

    if i <= 10000
        class_median = x(:,1);
    else
        class_median = x(:,2);
    end

    x_i = data(:,i);

    
    f = f + norm(x_i - class_median);

end


f = f + ( lamda * ( norm(x(:,1) - x(:,2) + x(:,3)) ) ); %(a -> scalar??)


disp('iterations cost');
disp(f);