

% Initial medians
m0 = ones(21,1);
m1 = ones(21,1);
a  = ones(21,1);

m = [m0, m1, a];

options = optimset('TolFun',2.0e+03,'TolX',2.0e+03);

m_trained = fminunc(@nmc_objectivefn, m, options);

disp("Trained Medians ---- ");
disp(m_trained);



% x0 = [0.25,-0.25];
% x = fminsearch(@testfn,x0);