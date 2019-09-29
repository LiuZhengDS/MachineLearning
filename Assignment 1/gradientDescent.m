function [md_plus, md_minus, a] = gradientDescent(m_plus, m_minus, lambda, alpha, digits)
% initialisation
s = size(digits,1);
a = median(m_minus - m_plus);
d_plus = [digits(1:s/2, :)];
d_minus = [digits(s/2+1: s, :)];
for i = 1: 21
    for j = 1:s/2
        if d_plus(j, i) < m_plus(i)
            m_plus(i) = m_plus(i) - 2 * alpha/s;   
        elseif d_plus(j, i) > m_plus(i)
            m_plus(i) = m_plus(i) + 2 * alpha/s;
        else % d_plus(j, i) == m_plus(1, i)
            m_plus(i) = m_plus(i);
        end
        
        if d_minus(j, i) < m_minus(i)
            m_minus(i) = m_minus(i) - 2 * alpha/s;
        elseif d_minus(j, i) > m_minus(i)
            m_minus(i) = m_minus(i) + 2 * alpha/s;
        else % d_minus(j, i) == m_minus(i)
            m_minus(i) = m_minus(i);
        end
    end
    
    if m_plus(i) < (m_minus(i) - a)
        m_plus(i) = m_plus(i) + alpha * lambda;
    elseif m_plus(i) > (m_minus(i) - a)
        m_plus(i) = m_plus(i) - alpha * lambda;
    else
        m_plus(i) = m_plus(i);
    end
    
    if m_minus(i) < (m_plus(i) + a)
        m_minus(i) = m_minus(i) - alpha * lambda;
    elseif m_minus(i) < (m_plus(i) + a)
        m_minus(i) = m_minus(i) + alpha * lambda;
    else
        m_minus(i) = m_minus(i);
    end
    
    
end
md_plus = m_plus;
md_minus = m_minus;
a = median(m_minus - m_plus);
end