clear;
clc;

run 'parameters_demp2.m'
mmse =[];
error=[];
%  filename  = "../data/C_bpsk_32ksps_cnc_2.iq";
% filename  = "../data/A_qpsk_32ksps_cnc_1.iq";
% filename  = "../data/july15/E_8qam_32ksps_SR256ksps_CR180064000hz_1.iq";
filename = "../data/july15/E_qpsk_32ksps_SR256ksps_CR180064000hz_1.iq";


shift = true;
f_shift = 64e3;

[f,errmsg] = fopen(filename, 'rb'); % change filename to whichever you want

iq_samples = fread (f, 40e6,'float'); % the entire file will be loaded onto memory. (Not an issue if RAM has around 500MB free space)
total_samples = length(iq_samples); % total number of I and Q samples
fclose(f);

t = reshape(iq_samples, [2 total_samples/2]).';
v = t(:,1) + 1j*t(:,2); % converting iq to complex number
[r, c] = size (v);
rxSig =  (reshape (v, c, r)); % received signal

if shift
    rxSig_unfil = rxSig.*exp(-1j*2*pi*(f_shift/RX_sample_rate).*(0:length(rxSig)-1)); % shift to DC
end
Hd = filter_025;
rxSig= rxSig_unfil;%conv(rxSig_unfil, Hd.Numerator);
%% Receiver

% Will there be Doppler estimation that is requried?

%First detect if it is a CNC signal?(x2,fs,freq_res,SNR_conditions)
disp("----- Estimated System Parameters from the data ------");

% Symbol rate estimation
symbol_rate=Symbol_Rate_Estimation4(rxSig(1:No_samples_Sym_rate_est),RX_sample_rate,freq_resolution,0);
disp("Estimated Symbol rate (Hz): " + string(symbol_rate));
RX_SPS = RX_sample_rate/symbol_rate;


% Beta estimation
[Beta1_est,Beta2_est] = cnc_beta_estimate(rxSig(1:No_samples_beta_est), 1, RX_SPS, 0,0);
disp("Estimated Roll off factor: " + string(Beta1_est));

snr_est = get_snr_estimate(rxSig, RX_SPS, Beta1_est, false);

% Modulation detection.
[~, main_cfo, fo] = cfo(rxSig, RX_SPS*2, 2^15, 0);
rxSig2 = exp(-1i*2*pi*main_cfo*(1:length(rxSig))).*rxSig;
[diff, best_est] = cumulant_warped_feat(rxSig2(1:2e5), snr_est, RX_SPS, 20, Beta1_est);
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
[e1, e2, pow_diff] = detect_frac_del_power(rxSig2(1:2e5), Beta1_est, RX_SPS, 20, snr_est, diff, 0);
disp("Timing offset (Carrier 1) = " + num2str(floor(e1*RX_SPS)) + " sample(s) = " + num2str(e1*RX_SPS/RX_sample_rate) + " seconds");
disp("Timing offset (Carrier 2) = " + num2str(floor(e2*RX_SPS)) + " sample(s) = " + num2str(e2*RX_SPS/RX_sample_rate) + " seconds");

disp(" ")
disp(" ")

% 
% %%%%%% Works till here ^^ %%%%%%%%%%
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
% %     % Initial phase computation
% %     [phase_max,phase_min]=compute_phase_amp(inp_freq_est_samples,RX_sample_rate, RX_SPS, F_est_final,Amp_est_final,Mod_rough);
% %     
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

