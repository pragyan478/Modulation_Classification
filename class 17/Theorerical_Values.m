theta1 = pi/2;
theta2 =0;
% theta1 =0;
theta2 = 0;
%BPSK-BPSK
% m1 = [-1 1];
% m2 = [-1 1];
% 8PSK-8PSK
%m1 = exp(1j*theta1)*[1 -1 1j -1j cos(pi/4)+1j*sin(pi/4) cos(-pi/4)+1j*sin(-pi/4) cos(-pi/4)+1j*sin(pi/4) cos(3*pi/4)+1j*sin(3*pi/4)];
%m2 = exp(1j*theta2)*[1 -1 1j -1j cos(pi/4)+1j*sin(pi/4) cos(-pi/4)+1j*sin(-pi/4) cos(-pi/4)+1j*sin(pi/4) cos(3*pi/4)+1j*sin(3*pi/4)];
%8QAM-8QAM
m1 = 2*[1+1j 1+3*1j 1-1j 1-3*1j -1+1j -1+3*1j -1-1j -1-3*1j].*exp(1j*theta1);
m2 = [1+1j 1+3*1j 1-1j 1-3*1j -1+1j -1+3*1j -1-1j -1-3*1j].*exp(1j*theta2);
% % 16QAM-16QAM
% m1 = exp(1j*theta1)*[1+1j 1+3*1j 1-1j 1-3*1j -1+1j -1+3*1j -1-1j -1-3*1j 3+1j 3+3*1j 3-1j 3-3*1j -3+1j -3+3*1j -3-1j -3-3*1j];
% m2 = exp(1j*theta2)*[1+1j 1+3*1j 1-1j 1-3*1j -1+1j -1+3*1j -1-1j -1-3*1j 3+1j 3+3*1j 3-1j 3-3*1j -3+1j -3+3*1j -3-1j -3-3*1j];


k = 2;
m1 = m1/sqrt(mean((abs(m1)).^2));
m2 = m2/sqrt(mean((abs(m2)).^2));
y = [];
for i = 1:length(m1)
   for j =1:length(m1)
      y = [y m1(i)+m2(j)]; 
   end
end
(mean((abs(y)).^2))
y = y/sqrt(mean((abs(y)).^2));

% p = sym('p');
% q = sym('q');
hos(y,2,0)
