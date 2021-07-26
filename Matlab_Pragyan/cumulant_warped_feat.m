function [diff, best_est,ModOrder] = cumulant_warped_feat(x, snr_db, sps, span, beta)
    % CUMULANT_WARPED_FEAT
    % Function to detect modulation scheme and the difference in power
    % levels between the two streams in dB. If diff > 11dB, it means that
    % it is single carrier mode of operation. 
    %
    % This function requires the file "cum_dist.mat" to be present in the
    % same directory.
    %
    % Parameters:
    % x - (Complex) Raw Rx oversampled signal, with frequency offset of one
    % stream corrected.
    % snr_db - (Real) SNR estimate in dB
    % sps - oversampling rate of x
    % span - truncation length of the SRRC filter considered.
    % beta - roll off factor of filter (default 0.35)
    % 
    % Outputs:
    % diff - (Real) Difference in power level between two streams in dB.
    % best_est - (String) Estimate of Modulation scheme 

    overlap = 0;
    frame_size = span*sps;
    %%% constant calcs
    h = generate.get_srrc_filter(1, 0, beta, sps, span);
    c1 = sum(h.^4);
    c2 = 0;
    for mk = 0:(span)
        h = generate.get_srrc_filter(1, 0, beta, sps, span);
        g = generate.get_srrc_filter(1, mk*sps, beta, sps, span);
        c2 = c2 + sum((h.^2).*(g.^2));
    end
    c6 = sum(h.^8);
    c7 = 0;
    for mk = 0:(span)
        for lk = 0:(span)
            for nk = 0:(span)
                h = generate.get_srrc_filter(1, 0, beta, sps, span);
                g = generate.get_srrc_filter(1, mk*sps, beta, sps, span);
                f = generate.get_srrc_filter(1, lk*sps, beta, sps, span);
                e = generate.get_srrc_filter(1, nk*sps, beta, sps, span);
                c7 = c7 + sum((h.^2).*(g.^2).*(f.^2).*(e.^2));
            end
        end
    end

    %%%% averaging
	N = length(x);
    if rem(N,frame_size) > 0
		x = [x, zeros(1, frame_size - rem(N,frame_size))];
    end
	N = length(x);
    
    EX1_2X2_3 = zeros(1, frame_size);
    NN = floor(N/(frame_size - overlap));
	step = frame_size - overlap;
	i = 1;
    while i <= N - frame_size + 1
		EX1_2X2_3 = EX1_2X2_3  + abs(x(i:i+frame_size-1)).^6/NN;
		i = i + step;
    end
    
    
	EX1_2X2_2 = zeros(1, frame_size);
    NN = floor(N/(frame_size - overlap));
	step = frame_size - overlap;
	i = 1;
    while i <= N - frame_size + 1
		EX1_2X2_2 = EX1_2X2_2  + abs(x(i:i+frame_size-1)).^4/NN;
		i = i + step;
    end
    
    EX4 = zeros(1, frame_size);
    NN = floor(N/(frame_size - overlap));
	step = frame_size - overlap;
	i = 1;
    while i <= N - frame_size + 1
		EX4 = EX4  + (x(i:i+frame_size-1).^4)/NN; 
		i = i + step;
    end
    
    EX8 = zeros(1, frame_size);
    NN = floor(N/(frame_size - overlap));
	step = frame_size - overlap;
	i = 1;
    while i <= N - frame_size + 1
		EX8 = EX8  + (x(i:i+frame_size-1).^8)/NN; 
		i = i + step;
    end
    
    EX1_2 = zeros(1, frame_size);
    NN = floor(N/(frame_size - overlap));
	step = frame_size - overlap;
	i = 1;
    while i <= N - frame_size + 1
		EX1_2 = EX1_2  + x(i:i+frame_size-1).^2/NN;  
		i = i + step;
    end
    
    EX1X2 = zeros(1, frame_size);
    NN = floor(N/(frame_size - overlap));
	step = frame_size - overlap;
	i = 1;
    while i <= N - frame_size + 1
		EX1X2 = EX1X2  + abs(x(i:i+frame_size-1)).^2/NN;
		i = i + step;
    end
    
    EX1X2_4 = zeros(1, frame_size);
    NN = floor(N/(frame_size - overlap));
	step = frame_size - overlap;
	i = 1;
    while i <= N - frame_size + 1
		EX1X2_4 = EX1X2_4  + abs(x(i:i+frame_size-1)).^8/NN;
		i = i + step;
    end
    
    cum21 = EX1X2;
    snr = 10^(snr_db/10);
    cum21_hat = (cum21)*snr/(snr+1);
    test1 = abs(sum(EX1_2))/sum(cum21_hat);
    cum42 = EX1_2X2_2 - abs(EX1_2).^2 - 2*cum21.^2;
    
