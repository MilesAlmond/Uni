function polynomial = Faster(index,b,x)
% Faster uses the same inputs as Sparse but works by saving powers of x to 
% calculate higher powers faster. It evaluates a matrix polynomial of a 
% kxnxn array of k matrices. Works only with positive integers less than
% 100 (inc. 0) in the index, where x and the matrices in b must be square 
% matrices with the same dimensions as eachother

vm(:,:,:) = b;
length = size(index,2); %  defines the number of values in the index
coeffs = size(vm,1); % defines the number of coefficients
dimension1 = size(vm,2);
dimension2 = size(vm,3); % defines the dimensions of the coefficients

if isempty(index) % accounts for the zero polynomial
    polynomial = zeros(dimension1,dimension2);
elseif length~=coeffs
    error = 'number of values in index does not match number of coeffs'
elseif dimension2 ~= size(x,1) % tests for if the inner dimensions of the 
   % coefficients and x are equal (and therefore multiplicable)
    error = 'matrix dimensions do not agree'
elseif size(x,1) ~= size(x,2) % tests that x is an nxn matrix
    error = 'x is not a square matrix'
    
else
    polynomial = 0; % value of "polynomial" will be built on in a loop
    i = 0; % value of "i" will be built on in a loop
    global Saved
           Saved = NaN(size(x,1),size(x,2),100);
           %defines an empty global variable
    for j=1:length % works through each value in the index
        i = i + 1; % moves onto the next coefficient in the list
        polynomial = reshape(vm(i,:,:),[dimension1,dimension2])... 
                     * FasterExpt(x,index(j)) + polynomial; 
                     % coefficient is reshaped to a single matrix, 
                     % multiplied by the power in the index, then summed 
                     % onto the polynomial already calculated
    end
end
end

