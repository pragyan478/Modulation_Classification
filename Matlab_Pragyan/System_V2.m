
run 'parameters.m'
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
txSig_freq1 = ampl1*exp(1i*pi*F1*(1:length(txSig1))).*txSig1.';
txSig_freq2 = ampl2*exp(1i*pi*F2*(1:length(txSig2))).*txSig2.';

% Satellite
txSig = txSig_freq2(lag:end) +txSig_freq1(1:end-(lag-1));

rxSig =  awgn(txSig, snr, 'measured');
 
%% Receiver

% Will there be Doppler estimation that is requried?

%First detect if it is a CNC signal?(x2,fs,freq_res,SNR_conditions)

% Symbol rate estimation
symbol_rate=Symbol_Rate_Estimation4(rxSig(1:No_samples_Sym_rate_est),RX_sample_rate,freq_resolution,0);
display(strcat('Estimated Symbol rate (Hz) is: ', num2str(symbol_rate)));
RX_SPS = RX_sample_rate/symbol_rate;

% Beta estimation
[Beta1_est,Beta2_est] = cnc_beta_estimate(rxSig(1:No_samples_beta_est), 1, RX_SPS, 0,0);
display(strcat('Estimated Beta is: ', num2str(Beta1_est)));

 %Sampling peak of the larger user.
filter = rcosdesign(Beta1_est, rx_filter_span, RX_SPS);
rx_filter_data = conv(rxSig,filter);
DD=  abs(rx_filter_data);
sum1=[];
for k=1:RX_SPS
    sum1=[sum1 sum(DD(k:RX_SPS:end))];
end
[val,ind_high_user]=max(abs(sum1)); %ind_high_user represents the peak of the highest amplitude user .
 
inp_freq_est_samples= rx_filter_data(ind_high_user:RX_SPS:end);
% Residual frequency estimation. Put an arma process and track
% the frequency.
[F_est_final,Amp_est_final,Mod_rough]=CNC_freq_estv2(inp_freq_est_samples,RX_sample_rate,RX_SPS,10000);
display(strcat('Estimated Frequency offset (Hz) is: ', num2str(F_est_final )));
[~,ind]= max(Amp_est_final);
fmax= F_est_final(ind);
[~,ind]= min(Amp_est_final);
fmin= F_est_final(ind);
 % Initial phase computation
[phase_max,phase_min]=compute_phase_amp(inp_freq_est_samples,RX_sample_rate, RX_SPS, F_est_final,Amp_est_final,Mod_rough);
[phase_max1,phase_min2]=compute_phase_amp(rxSig,RX_sample_rate, RX_SPS, F_est_final,Amp_est_final,Mod_rough);


% Modulation detection.
rxSig2 = exp(-1i*pi*(fmax/(RX_sample_rate))*(1:length(rxSig))).*rxSig;
[diff, best_est] = cumulant_warped_feat(rxSig2(1:320000), 10, RX_SPS,20, Beta1_est);
display(strcat('modulation is: ', best_est));


% % Timing recovery for the weaker user. 
% RX_timing_sig = rx_filter_data(ind_high_user:1:end);
%  [Offset1] = TimingOffsetEstimator(RX_timing_sig,StrongerUser,beta,sps,span,Offset2,cfo1,cfo2,h1,h2,M)
diff_est = 10*log10(abs(phase_max)/abs(phase_min));
[e1, e2, pow_diff] = detect_frac_del_power(rxSig2, Beta1_est, RX_SPS, 20, snr, diff_est, 0);



% Compensating the frequency of the strong user
DFmax = fmax*RX_SPS/(RX_sample_rate);
rxSig_max = (1/phase_max)*exp(-1i*2*pi*DFmax*(1:length(inp_freq_est_samples))).*inp_freq_est_samples;
% Compensating the frequency 
DFmin = fmin*RX_SPS/(RX_sample_rate);
rxSig_min = (1/phase_min)*exp(-1i*2*pi*DFmin*(1:length(inp_freq_est_samples))).*inp_freq_est_samples;

Block_size = 10000;
no_blocks = 10;%floor(length(rxSig_max)/Block_size);
for k=1:no_blocks
    dat = rxSig_max((1:10000)+(k-1)*10000);
    [phase_max_m,phase_min_m]=compute_phase_amp(dat,RX_sample_rate, RX_SPS, [0,0],Amp_est_final,Mod_rough);
    rxSig_max_m =  (1/phase_max_m).*dat;
    % Kushbu May be you can put your code here. 
%    [Offset1,StrongerUser(:,k),WeakerUser(:,k)] = SIC(rxSig_max_m',Beta1_est,RX_SPS,rx_filter_span,DFmin,DFmax,4,mod_1,(phase_min_m-phase_max_m),0);
%    [Offset1,StrongerUser,WeakerUser] = SIC(ReceivedSignal,beta,sps,span,cfo1,PowerDifference,M,theta1,theta2)
    scatterplot(rxSig_max_m );  
    grid on
    
 end
% StrongerUser1=StrongerUser(:);
% WeakerUser1=WeakerUser(:);
ber=0;
ber1=0;
[Offset1,StrongerUser,WeakerUser,h1,h2] = SIC(rxSig',Beta1_est,RX_SPS,rx_filter_span,F1,F2,4,mod_1,phase_min2,phase_max1);
 for m=1:length(modData1)
               if(StrongerUser(m) ~= modData1(m))
                   ber=ber+1;
               end
               
 end
 ber=ber/length(modData1);
           
 for m=1:length(modData2)
               if(WeakerUser(m) ~= modData2(m))
                   ber1=ber1+1;
               end
               
           end
           ber1=ber1/length(modData2);
           