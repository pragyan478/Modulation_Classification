function [symbol_rate] = symbol_rate_estimate_r1(rxSig, sampling_rate, BW)


ratio = ceil(1.25*sampling_rate/BW);
%factor = ceil(sampling_rate/1e3);

%rxSig2 = resample(rxSig,factor,1);
corr = CNC_cross_corr(rxSig,200);
% Go to a sampling rate corresponding to a resolution of 0.1 KHz. 
factor = ceil(sampling_rate/1e3);

rs_sig = resample(corr,factor,1);
[~,ind_base]= max(abs(rs_sig));

YY = rs_sig(ind_base+(0:ratio*factor));
[~,ind] = min(YY);
symbol_rate = round(sampling_rate*factor/ind/1e3)*1e3;
% x=1:length(corr);
% y= abs(corr);
% xx=1:1/factor:length(corr);
% yy = spline(1:length(corr),abs(corr),xx);
% DD =yy(1: ratio*factor);
%  
% [~,ind] = min(DD);
%freq = ind* sampling_rate*factor;


end