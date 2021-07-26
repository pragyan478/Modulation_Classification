function[phase_max,phase_min]= compute_phase_amp(rxSig,RX_sample_rate, sps, F_est_final,Amp_est_final,mod)

% The E[X^4] or E[X^2] for ech modulation should be computed and
% compensated. This is still not part of the code. 

[~,ind]= max(Amp_est_final);
fmax= F_est_final(ind);
% first find the phase of the largest amplitude
DF = fmax*sps/(RX_sample_rate);
rxSig2 = exp(-1i*2*pi*DF*(1:length(rxSig))).*rxSig;

if(mod ==0)% QPSK,16 qam
    XX= rxSig2.^4; % This is because E[X^4] = -1 for QPSK and we are taking 4th power of it. 
    phase_max= exp(-1i*pi/4)*mean(XX)^(1/4); % I am not very sure why there
    % is a pi/4 shift.
end
if(mod==1)% BPSK
    XX= rxSig2.^2;
    phase_max= mean(XX)^(1/2);
end

if(mod == 2) %8psk
     XX= rxSig2.^8;
    phase_max= mean(XX)^(1/8);
end


% Then we find the phase of the smaller amplitude. 
[~,ind]= min(Amp_est_final);
fmin= F_est_final(ind);
% first find the phase of the largest amplitude
DF = fmin*sps/(RX_sample_rate);
rxSig2 = exp(-1i*2*pi*DF*(1:length(rxSig))).*rxSig;

if(mod ==0)
    YY= rxSig2.^4;
    phase_min= exp(-1i*pi/4)*mean(YY)^(1/4);
else
    YY= rxSig2.^2;
   phase_min=  mean(YY)^(1/2);
end

if(mod == 2)
    YY= rxSig2.^8;
    phase_min= mean(YY)^(1/8);
end



end