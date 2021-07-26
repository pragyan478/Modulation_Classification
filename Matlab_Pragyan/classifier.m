function ModulationClass = classifier(snr,mod_1)
%% Simulation parameters

No_samp = 1000000;


%% Transmitter parameters (Assuming same parameters for both)
%TX_sample_rate = 256e3;
TX_sym_rate = 256e3;
OVS_TX =8;
sps_TX = OVS_TX;
span_TX =20;

% User1
beta_1 = 0.35; % only these values have to be used[0.05, 0.1, 0.15, 0.2, 0.25, 0.35]
%mod_1 =4;
% User2
beta_2 = beta_1;
mod_2 = mod_1;

% RRC filter design
rrcFilter1 = rcosdesign(beta_1, span_TX, sps_TX);
rrcFilter2 = rcosdesign(beta_2, span_TX, sps_TX);
%% Receiver parameters
resample_fac= 1;
RX_sample_rate = resample_fac*256e3;
freq_resolution = 2e3;
rx_filter_span = 20; % Not a big deal. 
No_samples_Sym_rate_est = min(4*(RX_sample_rate/freq_resolution)^2,No_samp);
No_samples_freq_est = min(3e6,No_samp);
No_samples_beta_est = 1e6;

 

%% Channel Parameters

%snr = 10; %in dB

% Frequency offset. 
df1 = 50; % in Hertz
df2 = 100; % in Hertz

% Make sure that F1 and F2  are less than 2/(SPS*4). In the sampling
% domain, we cannot do better than 1/4 since the QAM has an ambiguity of
% pi/4.
F1 = df1/(RX_sample_rate);
F2 = df2/(RX_sample_rate);
%
lag = 1; % Time lag between samples.
power_diff =4; %power difference between the users in dB


ampl1 = 1; % In dBm
ampl2 = sqrt(10^(-power_diff/10));  


mmse =[];
error=[];
%% TX Generation
% User1
data1 = randi([0 mod_1-1], No_samp, 1);
% modData1 = qammod(data1, mod_1,'UnitAveragePower',true);
modData1 = pskmod(data1, mod_1);


% User 2
data2 = randi([0 mod_2-1], No_samp, 1);
% modData2 = qammod(data2, mod_2,'UnitAveragePower',true);
modData2 = pskmod(data2, mod_2);

% Upsample the data and filter the data
txSig1=   upfirdn(modData1, rrcFilter1, sps_TX,1);
txSig2 =  upfirdn(modData2, rrcFilter2, sps_TX,1);



%% Channel
txSig_freq1 = ampl1*exp(1i*2*pi*F1*(1:length(txSig1))).*txSig1.';
txSig_freq2 = ampl2*exp(1i*2*pi*F2*(1:length(txSig2))).*txSig2.';

% Satellite
txSig = txSig_freq2(lag:end) +txSig_freq1(1:end-(lag-1));

rxSig =  awgn(txSig, snr, 'measured');

%% Receiver

% Will there be Doppler estimation that is requried?

%First detect if it is a CNC signal?(x2,fs,freq_res,SNR_conditions)
disp("----- Estimated System Parameters from the data ------");

% Symbol rate estimation
symbol_rate=32e3; %Symbol_Rate_Estimation4(rxSig(1:No_samples_Sym_rate_est),RX_sample_rate,freq_resolution,0);
disp("Estimated Symbol rate (Hz): " + string(symbol_rate));
RX_SPS = RX_sample_rate/symbol_rate;


% Beta estimation
[Beta1_est,Beta2_est] = cnc_beta_estimate(rxSig(1:No_samples_beta_est), 1, RX_SPS, 0,0);
disp("Estimated Roll off factor: " + string(Beta1_est));

snr_est = get_snr_estimate(rxSig, RX_SPS, Beta1_est, false);

% Modulation detection.
[~, main_cfo, fo] = cfo(rxSig, RX_SPS*2, 2^16, 0);
rxSig2 = exp(-1i*2*pi*main_cfo*(1:length(rxSig))).*rxSig;



dfo=fo(2)-fo(1);
[diff, best_est,M] = cumulant_warped_feat(rxSig2(1:1e5), snr_est, RX_SPS, 20, Beta1_est);
disp("Modulation: " + best_est);
if(diff <10)
    disp("CNC is present.");
else
    disp("CNC not present.");
end
disp(" ")

disp("Estimated Power Difference: " + string(diff + " dB"))    
disp("Estimated frequency offset 1 [Hz]: " + string(fo(1)*RX_sample_rate)) 
disp("Estimated frequency offset 2 [Hz]: " + string(fo(2)*RX_sample_rate)) 

disp(" ")
disp(" ")

% % Timing recovery for the weaker user.
[e1, e2, pow_diff] = detect_frac_del_power(rxSig2(1:1e5), Beta1_est, RX_SPS, 20, snr_est, diff, 0);
disp("Timing offset (Carrier 1) = " + num2str(floor(e1*RX_SPS)) + " sample(s) = " + num2str(e1*RX_SPS/RX_sample_rate) + " seconds");
disp("Timing offset (Carrier 2) = " + num2str(floor(e2*RX_SPS)) + " sample(s) = " + num2str(e2*RX_SPS/RX_sample_rate) + " seconds");


%Classification 

