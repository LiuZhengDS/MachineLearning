% PRLAPLACE  Laplacian distributed random numbers.
%    PRLAPLACE(N) is an N-by-N matrix with random entries, chosen from a
%    Laplacian distribution with mean zero and variance one.
%    PRLAPLACE(N,M) is an N-by-M matrix with random entries.
%    PRLAPLACE(N,M,MU,S) is an N-by-M matrix with random entries, chosen 
%    from a Laplacian distribution with mean MU and covariance matrix S.
%    MU should be an 1-by-M vector, S an M-by-M matrix.
%    LAPLACE with no arguments is a scalar whose value changes each time
%    it is referenced. 

function out = prlaplace (n, m, mu, S)

	if (nargin < 1), n  = 1;          end;
	if (nargin < 2), m  = n;          end;
	if (nargin < 3), mu = zeros(1,m); end;
  if (nargin < 4), S  = eye(m);     end;

	out = myexprnd(1,n,m); 

	% Convert exponential to Laplacian distributed data

	for i = 1:n
		for j = 1:m
			if (rand(1,1) > 0.5)
				out(i,j) = -out(i,j);
			end;
		end;
	end;

	% Remove covariance
	out = out * inv(sqrtm(cov(out)));

	% Add in desired covariance and mean
	out = out * sqrtm(S) + ones(n,1)*mu;

return


function r = exprnd(mu,m,n);
%EXPRND Random matrices from exponential distribution.
%   R = EXPRND(MU) returns a matrix of random numbers chosen   
%   from the exponential distribution with parameter MU.
%   The size of R is the size of MU.
%   Alternatively, R = EXPRND(MU,M,N) returns an M by N matrix. 
 
%   EXPRND uses a simple inversion method. See Devroye, page 392.

%   References:
%      [1]  L. Devroye, "Non-Uniform Random Variate Generation", 
%      Springer-Verlag, 1986.

%     Copyright 1993-2000 The MathWorks, Inc. 
%     $Revision: 1.1 $  $Date: 2005/07/26 06:33:03 $


if nargin <  1, 
    error('Requires at least one input argument.'); 
end

    
if nargin == 1
    [errorcode rows columns] = myrndcheck(1,1,mu);
end

if nargin == 2
    [errorcode rows columns] = myrndcheck(2,1,mu,m);
end

if nargin == 3
    [errorcode rows columns] = myrndcheck(3,1,mu,m,n);
end

if errorcode > 0
    error('Size information is inconsistent.');
end

%Initialize r to zero.
r = zeros(rows, columns);

u = rand(rows,columns);
r = - mu .* log(u);

% Return NaN if b is not positive.
if any(any(mu <= 0));
    tmp = NaN; 
    if prod(size(mu) == 1)
        r = tmp(ones(rows,columns));
    else
        k = find(mu <= 0);
        r(k) = tmp(ones(size(k)));
    end
end

return


function [errorcode, rows, columns] = rndcheck(nargs,nparms,arg1,arg2,arg3,arg4,arg5)
%RNDCHECK error checks the argument list for the random number generators.

%   B.A. Jones  1-22-93
%   Copyright 1993-2000 The MathWorks, Inc. 
%   $Revision: 1.1 $  $Date: 2005/07/26 06:33:03 $

sizeinfo = nargs - nparms;
errorcode = 0;

if nparms == 3
    [r1 c1] = size(arg1);
    [r2 c2] = size(arg2);
    [r3 c3] = size(arg3);
end

if nparms == 2
    [r1 c1] = size(arg1);
    [r2 c2] = size(arg2);
end 

if sizeinfo == 0        
    if nparms == 1
        [rows columns] = size(arg1);
    end
    
    if nparms == 2
        scalararg1 = (prod(size(arg1)) == 1);
        scalararg2 = (prod(size(arg2)) == 1);
        if ~scalararg1 & ~scalararg2
            if r1 ~= r2 | c1 ~= c2
                errorcode = 1;
                return;         
            end
        end
        if ~scalararg1
            [rows columns] = size(arg1);
        elseif ~scalararg2
            [rows columns] = size(arg2);
        else
            [rows columns] = size(arg1);
        end
    end
    
    if nparms == 3
        scalararg1 = (prod(size(arg1)) == 1);
        scalararg2 = (prod(size(arg2)) == 1);
        scalararg3 = (prod(size(arg3)) == 1);

        if ~scalararg1 & ~scalararg2
            if r1 ~= r2 | c1 ~= c2
                errorcode = 1;
                return;         
            end
        end

        if ~scalararg1 & ~scalararg3
            if r1 ~= r3 | c1 ~= c3
                errorcode = 1;
                return;                 
            end
        end

        if ~scalararg3 & ~scalararg2
            if r3 ~= r2 | c3 ~= c2
                errorcode = 1;
                return;         
            end
        end
            if ~scalararg1
                [rows columns] = size(arg1);
            elseif ~scalararg2
            [rows columns] = size(arg2);
            else
                [rows columns] = size(arg3);
            end
    end 
end

