%
%%psk
clc;
clear all;
runs=1;
M=2;
k=log2(M);
n=k*1000;
EbNo_db=20;
EbNo=10.^(EbNo_db/10);
beta=0.5;
sps=8;%Samples per symbol
span=20;
tblen =  10;
tb=16;
const = pskmod([0:M-1],M);
Offset1=1; 
Offset2=1;
Offset=abs(Offset1-Offset2);

Symbols = pskmod([0:M-1],M);

rng default;
for j=1:length(EbNo)
    AvgEr=0;
    h1 =1;
    h2= 2;
    AvgEr_1=0;
    
for i=1:runs
    dataIn1=randi([0 1],n,1);
    dataInMatrix1=reshape(dataIn1,length(dataIn1)/k,k);
    dataSymbolsIn1=bi2de(dataInMatrix1);
    ModData1=pskmod(dataSymbolsIn1,M);
    
    dataIn2=randi([0 1],n,1);

    dataInMatrix2=reshape(dataIn2,length(dataIn2)/k,k);
    dataSymbolsIn2=bi2de(dataInMatrix2);
    ModData2=pskmod(dataSymbolsIn2,M);
    
       
    [rrcFilter,t] = srrcFunction(beta,sps,span);
    [rrcFilterShifted1,t2,filtDelay] = srrcFunctionShifted(beta,sps,span,Offset1);
    [rrcFilterShifted2,t2,filtDelay] = srrcFunctionShifted(beta,sps,span,Offset2);
    [rrcFilterShifted,t2,filtDelay] = srrcFunctionShifted(beta,sps,span,Offset);
  
    
    RCFilter=conv(rrcFilter,rrcFilter);
    RCFilter2=conv(rrcFilterShifted2,rrcFilter);
    RCFilter1=conv(rrcFilterShifted1,rrcFilter);
    
    d=floor((length(RCFilter))/2);
    d1=floor((length(RCFilter))/2);
    
    for a=1:5
     ch_estimate2(a)=RCFilter2(((a-1)*sps)+d+1);
     
    end

    for a=1:4
      b=5-a;
    
     ch_estimate2(a+5)=RCFilter2(d+1-(b*sps));
   
    end
%     ch_estimate=circshift( ch_estimate,Offset2);
   ch_estimate2=ch_estimate2([7 8 9 1 2 3 4 5]);
   ch_estimate2=ch_estimate2/norm(ch_estimate2);
    
      TxFilt2 = upfirdn(ModData2, ch_estimate2,sps);
      qwe2 = upfirdn(ModData2, rrcFilterShifted2,8);
%       qwe_r2 = upfirdn(qwe2,rrcFilterShifted2,1,8);
      qwe1 = upfirdn(ModData1, rrcFilterShifted1,8);
      
%       qwe_r1 = upfirdn(qwe1,rrcFilterShifted1,1,8);
      len = min(length(qwe1),length(qwe2));
      qwe = qwe1(1:len)+2.*qwe2(1:len);
      qwe_r = upfirdn(qwe,rrcFilter,1,8);
%     d=floor((length(RCFilter))/2);
    
    for a=1:5
     ch_estimate1(a)=RCFilter1(((a-1)*sps)+d1+1);
     
    end

    for a=1:4
      b=5-a;
    
     ch_estimate1(a+5)=RCFilter1(d1+1-(b*sps));
   
    end
%     ch_estimate=circshift( ch_estimate,Offset2);
   ch_estimate1=ch_estimate1([7 8 9 1 2 3 4 5]);
   ch_estimate1=ch_estimate1/norm(ch_estimate1);
    
      TxFilt1 = upfirdn(ModData1, ch_estimate1, sps);
        
    ChannelDataIn1=h1.*TxFilt1; 
    ChannelDataIn2=h2.*TxFilt2;
   
    
    ChannelDataIn = ChannelDataIn1+ChannelDataIn2;
    snr = EbNo_db(j) + 10*log10(k)- 10*log10(sps);
    ChannelDataOut=awgn(ChannelDataIn,snr,'measured');
    
    %Classify from here
         
end

end


