function [spec, main_cfo, fo, mod_est] = cfo(m_rx_t, dsf, frame_size, should_plot)
%CFO estimate CFO using 4th power method, estimates normalised CFO
%   m_rx_t      -> signal
%   order       -> power to raise the signal to (typically 4)
%   frame size  -> frame size for cfo estimation (typically 2048)
    order = 1;
    if dsf > 1
        m_rx_t = downsample(m_rx_t, dsf);
        m_rx_t = m_rx_t./mean(abs(m_rx_t).^2);
    end
    
    val = 0; mid = 0; ctr = 0;
    while val <= 5*mid && ctr < 3   % didn't find major peak
        ctr = ctr + 1;
        order = 2*order;
        [val, mid, spec, main_cfo, fo, pos] = cfo_aux(m_rx_t, dsf, order, frame_size);
        mod_est = order;
    end
    
    if should_plot
        figure
        f = linspace(-0.5/dsf , 0.5/dsf, frame_size);
        plot(f, spec, f(pos), spec(pos), 'r*');
        title("Order: "+string(order))
        ylabel("Magnitude (dB)")
        xlabel("Normalised frequency (f/f_s )")
        grid
        ax = gca; ax.FontSize=14;
    end
    
    
end

function [val, mid, spec, main_cfo, fo, pos] = cfo_aux(m_rx_t, dsf, order, frame_size)
   y = m_rx_t.^order;
    overlap = floor(frame_size/1000)*1000;
    spec = (powerSpecDen(y, frame_size, overlap, "Rect"));
    
    mid = median(spec);
    
    pos = islocalmax(spec, 'MaxNumExtrema', 2);
    f = linspace(-0.5 , 0.5, frame_size);
    
    [val, main_pos] = max(spec);
    main_cfo = f(main_pos)/order/dsf;
    fo = f(pos)/order/dsf;
        
    pows = spec(pos);
    if length(pows) > 1 && pows(1) < pows(2)
        fo = [fo(2) fo(1)];
    end
end