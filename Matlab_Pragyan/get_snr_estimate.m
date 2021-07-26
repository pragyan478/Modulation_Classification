function snr = get_snr_estimate(rxSig, sps, beta, shouldPlot)
    frame_size = 2048;
    overlap = 2000;
    psd = powerSpecDen(rxSig, frame_size, overlap, "Blackman-Harris");
    tot_pow = sum(psd);
    sig_pow = sum(psd(frame_size/2 + ...
        (floor(-(1+beta)/sps*frame_size/2):ceil((1+beta)/sps*frame_size/2))));
    noise_pow = tot_pow - sig_pow;
    % estimate of the SNR 
    snr = 10*log10(sig_pow/noise_pow);
    
    if shouldPlot
        %%% can notice that this data does not have a notch at DC
        plot(linspace(-0.5, 0.5, length(psd)), psd)
        title("PSD of signal")
        ylabel("Magnitude")
        xlabel("f/f_s")
        hold on
        xline(-0.5*(1+beta)/sps, "r--")
        xline(0.5*(1+beta)/sps, "r--")
    end
end