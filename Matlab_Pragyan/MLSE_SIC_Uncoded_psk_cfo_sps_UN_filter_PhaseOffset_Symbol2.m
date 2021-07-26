%
%%psk
clc;
clear all;
runs=10;
M=2;
k=log2(M);
n=k*1e6;
EbNo_db=19:1:20;
EbNo=10.^(EbNo_db/10);
beta=0.35;
sps=8;%Samples per symbol
span=20;
tblen =  10;
tb=16;
lag=1;
const = pskmod([0:M-1],M);
Offset1=0;
Offset2=0;
% Offset=abs(Offset1-Offset2);
% del=Offset/sps;
% n1=1/del;
Symbols = pskmod([0:M-1],M);
p1 =(1/sqrt(2))*(randn(1,1)+ 1j*randn(1,1));
p2 = (1/sqrt(2))*(randn(1,1)+ 1j*randn(1,1));

% theta1 =angle(p1)+pi;
% theta2 = angle(p2)+pi;
theta1=0;
theta2=0;
FreqOffset1=0.000390625000000000;
FreqOffset2=0.000195312500000000;
% SamplingFrequency=1/2;

rng default;
for j=1:length(EbNo)
    AvgEr=0;
    h1 =0.63;
    h2= 1;
    AvgEr_1=0;
    j
    
    for i=1:runs
        
        ber=0;
        ber_1=0;
        
        dataIn1=randi([0 1],n,1);
        %     t1 = poly2trellis([5 4],[23 35 0; 0 5 13]);
        %     t1 = poly2trellis(7,[171 133]);
        %     code1 = convenc(dataIn1,t1);
        dataInMatrix1=reshape(dataIn1,length(dataIn1)/k,k);
        dataSymbolsIn1=bi2de(dataInMatrix1);
        ModData1=pskmod(dataSymbolsIn1,M);
        
        dataIn2=randi([0 1],n,1);
        %     code2 = convenc(dataIn2,t1);
        dataInMatrix2=reshape(dataIn2,length(dataIn2)/k,k);
        dataSymbolsIn2=bi2de(dataInMatrix2);
        ModData2=pskmod(dataSymbolsIn2,M);
        
        snr = EbNo_db(j) + 10*log10(k)- 10*log10(sps);
        
        
        
        [rrcFilter,t] = srrcFunction(beta,sps,span);
        [rrcFilterShifted1,t2,filtDelay] = srrcFunctionShifted(beta,sps,span,Offset1);
        [rrcFilterShifted2,t2,filtDelay] = srrcFunctionShifted(beta,sps,span,Offset2);
        TxFilt1 = upfirdn(ModData1, rrcFilterShifted1, sps);
        TxFilt1=TxFilt1(1:end-2*Offset1);
        
        
        TxFilt2 = upfirdn(ModData2,rrcFilterShifted2, sps);
        TxFilt2=TxFilt2(1:end-2*Offset2);
        
        RCFilter=conv(rrcFilter,rrcFilter);
        RCFilter2=conv(rrcFilterShifted2,rrcFilter);
        RCFilter1=conv(rrcFilterShifted1,rrcFilter);
        
        d=floor((length(RCFilter2))/2);
        d1=floor((length(RCFilter1))/2);
        
        for a=1:(sps/2)+1
            ch_estimate2(a)=RCFilter2(((a-1)*sps)+d+1);
        end
        for a=1:(sps/2)-1
            b=(sps/2)-a;
            ch_estimate2(a+(sps/2)+1)=RCFilter2(d+1-(b*sps));
        end
        ch_estimate2=circshift( ch_estimate2,Offset2);
        %    ch_estimate2=ch_estimate2([7 8 9 1 2 3 4 5]);
        
        ch_estimate2=ch_estimate2/norm(ch_estimate2);
        %   [Max2,I2] = max(ch_estimate2);
        %      ch_estimate2=circshift( ch_estimate2,I2-1);
        
        for a=1:(sps/2)+1
            ch_estimate1(a)=RCFilter1(((a-1)*sps)+d1+1);
        end
        for a=1:(sps/2)-1
            b=(sps/2)-a;
            ch_estimate1(a+(sps/2)+1)=RCFilter1(d1+1-(b*sps));
        end
        
        %    ch_estimate1=ch_estimate1([7 8 9 1 2 3 4 5]);
        ch_estimate1=ch_estimate1/norm(ch_estimate1);
        %     [Max1,I1] = max(ch_estimate1);
        ch_estimate1=circshift(ch_estimate1,Offset1);
        
        
        
        ChannelDataIn1=h1.*TxFilt1*exp(1j*theta1);
        TxSigwidOffset1=ChannelDataIn1.*(exp((2)*pi*1j*FreqOffset1*(0:length(TxFilt1)-1)))';
        ChannelDataIn2=h2.*TxFilt2*exp(1j*theta2);
        TxSigwidOffset2=ChannelDataIn2.*(exp((2)*pi*1j*FreqOffset2*(0:length(TxFilt2)-1)))';
%         txSig = txSig_freq2(lag:end) +txSig_freq1(1:end-(lag-1));
        ChannelDataIn =TxSigwidOffset1+TxSigwidOffset2;
        ChannelDataIn =TxSigwidOffset1(lag:end) +TxSigwidOffset2(1:end-(lag-1));
        
        % ChannelDataOut=ChannelDataIn;
        ChannelDataOut5=awgn(ChannelDataIn,snr,'measured');
          ChannelDataOut= ChannelDataOut5(1:1e5);                                    
