function data = data_generation_25classes_cfo(N,snr,c,scale)
data = [];
runs=1;
%various modulation orders
M1=2;                       %bpsk   
M2=4;                       %qpsk
M3=16;                      %16qam
M4=8;                       %8psk
M5=8;                       %8qam
Nsamp=1;
% no. of bits required to represent all the states of each modulation

k1=log2(M1);
k2=log2(M2);
k3=log2(M3);
k4=log2(M4);
k5=log2(M5);

%No. of 0s and 1s to be generated for each modulation for N symbols on the
%plot

n1=k1*N;
n2=k2*N;
n3=k3*N;
n4=k4*N;
n5=k5*N;

%two random complex nos used to define two random angles which are later
%used to change the signals to some arbitrary random phase

h11 =(1/sqrt(2))*(randn(1,1)+ 1j*randn(1,1));
h12 = (1/sqrt(2))*(randn(1,1)+ 1j*randn(1,1));

ff = 1:N;
cfo = exp(i*pi*c*ff);
theta1 = angle(h11);
theta2 = angle(h12);

% conversion of snr given in dB to number using snr = 10log10(h1)
h1_db= snr; %snr in dB
h1=10.^(h1_db/10);
h2=h1;
h2_db=10*log10(h2);
beta=0.25;
N=n1/k1;

%Defining the constellations without any noise

%Not used in the code further

%BPSK Constellation
Symbols11 = pskmod([0:M1-1],M1);
Symbols12 = pskmod([0:M1-1],M1);

%QPSK Constellation
Symbols21 = pskmod([0:M2-1],M2);
Symbols22 = pskmod([0:M2-1],M2);

% 8PSK Contellation
Symbols41 = pskmod([0:M4-1],M4);
Symbols42 = pskmod([0:M4-1],M4);

% 8QAM Constellation
Symbols51 = qammod([0:M5-1],M5,'UnitAveragePower',true);
Symbols52 = qammod([0:M5-1],M5,'UnitAveragePower',true);

% 16QAM Constellation
Symbols31 = qammod([0:M3-1],M3,'UnitAveragePower',true);
Symbols32 = qammod([0:M3-1],M3,'UnitAveragePower',true);


