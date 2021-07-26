v1= [];
v2=[];
for i=1:100
   data = data_generation_25classes_cfo(500,100,0,2);
   sig1= data(:,19);
   sig2= data(:,25);
   mom1 = hos(sig1,2,0);
   mom2 = hos(sig2,2,0);
   v1 = [v1 mom1];
   v2 = [v2 mom2];
end
sigma = [1:1:100];
figure()
plot(sigma,abs(v1));
hold on
plot(sigma,abs(v2));