rxSig0 = rxSig2(e1*RX_SPS+1:end);
[rrcFilter,t] = srrcFunction(Beta1_est,RX_SPS,20);

rxSig3 = conv(rxSig0,rrcFilter);
data = downsample(rxSig3,RX_SPS);
len = length(data)/2;
N = 500;
data1 = data(len-N/2:len+N/2);
scatterplot(data1);
ModulationClass =  moments1(data1'); % 
%ModulationClass
if(ModulationClass==1)
    fprintf('Class: BPSK-BPSK\n');
elseif(ModulationClass==2)
    fprintf('Class: QPSK-QPSK\n');
elseif(ModulationClass==3)
    fprintf('Class: 8PSK-8PSK\n');
elseif(ModulationClass==4)
    fprintf('Class: 16QAM-16QAM\n');
end



disp(" ")
disp(" ")

total_power=RX_SPS*mean(abs(rxSig2.^2));
R=1/(1+(10.^(0.1*pow_diff)));%(power_diff=R/1-R)
rxSig_1=rxSig(1:1e5);

h12=sqrt(R*total_power);
h11=sqrt((1-R)*total_power);

% ph1=angle(mean(rxSig_1.^2))/2;%Stronger User
% ph2=angle(mean(exp(-1j*2*pi*dfo*(1:1e5)).*rxSig_1.^2))/2;

[Offset1,StrongerUser,WeakerUser,ph1,ph2] = SIC2(rxSig_1',Beta1_est,RX_SPS,rx_filter_span,fo(2),fo(1),h12,h11,M,0);

StrongerUser=StrongerUser(101:end);
WeakerUser=WeakerUser(101:end);
modData1=modData1(101:end);
modData2=modData2(101:end);
ber=0;
ber1=0;
len=length(StrongerUser)

for m=1:len
               if(StrongerUser(m) ~= modData1(m))
                   ber=ber+1;
               end
               
 end
 ber=ber/len;
           
 for m=1:len
     if(WeakerUser(m) ~= modData2(m))
                   ber1=ber1+1;
               end
               
           end
           ber1=ber1/(len);
           


%%%%%% Works till here ^^ %%%%%%%%%%
% 
% %Sampling peak of the larger user.
% filter = rcosdesign(Beta1_est, rx_filter_span, RX_SPS);
% rx_filter_data = conv(rxSig,filter);
% DD=  abs(rx_filter_data);
% sum1=[];
% for k=1:RX_SPS
%     sum1=[sum1 sum(DD(k:RX_SPS:end))];
% end
% [val,ind_high_user]=max(abs(sum1)); %ind_high_user represents the peak of the highest amplitude user .
% 
% inp_freq_est_samples= rx_filter_data(ind_high_user:RX_SPS:end);
% % Residual frequency estimation. Put an arma process and track
% % the frequency.
% [F_est_final,Amp_est_final,Mod_rough]=CNC_freq_estv2(inp_freq_est_samples,RX_sample_rate,RX_SPS,100000);
% display(strcat('Estimated Frequency offset (Hz) is: ', num2str(F_est_final )));
% [~,ind]= max(Amp_est_final);
% fmax= F_est_final(ind);
% [~,ind]= min(Amp_est_final);
% fmin= F_est_final(ind);



%     % Initial phase computation
%     [phase_max,phase_min]=compute_phase_amp(inp_freq_est_samples,RX_sample_rate, RX_SPS, F_est_final,Amp_est_final,Mod_rough);
%     
%     
%     
%     % % Timing recovery for the weaker user.
%     % RX_timing_sig = rx_filter_data(ind_high_user:1:end);
%     %  [Offset1] = TimingOffsetEstimator(RX_timing_sig,StrongerUser,beta,sps,span,Offset2,cfo1,cfo2,h1,h2,M)
%     diff_est = 20*log10(abs(phase_max)/abs(phase_min));
%     [e1, e2, pow_diff] = detect_frac_del_power(rxSig2, Beta1_est, RX_SPS, 20, snr, diff_est, 0);
%     display("The timing offset is " + num2str(floor(e1*RX_SPS)) + " sample(s)");
%     display("This is equal to " + num2str(floor(e1*RX_SPS)/RX_sample_rate) + " seconds ");
%     
%     
%     % Compensating the frequency
%     DFmax = fmax*RX_SPS/(RX_sample_rate);
%     rxSig_max = (1/phase_max)*exp(-1i*2*pi*DFmax*(1:length(inp_freq_est_samples))).*inp_freq_est_samples;
%     % Compensating the frequency
%     DFmin = fmin*RX_SPS/(RX_sample_rate);
%     rxSig_min = (1/phase_min)*exp(-1i*2*pi*DFmin*(1:length(inp_freq_est_samples))).*inp_freq_est_samples;
%     
%     Block_size = 10000;
%     no_blocks = 10;%floor(length(rxSig_max)/Block_size);
%     for k=1:no_blocks
%         dat = rxSig_max((1:10000)+(k-1)*10000);
%         [phase_max_m,phase_min_m]=compute_phase_amp(dat,RX_sample_rate, RX_SPS, [0,0],Amp_est_final,Mod_rough);
%         rxSig_max_m =  (1/phase_max_m).*dat;
%         scatterplot(rxSig_max_m );
%         grid on
%         
%     end
end
