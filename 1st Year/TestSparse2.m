function [correctness,error] = TestSparse2()
%testing a 4x3x3 vector matrix with exponents 1:3 and 7;
error='';
correctness=0;
try
    x=[1,2,3;1,2,3;1,2,3];
    vm(1,:,:)=[4,2,0;4,2,0;4,2,0];
    vm(2,:,:)=[9,7,5;3,1,-1;-3,-5,-7];
    vm(3,:,:)=[17,38,40;0,0,0;1,6,5];
    vm(4,:,:)=2*ones(3);
    a=vm(:,:,:);
    trueAns=[283488,566976,850464;279960,559920,839880;280284,560568,840852];
    candidateAns=Sparse([1:3,7],a,x);
    
    %the following test checks that the matrix outputted is of the right
    %dimensions;
    if size(candidateAns,1)~=3 || size(candidateAns,2)~=3 || size(candidateAns,3)~=1
        error='matrix outputted is not 3x3';
        return;
    end
    %the following tests for if x has multiplied the matrices the wrong way
    %round. e.g. instead of giving a(0)*x + a(1)*(x^2)..., an incorrect 
    %version of Sparse would give x*a(0) + (x^2)*a(1)...;
    if candidateAns==[560652,561864,561744;560652,561864,561744;560652,561864,561744]
        error='matrix multiplication carried out the wrong way round';
        return;
    end
    %the following tests for if the coefficients have been multiplied by
    %the exponents of x in reverse order e.g. instead of giving a(0)*x + 
    %a(1)*(x^2)..., an incorrect version of Sparse would give a(0)*(x^7) + 
    %a(1)*(x^3) + a(2)*(x^2) + a(3)*x;
    if candidateAns==[281268,562536,843804;280050,560100,840150;279474,558948,838422]
        error='coefficients multiplied in reverse order (a(1)*(x^7) + a(2)*(x^3) + a(3)*(x^2)...';
        return;
    end
    %the following tests for if the coefficients have been multiplied in
    %reverse order AND the matrices multiplied the wrong way round;
    if candidateAns==[1120092,560004,-306;1120092,560004,-306;1120092,560004,-306]
        error='multiplication carried out the wrong way round AND coefficients multiplied in reverse order';
        return;
    end
    %the following tests for if every power of x has mistakenly been raised
    %by 1 in the calculation e.g. instead of giving a(0)*x + a(1)*(x^2)...,
    %an incorrect version of Sparse would give a(0)*(x^2) + a(1)*(x^3)...;
    if candidateAns==[1700928,3401856,5102784;1679760,3359520,5039280;
                     1681704,3363408,5045112]
        error='every coefficient raised by 1 too many powers of x';
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
    
