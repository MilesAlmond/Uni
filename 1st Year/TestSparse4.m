function [correctness,error] = TestSparse4()
%testing a 2x3x2 matrix with exponents 3 and 5, which shouldn't work as Sparse evaluates
%polynomials in a kxnxn array of matrices, and squaring a 3x2 matrix (x)
%is not possible;
error='';
correctness=0;
try
    x=[38,1;7,11;9,11];
    vm(1,:,:)=[2,5;8,3;3,2];
    vm(2,:,:)=[9,7;30,10;19,99];
    a=vm(:,:,:);
    candidateAns=Sparse([3,5],a,x);
    correctness=0;
    error='test should give an error, but didnt. Incompatible matrix dimensions used.';
catch error
    correctness=1; %An incompatibility error was expected;
    error=error.message; %Taken from JHD's testMult posted on XX10190 Moodle;
end
end
   
