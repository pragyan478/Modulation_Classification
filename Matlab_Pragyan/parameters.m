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
mod_1 =4;
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

snr = 10; %in dB

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
 








