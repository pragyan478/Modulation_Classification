function data = data_generation_25classes_cfo(N,snr,c,scale,off)
data = [];
runs=1;
% c is cfo
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

%timing offset

beta=0.25;
sps=16;%Samples per symbol
span=20;
Offset1=0; 
Offset2=off;

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

theta1 = angle(h11);
theta2 = angle(h12);

% conversion of snr given in dB to number using snr = 10log10(h1)
h1_db= snr; %snr in dB
h1=10.^(h1_db/10);
h2=h1;
h2_db=10*log10(h2);
beta=0.35;
N=n1/k1;

%Defining the constellations without any noise


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
        dataIn11=randi([0 1],n1,1);                               
        dataInMatrix11=reshape(dataIn11,length(dataIn11)/k1,k1);   
        dataSymbolsIn11=bi2de(dataInMatrix11);                    
        ModData_bpsk1=pskmod(dataSymbolsIn11,M1);                 
        
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
        %length(ModData_8psk2)
        %8QAM-1
        dataIn81=randi([0 1],n5,1);
        dataInMatrix81=reshape(dataIn81,length(dataIn81)/k5,k5);
        dataSymbolsIn81=bi2de(dataInMatrix81);
        
        symbolsManual = [1+1j 1-1j -1-1j -1+1j 1+sqrt(3) -1-sqrt(3) 1j*(1+sqrt(3)) -1j*(1+sqrt(3))];
        ModData_8qam1=symbolsManual(dataSymbolsIn81+1);   
        ModData_8qam1 = ModData_8qam1/sqrt(mean((abs(ModData_8qam1)).^2));
        %length(ModData_8qam1)
        %8QAM-2
        dataIn82=randi([0 1],n5,1);
        dataInMatrix82=reshape(dataIn82,length(dataIn82)/k5,k5);
        dataSymbolsIn82=bi2de(dataInMatrix82);
        ModData_8qam2=symbolsManual(dataSymbolsIn82+1);
        ModData_8qam2 = ModData_8qam2/sqrt(mean((abs(ModData_8qam2)).^2));
        
        
        %scatterplot(ModData_8qam2);
        
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
        
        
        %timing offset
        
        %filters
        [rrcFilter,t] = srrcFunction(beta,sps,span);
        [rrcFilterShifted1,t2,filtDelay] = srrcFunctionShifted(beta,sps,span,Offset1);
        [rrcFilterShifted2,t2,filtDelay] = srrcFunctionShifted(beta,sps,span,Offset2);
        
    
        RCFilter=conv(rrcFilter,rrcFilter);
        RCFilter2=conv(rrcFilterShifted2,rrcFilter);
        RCFilter1=conv(rrcFilterShifted1,rrcFilter);
        
        %BPSK-BPSK
        qwe2 = upfirdn(ModData_bpsk2, rrcFilterShifted2,sps);
        qwe1 = upfirdn(ModData_bpsk1, rrcFilterShifted1,sps);
        
        qwe2=qwe2(1:end-2*Offset2);
        qwe1=qwe1(1:end-2*Offset1);%This will keep the length of the signal constant even
%         if offset changes
        
%         len = min(length(qwe1),length(qwe2)); Not needed if we add above
%         two lines.
        
        cfo = [];
        for ff =1:(length(qwe1))
            cfo = [cfo exp(1i*pi*c*(fix(ff/sps)+1))];
        end
        
        qwe = scale.*qwe1*exp(1i*theta1).*cfo' + qwe2*exp(1i*theta2);
        t1 = upfirdn(qwe,rrcFilter,1,sps);
        
        
        %QPSK-QPSK
    
        qwe2 = upfirdn(ModData_qpsk2, rrcFilterShifted2,sps);
        qwe1 = upfirdn(ModData_qpsk1, rrcFilterShifted1,sps);
        %len = min(length(qwe1),length(qwe2));
        qwe2=qwe2(1:end-2*Offset2);
        qwe1=qwe1(1:end-2*Offset1);
        qwe = scale.*qwe1*exp(1i*theta1).*cfo' + qwe2*exp(1i*theta2);
        t2 = upfirdn(qwe,rrcFilter,1,sps);
        
        
        %8PSK-8PSK
        
        qwe2 = upfirdn(ModData_8psk2, rrcFilterShifted2,sps);
        qwe1 = upfirdn(ModData_8psk1, rrcFilterShifted1,sps);
      
       %len = min(length(qwe1),length(qwe2));
        qwe2=qwe2(1:end-2*Offset2);
        qwe1=qwe1(1:end-2*Offset1);
       qwe = scale.*qwe1*exp(1i*theta1).*cfo' + qwe2*exp(1i*theta2);
        
        t3 = upfirdn(qwe,rrcFilter,1,sps);
       
        
        %8QAM-8QAM
        
        
        
        
        %16QAM-16QAM
        
        qwe2 = upfirdn(ModData_16qam2, rrcFilterShifted2,sps);
        qwe1 = upfirdn(ModData_16qam1, rrcFilterShifted1,sps);
        %len = min(length(qwe1),length(qwe2));
        qwe2=qwe2(1:end-2*Offset2);
        qwe1=qwe1(1:end-2*Offset1);
        
        qwe = scale.*qwe1*exp(1i*theta1).*cfo' + qwe2*exp(1i*theta2);

        t5 = upfirdn(qwe,rrcFilter,1,sps);
        
        %adding noise
        
        sigtonoise = snr;
        snr = sigtonoise + 10*log10(k1)- 10*log10(sps);
        y11=awgn(t1,snr,'measured');
        y1 = y11(21:end-20);
        snr = sigtonoise + 10*log10(k2)- 10*log10(sps);
        y22=awgn(t2,snr,'measured');
        y2 = y22(21:end-20);
        snr = sigtonoise + 10*log10(k4)- 10*log10(sps);
        y33=awgn(t3,snr,'measured');
        y3 = y33(21:end-20);
        snr = sigtonoise + 10*log10(k3)- 10*log10(sps);
        y55=awgn(t5,snr,'measured');
        y5 = y55(21:end-20);
        
        

        
        %normalizing the signal again to make it of unit power
      
        y1 = y1/sqrt(mean((abs(y1)).^2));
        %length(y1)
        y2 = y2/sqrt(mean((abs(y2)).^2));
        %length(y2)
        y3 = y3/sqrt(mean((abs(y3)).^2));
        %length(y3)
        y5 = y5/sqrt(mean((abs(y5)).^2));
        %length(y5)
    end
end

data = [y1, y2, y3, y5];

end