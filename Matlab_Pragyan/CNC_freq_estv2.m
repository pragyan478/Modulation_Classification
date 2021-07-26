%% function to find the frequence estiamtes of the two signals
% Author: Radha Krishna Ganti
% Motivated by the following papers.
% On-Data-Aided Feedforward Carrier Frequency Offset Estimators for QAM Constellations:
% A Nonlinear Least-Squares Approach
%
% Basic idea is that only 4th power E[X^4] is not equal to zero.
% E[X^3]= E[X^2] = E[X^1] = 0. We use this fact even for CNC these hold
% true.
% JOINT INDENTIFICATION OF CONFLECTED SIGNALS IN NON-COOPERATIVE DIGITAL TELECOMMUNICATIONS
% We use both pow4 and pow8 methods.
%
% Important:
% [F_final,Amp_final,Mod]=CNC_freq_est(rxSig,rrcFilter3,sps)
%  SPS is the oversample factor.
%  rxSig is the RX signal without any matched filtering done.
%  Make sure that rrcFilter3 is beta of 1. It seems to work the best
% Mod is 0 if it is '16 or 4-QAM' and 1 otherwise (BPSK and 8-QAM)
% [Caveats]:
%
function[F_final,Amp_final,Mod]=CNC_freq_estv2(rxSig,RX_sample_rate, sps,resolution)