%           ReceivedSignal,beta,sps,span,cfo1,h1,h2,M,theta1,theta2
%         [Offset11,ch_estimate1_hat] = TimingOffsetEstimator2(ChannelDataOut,beta,sps,span,FreqOffset1,h1,h2,M,theta1,theta2)
%         Offset_snr(j,i)=Offset11;
%         if  Offset_snr(j,i)==Offset1
%             percent1(j,i)=1;
%         end

[Offset1,RemTrans,RemTrans1] = SIC2(ChannelDataOut,beta,sps,span,FreqOffset1,FreqOffset2,h1,h2,M,theta1,theta2);
%              RxFilt2=exp(-1j*theta2)*ChannelDataOut.*(exp((-2)*pi*1j*FreqOffset2*(0:length(TxFilt2)-1)*(1/(2*SamplingFrequency))))';
%              RxFilt = upfirdn( RxFilt2,rrcFilter, 1, 1);
%             RxFilt=RxFilt(1:end-1) ;
%         
%         
%         y = mlseeq(RxFilt,ch_estimate2,const,tblen,'rst',sps) ;
%         
%             RemTrans= y(span+1:end-span+1);
%         
%         
%             dataSymbolsOut=pskdemod(RemTrans,M);
%             dataOutMatrix=de2bi(dataSymbolsOut,k);
%             dataOut=dataOutMatrix(:);
%         %     decoded = vitdec(dataOut,t1,tb,'trunc','hard');
%         %     [numErrors,ber]=biterr(dataIn2,dataOut);
           len=12480;

          for m=1:len
               if(RemTrans(m) ~= ModData2(m))
                   ber=ber+1;
               end
               
           end
           ber=ber/len;
             AvgEr=AvgEr+ber;
        
%              data2_hat=dataOut;
        
        %     code2_hat = convenc(data2_hat,t1);
%             dataInMatrix2_hat=reshape(data2_hat,length(data2_hat)/k,k);
%             dataSymbolsIn2_hat=bi2de(dataInMatrix2_hat);
%             ModData2_hat=pskmod(dataSymbolsIn2_hat,M);
%             TxFilt2_hat = upfirdn(ModData2_hat,rrcFilterShifted2, sps);
%              TxFilt2_hat=TxFilt2_hat(1:end-2*Offset2);
%         
%             ChannelDataIn2_hat=exp(1j*theta2)*h2.*TxFilt2_hat.*(exp((2)*pi*1j*FreqOffset2*(0:length(TxFilt2)-1)*(1/(2*SamplingFrequency))))';
%         
%             ChannelDataOut_hat=ChannelDataOut-(ChannelDataIn2_hat);
%         
%         %     RxFilt1_hat=ChannelDataOut_hat;
%             RxFilt1_hat=exp(-1j*theta1)*ChannelDataOut_hat.*(exp((-2)*pi*1j*FreqOffset1*(0:length(TxFilt1)-1)*(1/(2*SamplingFrequency))))';
%         RxFilt1_hat = upfirdn( RxFilt1_hat, rrcFilter, 1, 1);
%         
%             %     RxFilt1_hat = upfirdn( ChannelDataOut_hat, rrcFilter, 1, 1);
%         
%              [estimated_offset(j,i)]=Timimg_Offset_Estimator(RxFilt1_hat,sps);
%                          if estimated_offset(j,i)==Offset1
%                              percent(j,i)=1;
%                          end
%         
%         
%             RxFilt1_hat=RxFilt1_hat(1:end-1);
%             
%             
%             y1 = mlseeq( RxFilt1_hat,ch_estimate1,const,tblen,'rst',sps) ;
%         
%             RemTrans1= y1(span+1:end-span+1);
%         
%         
%             dataSymbolsOut1_hat=pskdemod(RemTrans1,M);
%             dataOutMatrix1_hat=de2bi(dataSymbolsOut1_hat,k);
%             dataOut1_hat=dataOutMatrix1_hat(:);
%         %     decoded1_hat = vitdec(dataOut1_hat,t1,tb,'trunc','hard');
%         %     [numErrors1,ber_1]=biterr(dataIn1,dataOut1_hat);
           for r=1:len
               if(RemTrans1(r) ~= ModData1(r))
                   ber_1=ber_1+1;
               end
           end
           ber_1=ber_1/len;
        AvgEr_1=AvgEr_1+ber_1;
        
        
        
    end
    BER(j)=AvgEr/runs;
    
    BER_1(j)=AvgEr_1/runs;
end

semilogy(EbNo_db,BER,'-b*')

% x=sqrt(3*k*EbNo/(M-1));
% BER_Th=(4/k)*(1-1/sqrt(M))*(1/2)*erfc(x/sqrt(2));
BER_Th=qfunc(sqrt(2*EbNo));
hold on
semilogy(EbNo_db,BER_1,'-bd')
semilogy(EbNo_db,BER_Th,'-ko')
ylim([0.00001 1]);
title('SIC with CFO, Weaker User Offset=20% ,Stronger user Offset=20%')
xlabel('EbN0 (dB)')
ylabel('BER')
legend('Stronger User SIC','Weaker User SIC','Theoretical (AWGN)','Location','southwest')
%  hold off
% correct=sum(percent,2);
% correct1=sum(percent1,2);
grid on
grid minor
hold off
