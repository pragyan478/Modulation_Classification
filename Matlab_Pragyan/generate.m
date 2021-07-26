
classdef generate
    methods(Static)
        function arr = generateGrayarr(n)
            %{
                This function generates all n bit Gray  
                codes and prints the generated codes 
            %}
            % base case 
            if (n <= 0)
                return
            end
            % 'arr' will store all generated codes 
            % start with one-bit pattern 
            arr = ["0", "1"];

            % Every iteration of this loop generates  
            % 2*i codes from previously generated i codes. 
            i = 2;
            j = 1;
            while true
                if i >= bitshift(1, n)
                    break
                end
                % Enter the previously generated codes  
                % again in arr[] in reverse order.  
                % Nor arr[] has double number of codes. 
                for j = i : -1 : 1 
                    arr = [arr, arr(j)]; 
                end
                % append 0 to the first half 
                for j = 1:i
                    arr(j) = "0" + arr(j); 
                end
                % append 1 to the second half 
                for j = i+1:2*i
                    arr(j) = "1" + arr(j); 
                end
                i = bitshift(i, 1);
            end
        end

        function [SYMBOLS, gray_map, rev_gray_map] = generate_symbols(Pi, scheme)
            %{
                Generates complex zero mean symbols. 
                Pi --> Input Power 
                constellation_size
                scheme --> QAM/PSK

                returns:
                symbols, symbol_to_bit_gray_map, reverse_bit_to_symbol_map
            %}
            if contains(lower(scheme), 'qpsk')
                scheme = "4QAM";
            end
            if contains(lower(scheme), '8qam')
                SYMBOLS = [1+sqrt(3), (1+1j), 1j*(1+sqrt(3)), (-1+1j),...
                    -(1+sqrt(3)), (-1-1j), -1j*(1+sqrt(3)), (1-1j)];
                SYMBOLS = SYMBOLS - mean(SYMBOLS);
                SYMBOLS = SYMBOLS*(sqrt(Pi))/sqrt(mean(abs(SYMBOLS).^2));
            elseif contains(lower(scheme), 'qam')
                mQAM = str2num(regexp(scheme,['\d+'],'match'));
                SYMBOLS = [];
                for i = 0:sqrt(mQAM)-1
                    for j = 0:sqrt(mQAM)-1
                        SYMBOLS = [SYMBOLS, complex(i,j)];
                    end
                end
                SYMBOLS = SYMBOLS - sum(SYMBOLS)/mQAM;
                SYMBOLS = SYMBOLS*(sqrt(Pi))/sqrt(mean(abs(SYMBOLS).^2));
                gray_code = generate.generateGrayarr(ceil(log2(mQAM))/2);
                gray_map = containers.Map;
                for i=0:sqrt(mQAM)-1
                    for j=0:sqrt(mQAM)-1
                       gray_map(num2str(SYMBOLS(j+sqrt(mQAM)*i+1))) = gray_code(i+1) + gray_code(j+1);
                    end
                end
                rev_gray_map = containers.Map;
                for i=keys(gray_map)
                    v = gray_map(i{1});
                    rev_gray_map(v(1)) = str2num(i{1});
                end
            elseif contains(lower(scheme), 'bpsk')
                SYMBOLS = [];
                for i = 0:1
                    SYMBOLS = [SYMBOLS, i];
                end
                SYMBOLS = SYMBOLS - sum(SYMBOLS)/2;
                SYMBOLS = SYMBOLS*(sqrt(Pi))/sqrt(mean(abs(SYMBOLS).^2));
                gray_code = generate.generateGrayarr(1);
                gray_map = containers.Map;
                for i=0:1
                    gray_map(num2str(SYMBOLS(i+1))) = gray_code(i+1);
                end
                rev_gray_map = containers.Map;
                for i=keys(gray_map)
                    v = gray_map(i{1});
                    rev_gray_map(v(1)) = str2num(i{1});
                end
            elseif contains(lower(scheme), '8psk')
                SYMBOLS = [];
                for i = 0:7
                    SYMBOLS = [SYMBOLS, exp(1j*pi*i/4 + 1j*pi/8)];
                end
                SYMBOLS = SYMBOLS - sum(SYMBOLS)/2;
                SYMBOLS = SYMBOLS*(sqrt(Pi))/sqrt(mean(abs(SYMBOLS).^2));
                gray_code = generate.generateGrayarr(7);
                gray_map = containers.Map;
                for i=1:8
                    gray_map(num2str(SYMBOLS(i))) = gray_code(i);
                end
                rev_gray_map = containers.Map;
                for i=keys(gray_map)
                    v = gray_map(i{1});
                    rev_gray_map(v(1)) = str2num(i{1});
                end
            end
         end


         function  [pulse_shape, pulse_delay_in_samples] = get_srrc_filter(Ts, delay, alpha, sps, span)
            % Normalised filter
            % delay as a fraction of Ts, 0 <= del <= sps-1
            pulse_duration = linspace(-span*Ts/2 - delay*Ts/sps, span*Ts/2 - delay*Ts/sps, span*sps+1);
            pulse_shape = func.srrc(pulse_duration, alpha, Ts);
            pulse_shape = pulse_shape/sqrt(sum(abs(pulse_shape).^2));
            pulse_delay_in_samples = floor(length(pulse_duration)/2);
         end
         
         function  [pulse_shape, pulse_delay_in_samples] = get_rc_filter(Ts, alpha, sps, span)
            pulse_duration = linspace(-span*Ts/2, span*Ts/2, span*sps+1);
            pulse_shape = func.rc(pulse_duration, alpha, Ts);
            pulse_delay_in_samples = floor(length(pulse_duration)/2);
         end
    
         function [m_rx_t] = generate_rx_signal(mod_scheme, N, Ts, Tsampling, Nsym, true_roll_off, snr_db, freq_shift)
            % mod_scheme: string - modulation scheme
            % N: number of symbols observed
            % Ts: True symbol period (units of time) unknown to receiver.
            % Tsampling: Set sampling time, This is at the receiver's side. (init of time)
            % Nsym: number of overlapping symbols with pulse shape
            % true_roll_off: true_roll_off
            % snr_db: required SNR in dB
            % freq_shift: Frequency shift in Hz

            % Because sampling time is Ts/sps
            sps = Ts/Tsampling;	% samples per symbol, unknown to receiver.

            SYMBOLS = generate.generate_symbols(1, mod_scheme);

            noise_power = 10^(-snr_db/10)/sps;
            
            x = zeros(1,N);
            for i=1:N
                x(i) = SYMBOLS(floor(rand()*length(SYMBOLS)) + 1);
            end

            [up, down] = rat(sps);
            
            % upsampling 
            upsampled_x = zeros(1,up*N);
            for i=1:N
                upsampled_x(up*(i-1)+1) = x(i);
            end

            pulse_shape = generate.get_srrc_filter(Ts,0, true_roll_off, up, Nsym);
                        
            % message signal in baseband
            m_t = conv(upsampled_x, pulse_shape);
            
            if down ~= 1
                m_t1 = zeros(1, floor(length(m_t)/down));
                for i=0:length(m_t1)-1
                    m_t1(i+1) = m_t(down*i + 1);
                end
                m_t = m_t1;
            end
            
            t = linspace(0, (length(m_t)-1)*Tsampling, length(m_t));
            % adding Gaussian circular noise in baseband
            stdev = sqrt(noise_power/2);
            f = freq_shift/Tsampling;
            complex_freq_mod = exp(1j*2*pi*f*t);            
            m_rx_t = complex_freq_mod.*m_t + complex(stdev*randn(1, length(m_t)), stdev*randn(1, length(m_t)));
         end
    end
end

