function [ModulationClass] = ModulationClassifier(beta,sps,span,Data)
% Data - Path to data file
%  size of complex (I + jQ) samples you want to analyze at a time. 
offset=1;
count=0;
d=0;
% f = fopen("D:\MATLAB\After 23 June 2020\MODEM_Data_Test\samples\A_8sps_64ksps_bpsk_symbolsync_0.35a_-10.iq", 'rb'); % change filename to whichever you want
f = fopen(Data, 'rb'); % change filename to whichever you want

iq_samples = fread (f, 'float'); % the entire file will be loaded onto memory. (Not an issue if RAM has around 500MB free space)
% If you do not want to load only the first N samples from the file, uncomment the following two lines
% num_i_q_samples = 1e6; % 1 Million I samples + Q samples => 500000 complex samples
% iq_samples = fread(f, num_i_q_samples, 'float');
% iq_samples=iq_samples(15000:end);
total_samples = length(iq_samples); % total number of I samples + Q samples
chunk = total_samples;
fclose(f);

%%%%%% We will be processing the data by the "chunk" 
t = reshape(iq_samples(offset : offset + chunk - 1), [2 chunk/2]).';
v = t(:,1) + 1j*t(:,2); % converting iq to complex number
[r, c] = size (v);
m_rx_t1 = reshape (v, c, r);

[rrcFilter,t] = srrcFunction(beta,sps,span);

N = 500;

data1 = conv(m_rx_t1,rrcFilter);
data = downsample(data1,sps);
data2 = data(500:end-500);
scatterplot(data2);
len = fix(length(data2)/2);
data3 = data2(len -N/2:len +N/2);
data3 = data3/sqrt(mean((abs(data3)).^2));
figure()
scatterplot(data3);
ModulationClass =  moments1(data3'); % returns 1 - BPSK-BPSK, 2 - QPSK-QPSK
ModulationClass
if(ModulationClass==1)
    fprintf('Class: BPSK-BPSK\n');
elseif(ModulationClass==2)
    fprintf('Class: QPSK-QPSK\n');
elseif(ModulationClass==3)
    fprintf('Class: 8PSK-8PSK\n');
elseif(ModulationClass==4)
    fprintf('Class: 16QAM-16QAM\n');
end
end