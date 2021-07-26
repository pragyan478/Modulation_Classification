% size of complex (I + jQ) samples you want to analyze at a time. 
chunk = 1e6;

f = fopen("../real_data/"+filename1, 'rb'); % change filename to whichever you want

iq_samples = fread (f, 'float'); % the entire file will be loaded onto memory. (Not an issue if RAM has around 500MB free space)
% If you do not want to load only the first N samples from the file, uncomment the following two lines
% num_i_q_samples = 1e6; % 1 Million I samples + Q samples => 500000 complex samples
% iq_samples = fread(f, num_i_q_samples, 'float');

total_samples = length(full); % total number of I samples + Q samples
fclose(f);

%%%%%% We will be processing the data by the "chunk" 
t = reshape(iq_samples(offset : offset + 2*chunk - 1), [2 chunk]).';
v = t(:,1) + 1j*t(:,2); % converting iq to complex number
[r, c] = size (v);
m_rx_t1 = reshape (v, c, r); % this is the received signal, it has "chunk" number of complex samples.
% can process m_rx_t as the complex signal received

% depending on "sps", there will be "sps" samples per symbol. 
% sps = Tsymbol/Tsampling = Fsampling/Fsymbol = Fsampling * log2(M) / Bitrate