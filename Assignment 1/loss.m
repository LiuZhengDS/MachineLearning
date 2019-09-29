function l = loss(m_plus, m_minus, lambda, digits)
s = size(digits,1);
d_plus = [digits(1:s/2, :)];
d_minus = [digits(s/2+1:s, :)];
l_plus = 0;
l_minus = 0;
l_reg = 0;
l = 0;
% l is the sum of loss of positive class and negative class
% a = median(m_minus - m_plus);
a = median(m_minus - m_plus);
for i = 1: s/2
    for j = 1: 21
        l_plus = l_plus + abs(d_plus(i, j) - m_plus(j));
        l_minus = l_minus + abs(d_minus(i, j) - m_minus(j));
    end
end

l = l_plus + l_minus;
% out of sum of positive and negative class loss, add regularisation
for i = 1: 21
    l_reg = l_reg + abs(m_plus(i) - m_minus(i) + a);
end

l_reg = lambda * l_reg;
l = l + l_reg;
end