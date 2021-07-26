v = [];

% v = ["cfo" "7 snr=0" "13 snr=0" "7 snr=100" "13 snr=100";];
cfo = 0;
a = 0;
b = 0.00001;
r = (b).*rand(100,1);
r2 = (0.0001).*rand(100,1);
r3 = (0.001).*rand(100,1);
r4 = (0.01).*rand(100,1);
r = [r;r2;r3;r4];
for i =1:400
% 0 snr
data  = data_generation_25classes_cfo(500,0,cfo,1.6);
sig1 = data(:,7);
sig2 = data(:,13);
X1 = [real(sig1) imag(sig1)];
X2 = [real(sig2) imag(sig2)];
minPts=25;
%0.16 for 10
[a1,b1,c1] = optics(X1,minPts);
[a2,b2,c2] = optics(X2,minPts); 

s = [cfo mean(a1(c1)) mean(a2(c2))];
% 100 snr
data  = data_generation_25classes_cfo(500,100,cfo,1.6);
sig1 = data(:,7);
sig2 = data(:,13);
X1 = [real(sig1) imag(sig1)];
X2 = [real(sig2) imag(sig2)];
minPts=25;
%0.16 for 10
[a1,b1,c1] = optics(X1,minPts);
[a2,b2,c2] = optics(X2,minPts);
s = [s mean(a1(c1)) mean(a2(c2))];

v=[v;s;];
cfo = r(i)+cfo;

% xline = [1:1:500];
% figure()
% plot(xline,a1(c1));
% figure()
% plot(xline,a2(c2));
end
v

writematrix(v,'minPts25.csv') 
% figure()
% plot(a1(c1(2:end)));
% ylim([0 0.3]);
% figure()
% plot(a2(c2(2:end)));
% ylim([0 0.3]);
% xline = [1:1:100];
% figure()
% plot(xline,v1);
% hold on
% plot(xline,v2);