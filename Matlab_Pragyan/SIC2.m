function [Offset1,StrongerUser,WeakerUser,ph1,ph2] = SIC2(ReceivedSignal,beta,sps,span,cfo1,cfo2,h1,h2,M,Offset2)
% User2 is stronger user and User1 is weaker User
% This function gives timing offset of weaker user and symbols of stronger
% user and weaker user
% ReceivedSignal=CNC signal with noise
% beta=Roll off factor
% sps=Samples per symbol
% span=span of the filter
% Offset2=Timing Offset of stronger user=0
% cfo1=Carrier Frequency Offset of weaker user
% cfo2=Carrier Frequency Offset of stronger user
% h1=Scaling of weaker user
% h2=Scaling of stronger user
% theta1=Phase offset of weaker user
% theta2=Phase offset of stronger user=0
% (In Simulation tested h1=1 and h2=2 i.e 3dB power difference)
% M=Modulation Order
% (In Simulation tested on BPSK) :This will work for PSK Modulations. For
% QAM modulation all pskmod and pskdemod functions will be replaced by
% qammode and qamdemod respectively
% Offset2=0;
tblen =  10;
tb=16;
const = pskmod([0:M-1],M);
k=log2(M);
FreqOffset1=cfo1;
FreqOffset2=cfo2;

ChannelDataOut=ReceivedSignal;

[rrcFilter,~] = srrcFunction(beta,sps,span);
[rrcFilterShifted2,t2,filtDelay] = srrcFunctionShifted(beta,sps,span,Offset2);


RCFilter=conv(rrcFilter,rrcFilter);
RCFilter2=conv(rrcFilterShifted2,rrcFilter);

d=floor((length(RCFilter2))/2);


for a=1:(sps/2)+1
    ch_estimate2(a)=RCFilter2(((a-1)*sps)+d+1);
end
for a=1:(sps/2)-1
    b=(sps/2)-a;
    ch_estimate2(a+(sps/2)+1)=RCFilter2(d+1-(b*sps));
end

ch_estimate2=circshift( ch_estimate2,Offset2);
ch_estimate2=ch_estimate2/norm(ch_estimate2);

ChannelDataOut1=ChannelDataOut.*(exp((-2)*pi*1j*FreqOffset2*(0:length(ChannelDataOut)-1)))';
% RxFilt = upfirdn(ChannelDataOut1,rrcFilter, 1, 1);
RxFilt=conv(ChannelDataOut1,rrcFilter);
% RxFilt=RxFilt(1:end-1) ;
% % length(RxFilt)
ph2=angle(mean(RxFilt.^2))/2;%Stronger User
RxFilt=RxFilt*exp(-1j*ph2);
% ph2=angle(mean(exp(-1j*2*pi*dfo*(1:1e5)).*rxSig_1.^2))/2;
y = mlseeq(RxFilt,ch_estimate2,const,tblen,'rst',sps) ;

RemTrans= y(span+1:end-span);
TxFilt2_hat=upsample(RemTrans,sps);
TxFilt2_hat=conv(TxFilt2_hat,rrcFilterShifted2);
% TxFilt2_hat = upfirdn(RemTrans,rrcFilterShifted2, sps);
TxFilt2_hat=TxFilt2_hat(1:end-2*Offset2);

ChannelDataIn2_hat=h2.*TxFilt2_hat*exp(1j*ph2).*(exp((2)*pi*1j*FreqOffset2*(0:length(TxFilt2_hat)-1)))';
% a=length(ChannelDataIn2_hat)
% b=length(ChannelDataOut)
ChannelDataOut_hat=ChannelDataOut-(ChannelDataIn2_hat);

RxFilt1_hat=ChannelDataOut_hat.*(exp((-2)*pi*1j*(FreqOffset1)*(0:length(ChannelDataOut_hat)-1)))';
% RxFilt1_hat = upfirdn( RxFilt1_hat, rrcFilter, 1, 1);
RxFilt1_hat=conv(RxFilt1_hat,rrcFilter);
% RxFilt1_hat=RxFilt1_hat(1:end-1);
ph1=angle(mean(RxFilt1_hat.^2))/2;%Stronger User
RxFilt1_hat=RxFilt1_hat*exp(-1j*ph1);

for q=0:sps-1
    
    [rrcFilterShiftedq,t2,filtDelay] = srrcFunctionShifted(beta,sps,span,q);
    RCFilterq=conv(rrcFilterShiftedq,rrcFilter);
    dq=floor((length(RCFilterq))/2);
    
    for a=1:(sps/2)+1
        ch_estimateq(a)=RCFilterq(((a-1)*sps)+dq+1);
    end
    for a=1:(sps/2)-1
        b=(sps/2)-a;
        ch_estimateq(a+(sps/2)+1)=RCFilterq(dq+1-(b*sps));
    end
    ch_estimateq=circshift( ch_estimateq,q);
    ch_estimateq=ch_estimateq/norm(ch_estimateq);
    
    y1_hat = mlseeq(RxFilt1_hat,ch_estimateq,const,tblen,'rst',sps) ;
    RemTrans1= y1_hat(span+1:end-span);
    
    
%     TxFilt1_hat = upfirdn(RemTrans1, rrcFilterShiftedq, sps);
    TxFilt1_hat=upsample(RemTrans1,sps);
    TxFilt1_hat=conv(TxFilt1_hat,rrcFilterShiftedq);
    TxFilt1_hat=TxFilt1_hat(1:end-2*q);
    ChannelDataIn1_hat=exp(1j*ph1)*h1.*TxFilt1_hat.*(exp((2)*pi*1j*FreqOffset1*(0:length(TxFilt1_hat)-1)))';
    ChannelEstimation(q+1,:)=ch_estimateq;
    
    ChannelDataOut_hat=ChannelDataIn1_hat+ChannelDataIn2_hat;
    MMSE(:,q+1)=abs(ChannelDataOut-ChannelDataOut_hat).^2;
end

MeanErr=mean(MMSE,1);

[MinErr,Index]=min(MeanErr);
Offset1=(Index-1);
ch_estimate1_hat=ChannelEstimation(Index,:);

y1 = mlseeq( RxFilt1_hat,ch_estimate1_hat,const,tblen,'rst',sps) ;

RemTrans1= y1(span+1:end-span);

StrongerUser=RemTrans;
WeakerUser=RemTrans1;

end
