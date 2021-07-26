function [e1, e2, pow_diff] = detect_frac_del_power(m_rx_t, beta, sps, span, snr, diff_est, shouldPlot)
    % DETECT_FRAC_DEL_POWER
    % m_rx_t (complex vector) - raw input signal vector with frequency correction for at least one stream
    % beta - roll off factor
    % T - symbol rate
    % sps - samples per symbol
    % span - span of srrc filter
    % snr - estimate of snr estimate in dB
    % diff_est - estimate of the difference in power level of the two streams in dB
    % shouldPlot - boolean for whether the function should plot the correlation spectrum curves
    %
    % Outputs:
    % best_e: row vector, contains [epsilon_1, epsilon_2, best_power_difference]
    %
    %
    % Rx filtering (matched filter)
    T = 1;
    h = generate.get_srrc_filter(T,0,beta,sps,span);
    rc_power = mean(abs(fft(conv(h,h))).^2 )/sps; % raised cosine power
    rx = conv(m_rx_t, h);
    rx = rx(span*sps/2+1:end); 

    np = 10^(-snr/10);
    % normalize
    rx = (rx/sqrt(mean(abs(rx).^2)))*sqrt(rc_power*(1+np));

    D = sps;
    deltas = (0:(sps-1))/sps;
    d = 0:(sps-1);
    ncols = ceil(length(rx)/sps);
    Z = zeros(sps, ncols);
    for i=1:sps
        zz = downsample(rx, sps, d(i));
        Z(i,:) = [zz zeros(1, ncols-length(zz))];
    end

    % plotting correlations between polyphase signals
    P = [];
    pvecs = [];
    figure
    frame_size = 1024; overlap = 1000;
    xx = linspace(-1, 1, frame_size);
    for i=1:D
        pvec = real(avgXCF(Z(1,:), Z(i,:), frame_size, overlap, "Rect"));
        if shouldPlot
            plot(xx, real(pvec), 'DisplayName', "Estimate "+string(i-1))
            hold on
        end
        pp = mean(real(pvec));
        pvecs = [pvecs; pvec];
        P = [P; pp];
    end
    if shouldPlot
        legend
        grid on
        title("Spectral Correlation")
        xlabel("\omega/\pi")
    end
        
    % grid search for delays and power difference
    max_tot = 0;
    best_e = [0 0 0 0]; 
    for dd1 = 0:1:(sps-1)
        e1 = dd1/sps;
        for dd2 = 0:1:(sps-1)
            if dd1 == dd2
                break
            end
            e2 = dd2/sps;
            min_p = max(diff_est-1, 0);
            max_p = min(diff_est+1, 20);
            for pd = min_p:max_p
                a = 10^(-pd/10);
                r_est = a/(a+1);
                tot = 0;
                for i=1:D
                    h1 = H_eps.spectrum(frame_size, beta, e1, T);
                    h11 = H_eps.spectrum(frame_size, beta, e1-deltas(i), T);
                    h2 = H_eps.spectrum(frame_size, beta, e2, T);
                    h21 = H_eps.spectrum(frame_size, beta, e2-deltas(i), T);
                    x = real((1+np)*(r_est*h1.*conj(h11) + (1-r_est)*h2.*conj(h21)));
                    y = pvecs(i,:);
                    J = y*x'*inv(x*x')*x*y';
                    tot = tot + real(J);
                end
                if max_tot < tot
                    max_tot = tot;
                    best_e = [e1 e2 pd];
                end
            end
        end
    end
    e1 = best_e(1); e2 = best_e(2); pow_diff = best_e(3);
    if shouldPlot
        for i=1:D
            e1 = best_e(1); e2 = best_e(2);
            h1 = H_eps.spectrum(frame_size, beta, e1, T);
            h11 = H_eps.spectrum(frame_size, beta, e1-deltas(i), T);
            h2 = H_eps.spectrum(frame_size, beta, e2, T);
            h21 = H_eps.spectrum(frame_size, beta, e2-deltas(i), T);
            x = real((1+np)*(r_est*h1.*conj(h11) + (1-r_est)*h2.*conj(h21)));
            plot(xx, x, 'DisplayName', "True "+string(i-1))
            hold on
        end
    end
end