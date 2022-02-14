function polynomial = Simple(a,x)
% Simple evaluates a matrix polynomial of a kxnxn array of k matrices
% in ascending integer powers of x, from 0 to k-1, where x and the matrices
% in a must be square matrices with the same dimensions as eachother

vm(:,:,:) = a;
dimension1 = size(vm,2);
dimension2 = size(vm,3); % defines the dimensions of the coefficients

if dimension2 ~= size(x,1) % tests for if the inner dimensions of the 
   % coefficients and x are equal (and therefore multiplicable)
    error = 'matrix dimensions do not agree'
elseif size(x,1) ~= size(x,2) % tests that x is an nxn matrix
    error = 'x is not a square matrix'
    
else
    coeffs = size(vm,1); % defines the number of coefficients
    polynomial = 0; % value of "polynomial" will be built on in a loop
    for i = 1:coeffs
        polynomial = reshape(vm(i,:,:),[dimension1,dimension2])...
                     * MyExpt(x,i-1) + polynomial;
                     % coefficient is reshaped to a single matrix, 
                     % multiplied by the power given, then summed 
                     % onto the polynomial already calculated
    end
end
end

