v = [];

cfo = 0.0002355;
threshold = 0.15;
minPts=5;
for i =1:30
% 0 snr
acc1=0;
acc2=0;


for j=1:100
%0.16 for 10 


data  = data_generation_25classes_cfo(500,100,cfo,1.6);
sig1 = data(:,7);
sig2 = data(:,13);
X1 = [real(sig1) imag(sig1)];
X2 = [real(sig2) imag(sig2)];

%0.16 for 10

[a1,b1,c1] = optics(X1,minPts);
[a2,b2,c2] = optics(X2,minPts);
% mean(a1(c1(2:end)))
if(mean(a1(c1))<threshold)
    acc1 = 1+acc1;
end
if(mean(a2(c2))>threshold)
    acc2 = 1+acc2;
end
% s = [s mean(a1(c1(2:end))) mean(a2(c2(2:end)))];
end
v=[v (acc1+acc2)/2];

minPts = minPts+1;
end
sigma = [];
t=5;
for i=1:30
   sigma = [sigma t];
   t = t+1;
end
figure()
plot(sigma,v);
xlabel('minPts,threshold = 0.15');
ylabel('Average Accuracy');