for j=1:length(h1) %doubt?
    
    for q=1:runs
        %Generating Data
        
        % same logic for all modulations
        %Making 10 signals 2 of each category to combine any 2 giving 25
        %classes
        
        %BPSK-1
        dataIn11=randi([0 1],n1,1);                               %taking n1 (i.e. no. of bits*N) values randomly chosen from 0 or 1(integer) 
        dataInMatrix11=reshape(dataIn11,length(dataIn11)/k1,k1);  %reshaping the vector into a matrix such that it forms a matrix (N x no. of bits) 
        dataSymbolsIn11=bi2de(dataInMatrix11);                    % clubing the rows to form decimal values as a result forming Nx1 vector
        ModData_bpsk1=pskmod(dataSymbolsIn11,M1);                 % mapping these values to the modulation map in real-imaginary plane
        
        %BPSK-2
        dataIn12=randi([0 1],n1,1);
        dataInMatrix12=reshape(dataIn12,length(dataIn12)/k1,k1);
        dataSymbolsIn12=bi2de(dataInMatrix12);
        ModData_bpsk2=pskmod(dataSymbolsIn12,M1);
        
        
        %QPSK-1
        dataIn22=randi([0 1],n2,1);
        dataInMatrix22=reshape(dataIn22,length(dataIn22)/k2,k2);
        dataSymbolsIn22=bi2de(dataInMatrix22);
        ModData_qpsk1=pskmod(dataSymbolsIn22,M2);
        
        %QPSK-2
        dataIn42=randi([0 1],n2,1);
        dataInMatrix42=reshape(dataIn42,length(dataIn42)/k2,k2);
        dataSymbolsIn42=bi2de(dataInMatrix42);
        ModData_qpsk2=pskmod(dataSymbolsIn42,M2);
        
        
        %8PSK-1
        dataIn71=randi([0 1],n4,1);
        dataInMatrix71=reshape(dataIn71,length(dataIn71)/k4,k4);
        dataSymbolsIn71=bi2de(dataInMatrix71);
        ModData_8psk1=pskmod(dataSymbolsIn71,M4);
        
        %8PSK-2
        dataIn72=randi([0 1],n4,1);
        dataInMatrix72=reshape(dataIn72,length(dataIn72)/k4,k4);
        dataSymbolsIn72=bi2de(dataInMatrix72);
        ModData_8psk2=pskmod(dataSymbolsIn72,M4);
        
        %8QAM-1
        dataIn81=randi([0 1],n5,1);
        dataInMatrix81=reshape(dataIn81,length(dataIn81)/k5,k5);
        dataSymbolsIn81=bi2de(dataInMatrix81);
        ModData_8qam1=qammod(dataSymbolsIn81,M5,'UnitAveragePower',true);   %'UnitAveragePower' is set to be true so that total power of the signal is 1
        
        %8QAM-2
        dataIn82=randi([0 1],n5,1);
        dataInMatrix82=reshape(dataIn82,length(dataIn82)/k5,k5);
        dataSymbolsIn82=bi2de(dataInMatrix82);
        ModData_8qam2=qammod(dataSymbolsIn82,M5,'UnitAveragePower',true);
        
        
        
        %16QAM-1
        dataIn32=randi([0 1],n3,1);
        dataInMatrix32=reshape(dataIn32,length(dataIn32)/k3,k3);
        dataSymbolsIn32=bi2de(dataInMatrix32);
        ModData_16qam1=qammod(dataSymbolsIn32,M3,'UnitAveragePower',true);
        
        %16QAM-2
        dataIn62=randi([0 1],n3,1);
        dataInMatrix62=reshape(dataIn62,length(dataIn62)/k3,k3);
        dataSymbolsIn62=bi2de(dataInMatrix62);
        ModData_16qam2=qammod(dataSymbolsIn62,M3,'UnitAveragePower',true);
        
        
        %combining the classes with k=2 and adding random phases to both
        %signals
        k = scale;
        t1 = k*ModData_bpsk1*exp(i*theta1).*cfo' + ModData_bpsk2*exp(i*theta2);
        t2 = k*ModData_bpsk1*exp(i*theta1).*cfo' + ModData_qpsk1*exp(i*theta2);
        t3 = k*ModData_bpsk1*exp(i*theta1).*cfo' + ModData_8psk1*exp(i*theta2);
        t4 = k*ModData_bpsk1*exp(i*theta1).*cfo' + ModData_8qam1*exp(i*theta2);
        t5 = k*ModData_bpsk1*exp(i*theta1).*cfo' + ModData_16qam1*exp(i*theta2);
        
        
        t6 = k*ModData_qpsk1*exp(i*theta1).*cfo' + ModData_bpsk1*exp(i*theta2);
        t7 = k*ModData_qpsk1*exp(i*theta1).*cfo' + ModData_qpsk2*exp(i*theta2);
        t8 = k*ModData_qpsk1*exp(i*theta1).*cfo' + ModData_8psk1*exp(i*theta2);
        t9 = k*ModData_qpsk1*exp(i*theta1).*cfo' + ModData_8qam1*exp(i*theta2);
        t10 = k*ModData_qpsk1*exp(i*theta1).*cfo' + ModData_16qam1*exp(i*theta2);
        
        t11 = k*ModData_8psk1*exp(i*theta1).*cfo' + ModData_bpsk1*exp(i*theta2);
        t12 = k*ModData_8psk1*exp(i*theta1).*cfo' + ModData_qpsk1*exp(i*theta2);
        t13 = k*ModData_8psk1*exp(i*theta1).*cfo' + ModData_8psk2*exp(i*theta2);
        t14 = k*ModData_8psk1*exp(i*theta1).*cfo' + ModData_8qam1*exp(i*theta2);
        t15 = k*ModData_8psk1*exp(i*theta1).*cfo' + ModData_16qam1*exp(i*theta2);
        
        
        t16 = k*ModData_8qam1*exp(i*theta1).*cfo' + ModData_bpsk1*exp(i*theta2);
        t17 = k*ModData_8qam1*exp(i*theta1).*cfo' + ModData_qpsk1*exp(i*theta2);
        t18 = k*ModData_8qam1*exp(i*theta1).*cfo' + ModData_8psk1*exp(i*theta2);
        t19 = k*ModData_8qam1*exp(i*theta1).*cfo' + ModData_8qam2*exp(i*theta2);
        t20 = k*ModData_8qam1*exp(i*theta1).*cfo' + ModData_16qam1*exp(i*theta2);
        
        
        t21 = k*ModData_16qam1*exp(i*theta1).*cfo' + ModData_bpsk1*exp(i*theta2);
        t22 = k*ModData_16qam1*exp(i*theta1).*cfo' + ModData_qpsk1*exp(i*theta2);
        t23 = k*ModData_16qam1*exp(i*theta1).*cfo' + ModData_8psk1*exp(i*theta2);
        t24 = k*ModData_16qam1*exp(i*theta1).*cfo' + ModData_8qam1*exp(i*theta2);
        t25 = k*ModData_16qam1*exp(i*theta1).*cfo' + ModData_16qam2*exp(i*theta2);
        
        %defining random noise
        
        noise1 =sqrt(1/2)*(randn(n1/k1,1)+1i*randn(n1/k1,1));
        noise2 =sqrt(1/2)*(randn(n1/k1,1)+1i*randn(n1/k1,1));
        noise3 =sqrt(1/2)*(randn(n1/k1,1)+1i*randn(n1/k1,1));
        noise4 =sqrt(1/2)*(randn(n1/k1,1)+1i*randn(n1/k1,1));
        noise5 =sqrt(1/2)*(randn(n1/k1,1)+1i*randn(n1/k1,1));
        noise6 =sqrt(1/2)*(randn(n1/k1,1)+1i*randn(n1/k1,1));
        noise7 =sqrt(1/2)*(randn(n1/k1,1)+1i*randn(n1/k1,1));
        noise8 =sqrt(1/2)*(randn(n1/k1,1)+1i*randn(n1/k1,1));
        noise9 =sqrt(1/2)*(randn(n1/k1,1)+1i*randn(n1/k1,1));
        noise10 =sqrt(1/2)*(randn(n1/k1,1)+1i*randn(n1/k1,1));
        noise11 =sqrt(1/2)*(randn(n1/k1,1)+1i*randn(n1/k1,1));
        noise12 =sqrt(1/2)*(randn(n1/k1,1)+1i*randn(n1/k1,1));
        noise13 =sqrt(1/2)*(randn(n1/k1,1)+1i*randn(n1/k1,1));
        noise14 =sqrt(1/2)*(randn(n1/k1,1)+1i*randn(n1/k1,1));
        noise15 =sqrt(1/2)*(randn(n1/k1,1)+1i*randn(n1/k1,1));
        noise16 =sqrt(1/2)*(randn(n1/k1,1)+1i*randn(n1/k1,1));
        noise17 =sqrt(1/2)*(randn(n1/k1,1)+1i*randn(n1/k1,1));
        noise18 =sqrt(1/2)*(randn(n1/k1,1)+1i*randn(n1/k1,1));
        noise19 =sqrt(1/2)*(randn(n1/k1,1)+1i*randn(n1/k1,1));
        noise20 =sqrt(1/2)*(randn(n1/k1,1)+1i*randn(n1/k1,1));
        noise21 =sqrt(1/2)*(randn(n1/k1,1)+1i*randn(n1/k1,1));
        noise22 =sqrt(1/2)*(randn(n1/k1,1)+1i*randn(n1/k1,1));
        noise23 =sqrt(1/2)*(randn(n1/k1,1)+1i*randn(n1/k1,1));
        noise24 =sqrt(1/2)*(randn(n1/k1,1)+1i*randn(n1/k1,1));
        noise25 =sqrt(1/2)*(randn(n1/k1,1)+1i*randn(n1/k1,1));
        
        %normalizing the power and then multiplying with sqrt(h1)i.e.
        %amplitude making the snr = h1
        
        y1 = sqrt(h1)*((t1)/sqrt(mean((abs(t1)).^2))) + noise1;
        y2 = sqrt(h1)*((t2)/sqrt(mean((abs(t2)).^2))) + noise2;
        y3 = sqrt(h1)*((t3)/sqrt(mean((abs(t3)).^2))) + noise3;
        y4 = sqrt(h1)*((t4)/sqrt(mean((abs(t4)).^2))) + noise4;
        y5 = sqrt(h1)*((t5)/sqrt(mean((abs(t5)).^2))) + noise5;
        y6 = sqrt(h1)*((t6)/sqrt(mean((abs(t6)).^2))) + noise6;
        y7 = sqrt(h1)*((t7)/sqrt(mean((abs(t7)).^2))) + noise7;
        y8 = sqrt(h1)*((t8)/sqrt(mean((abs(t8)).^2))) + noise8;
        y9 = sqrt(h1)*((t9)/sqrt(mean((abs(t9)).^2))) + noise9;
        y10 = sqrt(h1)*((t10)/sqrt(mean((abs(t10)).^2))) + noise10;
        y11 = sqrt(h1)*((t11)/sqrt(mean((abs(t11)).^2))) + noise11;
        y12 = sqrt(h1)*((t12)/sqrt(mean((abs(t12)).^2))) + noise12;
        y13 = sqrt(h1)*((t13)/sqrt(mean((abs(t13)).^2))) + noise13;
        y14 = sqrt(h1)*((t14)/sqrt(mean((abs(t14)).^2))) + noise14;
        y15 = sqrt(h1)*((t15)/sqrt(mean((abs(t15)).^2))) + noise15;
        y16 = sqrt(h1)*((t16)/sqrt(mean((abs(t16)).^2))) + noise16;
        y17 = sqrt(h1)*((t17)/sqrt(mean((abs(t17)).^2))) + noise17;
        y18 = sqrt(h1)*((t18)/sqrt(mean((abs(t18)).^2))) + noise18;
        y19 = sqrt(h1)*((t19)/sqrt(mean((abs(t19)).^2))) + noise19;
        y20 = sqrt(h1)*((t20)/sqrt(mean((abs(t20)).^2))) + noise20;
        y21 = sqrt(h1)*((t21)/sqrt(mean((abs(t21)).^2))) + noise21;
        y22 = sqrt(h1)*((t22)/sqrt(mean((abs(t22)).^2))) + noise22;
        y23 = sqrt(h1)*((t23)/sqrt(mean((abs(t23)).^2))) + noise23;
        y24 = sqrt(h1)*((t24)/sqrt(mean((abs(t24)).^2))) + noise24;
        y25 = sqrt(h1)*((t25)/sqrt(mean((abs(t25)).^2))) + noise25;
        
        %normalizing the signal again to make it of unit power
      
        y1 = y1/sqrt(mean((abs(y1)).^2));
        y2 = y2/sqrt(mean((abs(y2)).^2));
        y3 = y3/sqrt(mean((abs(y3)).^2));
        y4 = y4/sqrt(mean((abs(y4)).^2));
        y5 = y5/sqrt(mean((abs(y5)).^2));
        y6 = y6/sqrt(mean((abs(y6)).^2));
        y7 = y7/sqrt(mean((abs(y7)).^2));
        y8 = y8/sqrt(mean((abs(y8)).^2));
        y9 = y9/sqrt(mean((abs(y9)).^2));
        y10 = y10/sqrt(mean((abs(y10)).^2));
        y11 = y11/sqrt(mean((abs(y11)).^2));
        y12 = y12/sqrt(mean((abs(y12)).^2));
        y13 = y13/sqrt(mean((abs(y13)).^2));
        y14 = y14/sqrt(mean((abs(y14)).^2));
        y15 = y15/sqrt(mean((abs(y15)).^2));
        y16 = y16/sqrt(mean((abs(y16)).^2));
        y17 = y17/sqrt(mean((abs(y17)).^2));
        y18 = y18/sqrt(mean((abs(y18)).^2));
        y19 = y19/sqrt(mean((abs(y19)).^2));
        y20 = y20/sqrt(mean((abs(y20)).^2));
        y21 = y21/sqrt(mean((abs(y21)).^2));
        y22 = y22/sqrt(mean((abs(y22)).^2));
        y23 = y23/sqrt(mean((abs(y23)).^2));
        y24 = y24/sqrt(mean((abs(y24)).^2));
        y25 = y25/sqrt(mean((abs(y25)).^2));
        
    end
end

data = [y1, y2, y3, y4, y5, y6, y7, y8, y9, y10, y11, y12, y13, y14, y15, y16, y17, y18, y19, y20, y21, y22, y23, y24, y25];

end