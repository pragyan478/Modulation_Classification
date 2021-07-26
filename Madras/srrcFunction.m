% Function for Root Raised Cosin Filter
% span=20;
% sps=10;
% % beta=0.35;
function [p,t,filtDelay] = srrcFunction(beta,sps,span)
Tsym=1;
t=-((span)/2):1/sps:((span)/2);
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

% fvtool(p,'Analysis','impulse')
end
 


 
% Function for Root Raised Cosin Filter
%span=20;
%sps=10;
%beta=0.35;
% function [p,t,filtDelay] = srrcFunction(beta,sps,span,offset)
% Tsym=1;
% t=-((span)/2)-(offset/sps):1/sps:((span)/2)+(offset/sps);
% num=sin((pi*t*(1-beta))/Tsym)+((4*beta*t/Tsym).*cos(pi*t*(1+beta)/Tsym));
% den = (pi*t).*(1-(4*beta*t/Tsym).^2)/Tsym;
% p=1/(sqrt(Tsym))*(num./den);
% p(ceil(length(p)/2))=(1/sqrt(Tsym))*((1-beta)+4*beta/pi);
% temp=(beta/sqrt(2*Tsym))*((1+(2/pi))*sin(pi/(4*beta))+(1-(2/pi))*cos(pi/(4*beta)));
% p(t==Tsym/(4*beta))=temp;
% p(t==-Tsym/(4*beta))=temp;
% filtDelay=(length(p)-1)/2;
% Energy=sum(p.^2);
% p=p./sqrt(Energy);
% end
