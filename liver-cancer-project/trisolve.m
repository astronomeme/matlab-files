
function [x] = trisolve(A,r) 
% This function solves the tridiagonal set of equations 
%  
%   / b(1) c(1)                     \  / x(1) \    / r(1) \
%   | a(2) b(2) c(2)                |  | x(2) |    | r(2) | 
%   |      a(3) b(3)  c(3)          |  | x(3) |    | r(3) | 
%   |           ...                 |  | ...  | =  |      |
%   |          a(N-1) b(N-1) c(N-1) |  |x(N-1)|    |r(N-1)| 
%   \                 a(N)   b(N)   /  \ x(N) /    \ r(N) / 
%  
% The entire matrix is provided, the appropriate diagonals are
% extracted using the MatLab diag command
N = length(A);  
b = diag(A);
a = [0];
a = [a;diag(A,-1)];
c = diag(A,1);
c = [c;0];
if (b(1) == 0), error('Zero diagonal element in TRISOLVE');  end 
beta(1) = b(1); 
rho(1)  = r(1); 
for j=2:N 
    beta(j) = b(j) - a(j) *  c (j-1) / beta(j-1); 
    rho(j)  = r(j) - a(j) * rho(j-1) / beta(j-1); 
    if (b(j) == 0) 
        error('Zero diagonal element in TRISOLVE'); 
    end 
end 
% Now, for the back substitution... 
x(N) = rho(N) / beta(N); 
for j = 1:N-1 
    x(N-j) = ( rho(N-j)-c(N-j)*x(N-j+1) )/beta(N-j); 
end 
