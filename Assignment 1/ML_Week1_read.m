% NmC classifier implemertation %

f = fopen('digits.txt');
X = [];

while ~feof(f)
   
   temp_x = split(fgetl(f),",");
   X = [X temp_x];
   
end

% Data Make

y_1 = ones(1, 10000);
y_2 = ones(1, 10000);
y_2 = y_2 - 2;

X = str2double(X);
Y = [y_1 y_2];

save('digit_data','X');