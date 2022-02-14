function nmyexpt = MyExpt(A,n)
% MyExpt calculates A^n where A must be a real number or a square matrix of 
% real numbers, and n must be a positive integer (inc. 0)

if n ~= floor(n) % checks that n is an integer
    error = 'function cannot do decimal powers'
elseif n < 0 % checks that n is positive
    error = 'function cannot do negative powers'
elseif imag(n) ~= 0 % checks that n is real
    error = 'function cannot do complex powers'
    
elseif n == 0
    nmyexpt = eye(size(A));
elseif n == 2 * floor(n/2)
    nmyexpt = MyExpt(A*A,n/2);
elseif n == 2 * floor(n/2)+1
   nmyexpt = A * MyExpt(A*A,(n-1)/2);
   
else
    error = 'unknown error' % gives an error if none of these known
             % conditions are met
end
end

