function [correctness,error] = TestSparse3()
%testing a 4x4x4 vector matrix with exponents 1,2,4,5;
error='';
correctness=0;
try
    x=[1,2,1,2;2,3,2,3;2,1,2,1;5,7,8,9];
    vm(1,:,:)=7*eye(4)-ones(4);
    vm(2,:,:)=[11,14,0,6;69,40,23,1;1,1,1,1;8,6,4,2];
    vm(3,:,:)=[37,62,17,50;53,43,80,53;11,14,36,24;80,86,69,98];
    vm(4,:,:)=[0,0,7,7;5,0,6,0;12,15,51,0;8,0,0,8];
    a=vm(:,:,:);
    trueAns=[2924125,3768191,3884434,4408397;1814189,2338033,2410001,2735241;
             3816342,4918020,5069697,5753590;4396660,5665769,5840536,6628353];
    candidateAns=Sparse([1,2,4,5],a,x);
    
    %the following test checks that the matrix outputted is of the right
    %dimensions;
    if size(candidateAns,1)~=4 || size(candidateAns,2)~=4 || size(candidateAns,3)~=1
        error='matrix outputted is not 4x4';
        return;
    end
    %the following tests for if every power of x has mistakenly been
    %lowered by 1 in the calculation e.g. instead of giving a(0)*x + 
    %a(1)*(x^2)..., an incorrect version of Sparse would give a(0) + a(1)*x...;
    if candidateAns==[212306,273603,282049,320103;131719,169821,174904,198604;
                     277055,357117,368064,417785;319242,411381,424098,481292]
        error='every coefficient lowered by 1 power of x';
        return;
    end
    %the following tests for if every power of x has been lowered by 1 in
    %the calculation AND the matrices multiplied the wrong way round e.g.
    %instead of giving a(0)*x + a(1)*(x^2)..., an incorrect version of
    %Sparse would give a(0)+x*a(1)...;
    if candidateAns==[175039,132203,344468,137084;273245,206391,537727,214009;
                     119605,90338,235314,93689;784658,592776,1544238,614739]
        error='every coefficient lowered by 1 power of x AND matrix multiplication wrong way round';
        return;
    end
    %the following tests for if every power of x has been lowered by 1 in
    %the calculation AND the coefficients have been multiplied by the 
    %exponents of x in reverse order e.g.instead of giving a(0)*x +
    %a(1)*(x^2)..., an incorrect version of Sparse cwould give a(0)*(x^4) +
    %a(1)*(x^3)...;
    if candidateAns==[12600,16296,16771,19079;48363,62372,64300,72996;
                     -7794,-10061,-10320,-11786;87691,113034,116480,132240]
        error='every coefficient lowered by 1 power of x AND coefficients multiplied in reverse order';
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
        
       
