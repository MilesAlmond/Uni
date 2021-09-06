function [correctness,error] = TestSimple4()
%testing a 2x2x3 matrix, which shouldn't work as Simple evaluates
%polynomials in a kxnxn array of matrices, and squaring a 2x3 matrix (x)
%is not possible;
error='';
correctness=0;
try
    x=[12,14,8;4,10,3];
    vm(1,:,:)=[7,4,5;2,6,7];
    vm(2,:,:)=[19,2,3;4,2,0];
    a=vm(:,:,:);
    candidateAns=Simple(a,x);
    correctness=0;
    error='test should give an error, but didnt. Incompatible matrix dimensions used.';
catch error
    correctness=1; %An incompatibility error was expected;
    error=error.message; %Taken from JHD's testMult posted on XX10190 Moodle;
end
end