if sizeinfo == 1
    scalararg1 = (prod(size(arg1)) == 1);
    if nparms == 1
        if prod(size(arg2)) ~= 2
            errorcode = 2;
            return;
        end
        if  ~scalararg1 & arg2 ~= size(arg1)
            errorcode = 3;
            return;
        end
        if (arg2(1) < 0 | arg2(2) < 0 | arg2(1) ~= round(arg2(1)) | arg2(2) ~= round(arg2(2))),
            errorcode = 4;
            return;
        end 
        rows    = arg2(1);
        columns = arg2(2);
    end
    
    if nparms == 2
        if prod(size(arg3)) ~= 2
            errorcode = 2;
            return;
        end
        scalararg2 = (prod(size(arg2)) == 1);
        if ~scalararg1 & ~scalararg2
            if r1 ~= r2 | c1 ~= c2
                errorcode = 1;
                return;         
            end
        end
        if (arg3(1) < 0 | arg3(2) < 0 | arg3(1) ~= round(arg3(1)) | arg3(2) ~= round(arg3(2))),
            errorcode = 4;
            return;
        end 
        if ~scalararg1
            if any(arg3 ~= size(arg1))
                errorcode = 3;
                return;
            end
            [rows columns] = size(arg1);
        elseif ~scalararg2
            if any(arg3 ~= size(arg2))
                errorcode = 3;
                return;
            end
            [rows columns] = size(arg2);
        else
            rows    = arg3(1);
            columns = arg3(2);
        end
    end
    
    if nparms == 3
        if prod(size(arg4)) ~= 2
            errorcode = 2;
            return;
        end
        scalararg1 = (prod(size(arg1)) == 1);
        scalararg2 = (prod(size(arg2)) == 1);
        scalararg3 = (prod(size(arg3)) == 1);

        if (arg4(1) < 0 | arg4(2) < 0 | arg4(1) ~= round(arg4(1)) | arg4(2) ~= round(arg4(2))),
            errorcode = 4;
            return;
        end 

        if ~scalararg1 & ~scalararg2
            if r1 ~= r2 | c1 ~= c2
                errorcode = 1;
                return;         
            end
        end

        if ~scalararg1 & ~scalararg3
            if r1 ~= r3 | c1 ~= c3
                errorcode = 1;
                return;                 
            end
        end

        if ~scalararg3 & ~scalararg2
            if r3 ~= r2 | c3 ~= c2
                errorcode = 1;
                return;         
            end
        end
        if ~scalararg1
            if any(arg4 ~= size(arg1))
                errorcode = 3;
                return;
            end
            [rows columns] = size(arg1);
        elseif ~scalararg2
            if any(arg4 ~= size(arg2))
                errorcode = 3;
                return;
            end
            [rows columns] = size(arg2);
        elseif ~scalararg3
            if any(arg4 ~= size(arg3))
                errorcode = 3;
                return;
            end
            [rows columns] = size(arg3);
        else
            rows    = arg4(1);
            columns = arg4(2);
        end
    end 
end

if sizeinfo == 2
    if nparms == 1
        scalararg1 = (prod(size(arg1)) == 1);
        if ~scalararg1
            [rows columns] = size(arg1);
            if rows ~= arg2 | columns ~= arg3 
                errorcode = 3;
                return;
            end
        end
    if (arg2 < 0 | arg3 < 0 | arg2 ~= round(arg2) | arg3 ~= round(arg3)),
        errorcode = 4;
        return;
    end 
        rows = arg2;
        columns = arg3;
    end
    
    if nparms == 2
        scalararg1 = (prod(size(arg1)) == 1);
        scalararg2 = (prod(size(arg2)) == 1);
        if ~scalararg1 & ~scalararg2
            if r1 ~= r2 | c1 ~= c2
                errorcode = 1;
                return;         
            end
        end
        if ~scalararg1
            [rows columns] = size(arg1);
            if rows ~= arg3 | columns ~= arg4 
                errorcode = 3;
                return;
            end     
        elseif ~scalararg2
            [rows columns] = size(arg2);
            if rows ~= arg3 | columns ~= arg4 
                errorcode = 3;
                return;
            end     
        else
            if (arg3 < 0 | arg4 < 0 | arg3 ~= round(arg3) | arg4 ~= round(arg4)),
                errorcode = 4;
                return;
            end 
            rows = arg3;
            columns = arg4;
        end
    end
    
    if nparms == 3
        scalararg1 = (prod(size(arg1)) == 1);
        scalararg2 = (prod(size(arg2)) == 1);
        scalararg3 = (prod(size(arg3)) == 1);

        if ~scalararg1 & ~scalararg2
            if r1 ~= r2 | c1 ~= c2
                errorcode = 1;
                return;         
            end
        end

        if ~scalararg1 & ~scalararg3
            if r1 ~= r3 | c1 ~= c3
                errorcode = 1;
                return;                 
            end
        end

        if ~scalararg3 & ~scalararg2
            if r3 ~= r2 | c3 ~= c2
                errorcode = 1;
                return;         
            end
        end
        
        if ~scalararg1
            [rows columns] = size(arg1);
            if rows ~= arg4 | columns ~= arg5 
                errorcode = 3;
                return;
            end     
        elseif ~scalararg2
            [rows columns] = size(arg2);
            if rows ~= arg4 | columns ~= arg5 
                errorcode = 3;
                return;
            end
        elseif ~scalararg3
            [rows columns] = size(arg3);
            if rows ~= arg4 | columns ~= arg5 
                errorcode = 3;
                return;
            end     
        else
            if (arg4 < 0 | arg5 < 0 | arg4 ~= round(arg4) | arg5 ~= round(arg5)),
                errorcode = 4;
                return;
            end 
            rows    = arg4;
            columns = arg5;
        end
    end 
end
