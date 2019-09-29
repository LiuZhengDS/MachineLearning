function [error_rate, esl] = lrc_test(test_data, beta)
% error rate
total_num = size(test_data, 1);
test_target = beta' .* test_data(:, 1:3);
before_sign = sum(test_target, 2);
sign_result = sign(before_sign);
error_num = sum(abs(test_data(:, 4) - sign_result))/2;
error_rate = error_num / total_num;

% expected square loss

esl = 1/total_num * sum((before_sign - test_data(:, 4)).^2);
end