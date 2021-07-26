%% Simulation parameters
No_samp = 5e6;

%% Receiver parameters
resample_fac= 1;
RX_sample_rate = resample_fac*256e3;
freq_resolution = 2e3;
rx_filter_span = 20; % Not a big deal. 
No_samples_Sym_rate_est = min(60*(RX_sample_rate/freq_resolution)^2,No_samp);
No_samples_freq_est = min(3e6,No_samp);
No_samples_beta_est = 1e6;
 



