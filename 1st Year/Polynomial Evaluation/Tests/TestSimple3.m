function [correctness,error] = TestSimple3()
%testing a 4x4x4 matrix;
error='';
correctness=0;
try
    x=[1.4,1.7,1.8,1.1;
       1.5,1.1,1.8,1.2;
       1.5,1.8,1.8,1.8;
       1.9,1.1,1.8,1.5];
    vm(1,:,:)=((2*eye(4))^2+ones(4));
    vm(2,:,:)=ones(4);
    vm(3,:,:)=[0.1,0.2,0.3,0.4;0.5,0.6,0.7,0.8;,0.9,1.0,1.1,1.2;1.3,1.4,1.5,1.6];
    vm(4,:,:)=(3*ones(4)-[0.1,0.2,0.3,0.4;0.5,0.6,0.7,0.8;,0.9,1.0,1.1,1.2;1.3,1.4,1.5,1.6]);
    a=vm(:,:,:);
    trueAns=[686.1170,632.7320,783.9480,616.9480;
             600.7640,561.2990,690.4340,543.3770;
             519.4120,481.8660,600.9210,469.8050;
             438.0590,406.4340,503.4070,400.2340]; %rounded to the nearest 3 d.p
    candidateAns=round(Simple(a,x),3);
    
    %the following test checks that the matrix outputted is of the right
    %dimensions;
    if size(candidateAns,1)~=4 || size(candidateAns,2)~=4 || size(candidateAns,3)~=1
       error='matrix outputted is not 4x4';
       return;
    end
    %the following tests for if x has multiplied the matrices the wrong way
    %round. e.g. giving a(0) + x*a(1) + (x^2)*a(2) + (x^3)*a(3) instead of
    %a(0) + a(1)*x + a(2)*(x^2) + a(3)*(x^3);
    if candidateAns==[572.2720,548.7590,529.2460,509.7330;
                      535.5040,521.1200,498.7350,480.3500;
                      653.2560,630.8150,612.3750,585.9350;
                      600.6920,580.0620,559.4330,542.8040];
       error='matrix multiplication carried out the wrong way round';
       return;
    end
    %the following tests for basic errors, to find out if x has been 
    %multiplied by the wrong matrix or not multiplied by the correct matrix 
    %at all. e.g. instead of giving a(0) + a(1)*x + a(2)*(x^2), an incorrect 
    %version of Simple may give a(0)*x + a(1)*(x^3) + a(2)*(x^2) + a(3);
    if candidateAns==[687.7170,639.5320,791.1480,621.3480;
                      606.7640,561.6990,697.6340,548.1770;
                      525.4120,489.0660,604.1210,477.0050;
                      445.6590,410.8340,510.6070,402.2340];
       error='a(0) and a(1) are the wrong way round';
       return;
    end
    if candidateAns==[494.7390,458.9210,568.0260,447.4520;
                      496.5750,460.2050,570.1460,448.8280;
                      559.8070,519.9330,643.0420,506.2680;
                      553.5350,513.4010,635.9460,500.3640];
       error='a(0) and a(3) are the wrong way round';
       return;
    end
    if candidateAns==[179.4860,163.0140,201.6440,158.8160;
                      256.8390,242.4470,295.1580,232.3870;
                      338.1910,313.8800,392.6710,305.9590;
                      419.5440,389.3130,482.1850,383.5300];
       error='a(2) and a(3) are the wrong way round';
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
     
   