%     cum61 = EX1X2_61 - 5*EX1X2.*EX4;
%     cum80 = real(EX8 - 35*EX4.^2);
%     sum(cum80)
%     sum(cum21_hat.^4)
    C42_tilde = sum(cum42)/sum(cum21_hat.^2);
    thresh = 0.2;
    test2 = abs(sum(EX4))/sum(cum21_hat.^2);
    if abs(test1) > 0.5 - thresh
        A = C42_tilde/(-2*c1/c2);
        A = min(max(A, 0.5), 0.999);
        r1 = (A + sqrt(2*A - 1))/(1-A);
        diff = 10*log10(r1);
        best_est = "BPSK";
        ModOrder=2;
        return
    end
    if test2 < 0.02 %%% was 0.1 earlier, depends on N used!
        %%% 8PSK
        A = C42_tilde/(-c1/c2);
        A = max(A, 0.5);
        r1 = (A + sqrt(2*A - 1))/(1-A);
        diff = 10*log10(r1);
        best_est = "8PSK";
        ModOrder=8;
        return
    else
        %%% QPSK and 16QAM 
        cum63 = EX1_2X2_3 - 9*EX1_2X2_2.*EX1X2 +9*EX1X2.*abs(EX1_2).^2 + 12*EX1X2.^3;

        cum84 = EX1X2_4 - 16*EX1_2X2_3.*EX1X2 - 19*EX1_2X2_2.^2 ...
        + 148*EX1_2X2_2.*EX1X2.^2 - 148*EX1X2.^4; % insensitive to cfo

        C63_tilde = sum(cum63)/sum(cum21_hat.^3);
        C84_tilde = sum(cum84)/sum(cum21_hat.^4);

        max_lll = -Inf; best_est = "QPSK"; best_diff = 0;
        feature = [C42_tilde; C63_tilde; C84_tilde];

        load("cum_dist.mat"); %#ok<*LOAD>
        for diff_est = 0:17
            cov_qpsk = 1e4*[...
                c42_var(diff_est+1, 1) c42_63_cov(diff_est+1, 1) c42_84_cov(diff_est+1, 1); 
                c42_63_cov(diff_est+1, 1) c63_var(diff_est+1, 1) c63_84_cov(diff_est+1, 1); 
                c42_84_cov(diff_est+1, 1) c63_84_cov(diff_est+1, 1) c84_var(diff_est+1, 1); 
            ] + 1e-10*eye(3);
            cov_16qam = 1e4*[...
                c42_var(diff_est+1, 2) c42_63_cov(diff_est+1, 2) c42_84_cov(diff_est+1, 2); 
                c42_63_cov(diff_est+1, 2) c63_var(diff_est+1, 2) c63_84_cov(diff_est+1, 2); 
                c42_84_cov(diff_est+1, 2) c63_84_cov(diff_est+1, 2) c84_var(diff_est+1, 2); 
            ] + 1e-10*eye(3);
%             diff_est;

            bias_qpsk = [c42_m(diff_est+1, 1); c63_m(diff_est+1, 1); c84_m(diff_est+1, 1)];
            bias_16qam = [c42_m(diff_est+1, 2); c63_m(diff_est+1, 2); c84_m(diff_est+1, 2)];

            lll_qpsk =  -(feature-bias_qpsk)'*(inv(cov_qpsk))*(feature-bias_qpsk);
            lll_16qam = -(feature-bias_16qam)'*(inv(cov_16qam))*(feature-bias_16qam);

            if max_lll < lll_qpsk
                best_diff = diff_est;
                best_est = "QPSK";
                ModOrder=4;
                max_lll = lll_qpsk;
            end
            if max_lll < lll_16qam
                best_diff = diff_est;
                best_est = "16QAM";
                ModOrder=16;
                max_lll = lll_16qam;
            end    
        end
        diff = best_diff;
        r = 10^(diff/10);
        c__ = 1;
        if best_est == "16QAM"
            c__ = 13.9808;
        elseif best_est == "QPSK"
            c__ = 34;
        end
        % cross check hypothesis
        % assume large enough frequency offset
        test3 = abs(sum(EX8 - 35*EX4.^2))/sum(cum21_hat.^4);
        thresh_hyp_error = 1;
%         abs(test3*c7/c6/(r^4/(r + 1)^4) - c__)/c__ 
        if abs(test3*c7/c6/(r^4/(r + 1)^4) - c__)/c__ < thresh_hyp_error
            return
        else
            % 8QAM
            A = C42_tilde/(-0.667*c1/c2);
            A = min(max(A, 0.5), 0.99);
            r1 = (A + sqrt(2*A - 1))/(1-A);
            diff = 10*log10(r1);
            best_est = "8QAM";
            ModOrder=8;
            return
        end
    end
end

