function [correctness,error] = TestSparse1()
%testing a 2x2x2 vector matrix with exponents 2 and 4;
error='';
correctness=0;
try
    x=[2,4;6,8];
    vm(1,:,:)=7*ones(2);
    vm(2,:,:)=[19,2;78,5]; %vm's 1,2,4 all equal 0;
    a=vm(:,:,:);
    trueAns=[75032,109344;283768,413536];
    candidateAns=Sparse([2,4],a,x);
    
    %the following test checks that the matrix outputted is of the right
    %dimensions;
    if size(candidateAns,1)~=2 || size(candidateAns,2)~=2 || size(candidateAns,3)~=1
        error='matrix outputted is not 2x2';
        return;
    end
    %the following tests for if x has multiplied the matrices the wrong way
    %round. e.g. giving (x^2)*a(0) + (x^4)*a(1) instead of a(0)*(x^2) + a(1)*(x^4);
    if candidateAns==[422892,30044;924508,65676]
        error='matrix multiplication carried out the wrong way round';
        return;
    end
    %the following tests for the basic error of x being multiplied by the
    %wrong matrix or not being multiplied by the correct matrix at all. 
    %e.g. instead of giving a(0)*(x^2) + a(1)*(x^4), an incorrect version of Sparse 
    %may give a(0)*(x^4) + a(1)*(x^2);
    if candidateAns==[71660,104424;73492,107048]
        error='a(0) and a(1) are the wrong way round';
        return;
    end
    %the following tests if both the multiplaction has been carried out the
    %wrong way round AND the coefficients have been swapped. e.g. giving 
    %(x^4)*a(0) + (x^2)*a(1) instead of a(0)*(x^2) + a(1)*(x^4);
    if candidateAns==[58420,55024;127732,120288]
        error='multiplication carried out the wrong way round AND a(0) and a(1) are the wrong way round';
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
        
    