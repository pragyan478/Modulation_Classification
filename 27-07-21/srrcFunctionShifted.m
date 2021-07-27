% Function for Root Raised Cosine Filter including timing offset
% 
function [p,t,filtDelay] = srrcFunctionShifted(beta,sps,span,Offset)
Tsym=1;
t=-(((span)/2)+(Offset/sps)):1/sps:(((span)/2)+(Offset/sps));
%t=(t1+0.9);
num=sin((pi*t*(1-beta))/Tsym)+((4*beta*t/Tsym).*cos(pi*t*(1+beta)/Tsym));
den = (pi*t).*(1-(4*beta*t/Tsym).^2)/Tsym;
p=1/(sqrt(Tsym))*(num./den);
p(ceil(length(p)/2))=(1/sqrt(Tsym))*((1-beta)+4*beta/pi);
temp=(beta/sqrt(2*Tsym))*((1+(2/pi))*sin(pi/(4*beta))+(1-(2/pi))*cos(pi/(4*beta)));
p(t==Tsym/(4*beta))=temp;
p(t==-Tsym/(4*beta))=temp;
filtDelay=(length(p)-1)/2;
Energy=sum(p.^2);
p=p./sqrt(Energy);
% p=p(1:end-2*Offset);
% p=p(Offset+1:end-Offset);
% plot(p)
%     fvtool(p,'Analysis','impulse')
% 
% rrcFilter = rcosdesign(beta,span,sps);
%  hold on
%  fvtool(rrcFilter,'Analysis','impulse')
%  hold off
end
 

