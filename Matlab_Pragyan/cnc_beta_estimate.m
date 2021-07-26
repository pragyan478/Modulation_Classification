function [a1, a2] = cnc_beta_estimate(m_rx_t, dsf, sps, fo1, fo2)
    %CNC_BETA_ESTIMATE
    % Inputs-
    %   m_rx_t - raw input vector
    %   dsf - downsampling factor (to increase resolution if required), default 1
    %   sps - samples per symbol
    %   fo1, fo2 - initial guesses/estimates for frequency offsets
    %
    % Outputs-
    %   a1 - rolloff factor 1 
    %   a2 - rolloff factor 2
    
    %% 
    if dsf > 1
        m_rx_t  = downsample(m_rx_t, dsf);
        sps = sps/dsf;
    end
    %% pre-processing
    psd_frame_size = 2048;
    overlap = 2000; 
    psd = powerSpecDen(m_rx_t, psd_frame_size, overlap,'Blackman-Harris');
    % need to remove noise,
    % find noise floor of psd and subtract from PSD
    p_range = (max(psd) - min(psd));
    noise_threshold = 1e-4;

    c = max(psd)/(max(psd) + min(psd));
    p_res = 2*(1-c)*p_range;
    if mode(psd) > noise_threshold
        ii = psd < (mode(psd) + p_res);
        rx_noise_power_estimate = mean(psd(ii));
        psd = psd - rx_noise_power_estimate;
    end

    %% Plot of Rx PSD
      psd = fftshift(psd);
%     plot(linspace(-0.5,0.5, length(psd)), psd)
%     title("PSD of received signal")
%     ylabel("Magnitude"); xlabel("Normalised frequency (f/f_s)")
%     grid

    %% Estimation
    % a1 is beta estimate of carrier 1, fo1 is frequency offset of carrier 1
    % a2 is beta estimate of carrier 2, fo2 is frequency offset of carrier 2
    % (fo1 and fo2 are in terms of the ratio of sample rate)

    [a1,a2,fo1,fo2, diff_est] = grad_descent(psd, 1/sps, 1, 1, fo1, fo2);

    % fo1, fo2 are loose estimates, they are variables introduced for
    % better curve fitting of the psd

    % we can discretize roll-offs
    true_roll_offs = [0.05, 0.1, 0.15, 0.2, 0.25, 0.35];
    [d, pos] = min(abs(a1 - true_roll_offs));
    a1 = true_roll_offs(pos);
    [d, pos] = min(abs(a2 - true_roll_offs));
    a2 = true_roll_offs(pos);
end

