function [correctness,error] = TestSimple1()
%testing a 2x3x3 vector matrix;
error= '';
correctness=0;
try
    x=[4,2,6;9,1,3;5,2,7];
    vm(1,:,:)=5*ones(3);
    vm(2,:,:)=(eye(3)+7*ones(3));
    a=vm(:,:,:);
    trueAns=[135,42,123;140,41,120;136,42,124];
    candidateAns=Simple(a,x);
    
    %the following test checks that the matrix outputted is of the right
    %dimensions;
    if size(candidateAns,1)~=3 || size(candidateAns,2)~=3 || size(candidateAns,3)~=1
       error='matrix outputted is not 3x3';
       return;
    end
    %the following tests for if x has multiplied the matrices the wrong way
    %round. e.g. giving a(0) + x*a(1) instead of a(0) + a(1)*x;
    if candidateAns==[93,91,95;105,97,99;108,105,110]
       error='matrix multiplication carried out the wrong way round';
       return;
    end
    %the following tests for the basic error of x being multiplied by the
    %wrong matrix or not being multiplied by the correct matrix at all. 
    %e.g. instead of giving a(0) + a(1)*x, an incorrect version of Simple 
    %may give a(0)*x + a(1);
    if candidateAns==[98,32,87;97,33,87;97,32,88]
       error='a(0) and a(1) are the wrong way round';
       return;
    end
    %the following tests if the answer is wrong and there are no obvious
    %reasons why;
    accuracy=abs(trueAns-candidateAns);
    if accuracy > 10*eps
       error='matrix outputted of different value to correct answer';
       return;
    end
    correctness=1;
catch error
    error=error.message; %Taken from JHD's testMult posted on XX10190 Moodle;
end
end