% % Matched filtering
Amp_final=[];
F_final=[];
Mod=[];
% rxFilt = rxSig;% upfirdn(rxSig , flip(rrcFilter3),1,sps);
%% We first do power 2.
% This is mainly to estimate BPSK and 8-QAM (will work
% for 10 dB amplitude difference.
% If it gives two outputs (frequencies), then they are the correct values.
% If it gives only one value, then the amplitude difference is very large
% or it could not resolve the two frequencies.
% If it gives no values or a lot of values. Then we move to other modulations
% do.
[f_est2,Amp_final2] = power2_est(rxSig,RX_sample_rate,sps,4,resolution);
no_2 = length(f_est2);
[f_est4,Amp_final4 ]= power4_est(rxSig,RX_sample_rate,sps,6,resolution);
no_4 = length(f_est4);
[f_est8,Amp_final8 ]= power8_est(rxSig,RX_sample_rate,sps,6,resolution);
no_8 = length(f_est8);

Mod = 0;%'16 or 4-QAM';

if (no_2  == 2)
    F_final =f_est2;
    Amp_final= Amp_final2;
    Mod = 1;%'BPSK or 8-QAM';
else
    if(no_2 == 1) % Bad luck we cannot resove it.
        F_final =[];
        Amp_final= [];
        Mod = 3;%'BPSK or 8-QAM';
    else % It is other modulations
        if(no_4 ==2)
            F_final =f_est4;
            Amp_final= Amp_final4;
            Mod =0 ; %4/16 qam
        else
            if(no_4 ==1) % require power 8.
                if(no_8==2) % We require two outputs in power 8
                    % Observe that in pow8, we see two peaks. One would correspond to a^8
                    % and the other coressponds to 70*a^4*b^4. (70 is 8C4).
                    % Here we use the one peak found in the pow4 and the two peaks in pow8.
                    % One of the peak in pow8 should coincide in frequency to the peak in
                    % pow4.
                    % We find the minimum distance point to the estimated frequency in 4 so
                    % that we can identify the common frequency
                    [~,ind]=min(abs(f_est8-f_est4));
                    f1_est = f_est8(ind);
                    ind2 = setdiff([1,2],ind);
                    
                    % We find the auto correlation of pow8
                    % we find the other frequency by using the fact that
                    %Observe that in pow8, we see two peaks. One would correspond to a^8
                    % and the other coressponds to 70*a^4*b^4. (70 is 8C4).
                    f2_est = (f_est8(ind2)*8 - 4*f1_est)/4;
                    %f2_est3 = (f1_est*8 - 4*f_est8(ind2))/4;
                    F_final =[f1_est ;f2_est];
                    a = Amp_final8(ind);
                    x = Amp_final8(ind2);
                    b = (sqrt(x))/a/(70^(1/16));
                    
                    % Not sure about this logic.
                    Amp_final = ([ 1,0.1]);
                    Mod =0 ; %4/16 qam
                else
                    F_final =[];
                    Amp_final= [];
                    Mod = 3;% 'Not detected';
                end
            else % PSK mod
                if(no_8==2)
                 F_final =f_est8;
                 Amp_final= Amp_final8;
                 Mod = 2;%'8-PSK';
                else
                 F_final = f_est8;
                 Amp_final= Amp_final8;
                 Mod = 2;
                end
            end
            
        end
        
    end
end

F_final= F_final/2;
end

%% Power 2 estimation

function[f_est2,Amp_final2 ]= power2_est(rxSig,RX_sample_rate,sps,no_std,resolution)
% The no_std has to be choosen by trail and error.
pow2 = rxSig(100:end).^2;
XX2= pow2;
% This can resolve RX_sample_rate/(SPS*100000*2);
[p2,f2]=pspectrum(XX2, 'FrequencyResolution',pi/resolution);
f2=f2/pi;

p2_log = 10*log10(abs(p2));
threshold2_log = mean(p2_log)+no_std*std(p2_log);

INDP2= find(p2_log > threshold2_log);
if(length(INDP2) >3) %find pea
    
    INDf2 = f2(INDP2);
    [~,locs2]=findpeaks( p2_log(INDP2));
    %vals2 = p2(INDP2(locs2));
    
    F2_est=mod(INDf2(locs2)+2,2);
    % Finding the frequencies
    f_est2 = (RX_sample_rate )*F2_est/(2*sps);
    % Now finding the actual powers.
    
    inds2= INDP2(locs2);
    ener2=[];
    for m=1:length(inds2)
        ener2=[ener2 sum(p2(inds2(m) + [-10:1:10]))];
    end
    Amp_final2 = ener2.^(1/2);% Since the amplitudes are a^2 and b^2.
else
    f_est2 =[];
    Amp_final2 =[];
end
end

%% Power 4 estimation
function[f_est4,Amp_final4 ]= power4_est(rxSig,RX_sample_rate,sps,no_std,resolution)
pow4 = rxSig(100:end).^4;
XX= pow4;
% Finding the correlatioin of the sequence pow4 usign FFT. Here we just
% use the closest power of 2 number of samples so that it is efficient.
NF = 2^floor(log2(length(XX)));
seqA = XX(1:NF);
seqB = [XX(1:NF/2) zeros(1,NF/2)];
temp=ifft(fft(seqA).*conj(fft(seqB)));
cor_xx= temp/(NF/2);

% Here we find the power spectrum of the correllation. If all is well we should
% see two peaks.
[p4,f4]=pspectrum(cor_xx,'FrequencyResolution',pi/resolution);
f4 = f4/pi;

% Finding the threshold fo that peaks can be identified. We do the
% thresholding in the log domain since the peaks are more prominent.
p4_log = 10*log10(p4);
threshold4_log = mean(p4_log)+no_std*std(p4_log);

INDP4= find(p4_log > threshold4_log);
INDf4 = f4(INDP4);
if(length(INDP4) >3) %find pea
    
    [~,locs4]=findpeaks(p4(INDP4));
    vals4 = p4(INDP4(locs4));
    [Bcb4,ICI4]= sort(vals4,'descend');
    inds4= INDP4(locs4);
    
    F1_est=mod(INDf4(locs4)+2,2);
    % Finding the frequencies
    f_est4 =  (RX_sample_rate )*F1_est/(4*sps);
    
    % We now find the power in each tap. We cant just sqaure the maximum peaks
    % as there will be spectral leakage (sinc). So we sum up the neighbouring taps
    % also so that we get accurate power.
    ener4=[];
    for m=1:length(inds4)
        ener4=[ener4 sum(p4(inds4(m) + [-10:1:10]))];
    end
    
    Amp_final4= ener4.^(1/8); % 1/8 is because there is a square in the correlation in addition to power4
else
    f_est4=[];
    Amp_final4=[];
end

end

%% Power 8 estimation
function[f_est8,Amp_final8 ]= power8_est(rxSig,RX_sample_rate,sps,no_std,resolution)

% We find the auto correlation of pow8
pow8 = rxSig(100:end).^8;%.^(-16);
XX= pow8;


% Finding the correlatioin of the sequence pow4 usign FFT. Here we just
% use the closest power of 2 number of samples so that it is efficient.
NF = 2^floor(log2(length(XX)));
seqA = XX(1:NF);
seqB = [XX(1:NF/2) zeros(1,NF/2)];
temp=ifft(fft(seqA).*conj(fft(seqB)));
cor_xx= temp/(NF/2);

[p8,f8]=pspectrum(cor_xx,'FrequencyResolution',pi/resolution);
f8 = f8/pi;
p8_log = 10*log10(p8);

% Here we find the spectrum of the correllation. If all is well we should
% see two peaks.
threshold8 = mean(p8_log)+no_std*std(p8_log);
INDP8= find(p8_log > threshold8);
INDf8 = f8(INDP8);
if(length(INDP8) >3) %find pea
    
    [~,locs8]=findpeaks(p8(INDP8));
    vals8 = p8(INDP8(locs8));
    
    locs8_final= locs8;
    inds8= INDP8(locs8);
    ener8=[];
    for m=1:length(inds8)
        ener8=[ener8 sum(p8(inds8(m) + [-10:1:10]))];
    end
    f_est8= RX_sample_rate*mod(INDf8(locs8_final)+2,2)/(8*sps);
    Amp_final8 = ener8.^1/16;% 1/16 is because there is a square in the correlation in addition to power4
else
    f_est8=[];
    Amp_final8=[];
end


end