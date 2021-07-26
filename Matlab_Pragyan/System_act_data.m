
run 'parameters.m'

filename  = "../data/A_qpsk_32ksps_cnc_1.iq";
shift =0;

[f,errmsg] = fopen(filename, 'rb'); % change filename to whichever you want
 
iq_samples = fread (f, 20e6,'float'); % the entire file will be loaded onto memory. (Not an issue if RAM has around 500MB free space)
total_samples = length(iq_samples); % total number of I and Q samples
fclose(f);
t = reshape(iq_samples, [2 total_samples/2]).';
v = t(:,1) + 1j*t(:,2); % converting iq to complex number
[r, c] = size (v);
rxSig2 =   conj(reshape (v, c, r));

if(shift==1)
rx_ds = exp(1i*2*pi*(1:length(rxSig2))*128/512).*rxSig2;
rxSig= 10*resample(rx_ds,resample_fac,2);
else
    rxSig= 10*resample(rxSig2,resample_fac,1);
end

    


%% Receiver

% Will there be Doppler estimation that is requried?

%First detect if it is a CNC signal?

% Symbol rate estimation
symbol_rate=Symbol_Rate_Estimation(rxSig(1:1e6),RX_sample_rate,freq_resolution);

%symbol_rate=Symbol_Rate_Estimation3(rxSig(1:min(length(rxSig),No_samples_Sym_rate_est)),RX_sample_rate,freq_resolution,0);
display(strcat('Estimated Symbol rate (Hz) is: ', num2str(symbol_rate)));
 RX_SPS = RX_sample_rate/symbol_rate;

% Beta estimation
[Beta1_est,Beta2_est] = cnc_beta_estimate(rxSig(1:No_samples_beta_est), 2, RX_SPS, 0,0);
display(strcat('Estimated Beta is: ', num2str(Beta1_est)));
 %FInding the time fo the larger user.
filter = rcosdesign(Beta1_est, rx_filter_span, RX_SPS,'sqrt');
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
[F_est_final,Amp_est_final,Mod_rough]=CNC_freq_estv2(inp_freq_est_samples,RX_sample_rate,RX_SPS,150000);
display(strcat('Estimated Frequency offset (Hz) is: ', num2str(F_est_final )));
 [~,ind]= max(Amp_est_final);
fmax= F_est_final(ind);
[~,ind]= min(Amp_est_final);
fmin= F_est_final(ind);
 % Initial phase computation
[phase_max,phase_min]=compute_phase_amp(inp_freq_est_samples,RX_sample_rate, RX_SPS, F_est_final,Amp_est_final,Mod_rough);


% Modulation detection.
rxSig2 = exp(-1i*pi*(fmax/(RX_sample_rate))*(1:length(rxSig))).*rxSig;
[diff, best_est] = cumulant_warped_feat(rxSig2(1:320000), 20, RX_SPS,20, Beta1_est);
display(strcat('modulation is: ', best_est));

%
DFmax = fmax*RX_SPS/(RX_sample_rate);
rxSig_max = (1/phase_max)*exp(-1i*pi*DFmax*(1:length(inp_freq_est_samples))).*inp_freq_est_samples;


DFmin = fmin*RX_SPS/(RX_sample_rate);
rxSig_min = (1/phase_min)*exp(-1i*pi*DFmin*(1:length(inp_freq_est_samples))).*inp_freq_est_samples;


Block_size = 10000;
no_blocks = floor(length(rxSig_max)/Block_size);
for k=1:no_blocks

    dat = rxSig_max((1:Block_size)+(k-1)*Block_size);
    [phase_max_m,phase_min_m]=compute_phase_amp(dat,RX_sample_rate, RX_SPS, [0,0],Amp_est_final,Mod_rough);
    rxSig_max_m = (1 /phase_max_m).*dat;
    scatterplot(rxSig_max_m );  
    grid on
    
end

%[ind] = nearest_nhbr_moddetect(rxSig_max,phase_max,phase_min,DFmax, DFmin);


% %Sampling peak of the larger user.
% filter = rcosdesign(Beta1_est, rx_filter_span, RX_SPS);
% rx_filter_data = conv(rxSig2,filter);
% DD=  abs(rx_filter_data);
% sum1=[];
% for k=1:RX_SPS
%     sum1=[sum1 sum(DD(k:RX_SPS:end))];
% end
% [val,ind_high_user]=max(abs(sum1)); %ind_high_user represents the peak of the highest amplitude user .
%
% sym_user_rx_high = rx_filter_data(ind_high_user:RX_SPS:end);
% rseq_len =10;
% datar = randi([0 mod_1-1], rseq_len, 1);
%  ranseq= qammod(datar(1:rseq_len), mod_1,'UnitAveragePower',true);
% %  ranSig=   upfirdn(ranseq, rrcFilter1, sps_TX,1);
% %
% % cc=xcorr(rxSig2,ranSig);
% %
% %plot(abs(cc));
%
% dd=xcorr(ranseq,sym_user_rx_high);
% figure;
% plot(abs(dd));
% strfind(data1', datar(1:rseq_len)')
%
% %
% % % scatterplot(str_user_rx(1:1000))
% %
% % %Blind search.
% % Search_space = 6; %4 symbols will be searched.
% % [x1,x2,x3,x4, x5, x6] = ndgrid([0:mod_1-1],[0:mod_1-1],[0:mod_1-1],[0:mod_1-1],[0:mod_1-1],[0:mod_1-1]);%,[0:mod_1-1],[0:mod_1-1],[0:mod_1-1],[0:mod_1-1]);
% % inds=[x1(:), x2(:), x3(:), x4(:),x5(:),x6(:)];%,x7(:), x8(:),x9(:),x10(:)];
% % filter_b = rcosdesign(Beta1_est, 10, RX_SPS);
% % section = sym_user_rx_high(20:20+Search_space-1);
% % corrb=[];
% % for k=1:length(inds)
% %
% %     % modulare the k th data.
% %     modDatar = qammod(inds(k,:), mod_1,'UnitAveragePower',true);
% %
% %     corrb=[corrb  (modDatar*section')];
% %
% % end
% % plot(abs(corrb));
% % % figure
% %  [B,I]= sort(abs(corrb), 'descend');
% %  mem_d= 10;
% %  mem_ind = inds(I(1:mem_d),:);
% % % mem_corrb = corrb(I(1:mem_d));
% % corrb=[];
% % section2 = sym_user_rx_high(20:20+Search_space*2-1);
% % corrb2=[];
% % for m =1:mem_d
% %     for k=1:length(inds)
% %
% %         % modulare the k th data.
% %         modData1 = qammod([mem_ind(m,:) inds(k,:)], mod_1,'UnitAveragePower',true);
% %
% %         corrb2=[corrb2 abs(modData1*section2')];
% %
% %     end
% % end
% %
% % plot(corrb2);
