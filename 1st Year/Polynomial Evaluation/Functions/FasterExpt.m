function nfasterexpt = FasterExpt(A,n)
% FasterExpt calculates A^n within the "Faster" function where A must be a
% real number or a square matrix of real numbers, and n must be a positive 
% integer (inc. 0)

global Saved
       Saved(:,:,1) = eye(size(A));
       % calls the global variable defined in Faster and stores the value 
       % of A^0. Note: Saved(:,:,n+1) stores A^n to prevent the undefined 
       % Saved(:,:,0) being called
       
if n ~= floor(n) % checks that n is an integer
    error = 'function cannot do decimal powers'
elseif n < 0 % checks that n is positive
    error = 'function cannot do negative powers'
elseif imag(n) ~= 0 % checks that n is real
    error = 'function cannot do complex powers'
    
elseif ~isnan(Saved(1,1,n+1)) % checks if power of x has already been saved
    nfasterexpt = Saved(:,:,n+1);
elseif n == 2 * floor(n/2) && ~isnan(Saved(1,1,(n/2)+1))
    % checks if n is even AND there is a stored value of x^(n/2)
    nfasterexpt = Saved(:,:,(n/2)+1) * Saved(:,:,(n/2)+1);
    % uses stored value of x^(n/2) to calculate x^n
    Saved(:,:,n+1) = nfasterexpt; % stores value of x^n
elseif n == 2 * floor(n/2)+1 && ~isnan(Saved(1,1,floor(n/2)+1))
    % checks if n is odd AND there is a stored value of x^(n/2)
    nfasterexpt = A * Saved(:,:,floor(n/2)+1) * Saved(:,:,floor(n/2)+1);
    Saved(:,:,n+1) = nfasterexpt;
    % uses stored value of x^(floor(n/2)) to calculate x^n
elseif n == 2 * floor(n/2) % checks if n is even
   nfasterexpt=FasterExpt(A,floor(n/2))*FasterExpt(A,floor(n/2));
                % calculates A^n by computing (A^(n/2))^2
elseif n == 2 * floor(n/2)+1 % checks if n is odd
   nfasterexpt = A * FasterExpt(A,floor(n/2)) * FasterExpt(A,floor(n/2));
                % calculates A^n by computing A*(A^(floor(n/2))^2
                
else
    error = 'unknown error' % gives an error if none of these conditions 
            % are met
end
end

