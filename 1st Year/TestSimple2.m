function [correctness,error] = TestSimple2()
%testing a 3x2x2 matrix;
error='';
correctness=0;
try
    x=[4,2;6,9];
    vm(1,:,:)=ones(2);
    vm(2,:,:)=eye(2)+3*ones(2);
    vm(3,:,:)=[9,4;2,7];
    a=vm(:,:,:);
    trueAns=[599,642;639,746];
    candidateAns=Simple(a,x);
    
    %the following test checks that the matrix outputted is of the right
    %dimensions;
    if size(candidateAns,1)~=2 || size(candidateAns,2)~=2 || size(candidateAns,3)~=1
       error='matrix outputted is not 2x2';
       return;
    end
    %the following tests for if x has multiplied the matrices the wrong way
    %round. e.g. giving a(0) + x*a(1) + (x^2)*a(2) instead of a(0) + a(1)*x
    %+ a(2)*(x^2);
    if candidateAns==[327,315;940,1018]
       error='matrix multiplication carried out the wrong way round';
       return;
    end
    %the following tests for basic errors, to find out if x has been 
    %multiplied by the wrong matrix or not multiplied by the correct matrix 
    %at all. e.g. instead of giving a(0) + a(1)*x + a(2)*(x^2), an incorrect 
    %version of Simple may give a(0)*x + a(1) + a(2)*(x^2);
    if candidateAns==[578,620;615,718]
       error='a(0) and a(1) are the wrong way round';
       return;
    end
    if candidateAns==[407,438;447,518]
       error='a(1) and a(2) are the wrong way round';
       return;
    end
    if candidateAns==[149,158;144,168]
       error='a(0) and a(2) are the wrong way round';
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

