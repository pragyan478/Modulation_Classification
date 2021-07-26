function [diff, best_est,fo] = cnc_modu_classifier_ideal(m_rx_t, beta, sps, snr, span,chunk)
%     f = fopen(filename, 'rb'); % change filename to whichever you want
%     full = fread (f, 'float'); % the entire file will be loaded onto memory. 
%     total_samples = length(full); % total number of samples I + Q
   % chunk = 5e6;
    dsf = 1;
%     fclose(f);
m_rx_t = m_rx_t(1:chunk);
%     %%%%%% We will be processing the data by the "chunk" 
% 
%     t = reshape(full(1:chunk), [2 chunk/2]).';
%     v = t(:,1) + 1j*t(:,2);
%     [r, c] = size (v);
%     m_rx_t = reshape (v, c, r); % this is the received signal, it has "chunk" number of complex samples.
%     % can process m_rx_t as the complex signal received
%     if dsf ~= 1
%         m_rx_t = downsample(m_rx_t, dsf);
%     end


    %%%% CFO ESTIMATION - m_rx_t needs to be frequency compensated for one
    %%%% carrier
    [~, fo] = cfo(m_rx_t, sps*2, 2^15, false);
    m_rx_t = m_rx_t .* exp(-1j*2*pi*fo*(0:(length(m_rx_t)-1)));

    %%%% Classification
    [diff, best_est] = cumulant_warped_feat(m_rx_t(1:2e5), snr, sps, span, beta);
   
end

