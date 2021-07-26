
run 'parameters.m'
mmse =[];
error=[];
%% TX Generation
% User1
data1 = randi([0 mod_1-1], No_samp, 1);
modData1 = qammod(data1, mod_1,'UnitAveragePower',true);

% User 2
data2 = randi([0 mod_2-1], No_samp, 1);
modData2 = qammod(data2, mod_2,'UnitAveragePower',true);

% Upsample the data and filter the data
txSig1=   upfirdn(modData1, rrcFilter1, sps_TX, 1);
txSig2 =  upfirdn(modData2, rrcFilter2, sps_TX,1);



%% Channel
txSig_freq1 = ampl1*exp(1i*pi*F1*(1:length(txSig1))).*txSig1.';
txSig_freq2 = ampl2*exp(1i*pi*F2*(1:length(txSig2))).*txSig2.';

% Satellite
txSig = txSig_freq1(lag:floor(end/2))+txSig_freq2(1:length(txSig_freq2(lag:floor(end/2))));

rxSig =  awgn(txSig, snr, 'measured');

%% Receiver
%rxSig2= resample(rxSig,10,1);
 [corr] = CNC_cross_corr(rxSig);
 plot(abs(resample(corr,1,1)))
 grid on
% x=1:length(corr);
% y= abs(corr);
% xx=1:0.01:1:length(corr);
% yy = spline(1:length(corr),abs(corr),xx);
% plot(x,y,'o',xx,yy)
%  grid on;
