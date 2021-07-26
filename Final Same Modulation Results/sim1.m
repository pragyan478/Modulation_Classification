v1 = [];
v2 = [];
for i=1:100
data  = data_generation_25classes_cfo(500,100,0.0032673,1.6);
sig1 = data(:,7);
sig2 = data(:,13);
X1 = [real(sig1) imag(sig1)];
X2 = [real(sig2) imag(sig2)];
minPts=15;
%0.16 for 10
[a1,b1,c1] = optics(X1,minPts);
[a2,b2,c2] = optics(X2,minPts);

% xline = [1:1:500];
% figure()
% plot(xline,a1(c1));
% figure()
% plot(xline,a2(c2));
v1 = [v1 mean(a1(c1))];
v2 = [v2 mean(a2(c2))];


end

xline = [1:1:100];
figure()
plot(xline,v1);
hold on
plot(xline,v2);
