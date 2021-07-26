j4 =[];
j8 =[];
j15 =[];
j16 =[];
j32 =[];
j64 =[];
for snr=25:35
    snr
i=0;
j_4=0;
j_8=0;
j_15=0;
j_16=0;
j_32=0;
j_64=0;
for i=1:100

data = data_generation_25classes(1000,snr);
sig1 = data(:,19);
X = [real(sig1), imag(sig1)];
E = evalclusters(X,'linkage','silhouette','KList',[4,8,15,16,32,64,128]);
if(E.OptimalK ==4)
  j_4=j_4+1;  
end
if(E.OptimalK ==8)
  j_8=j_8+1;  
end
if(E.OptimalK ==15)
  j_15=j_15+1;  
end
if(E.OptimalK ==16)
  j_16=j_16+1;  
end
if(E.OptimalK ==32)
  j_32=j_32+1;  
end
if(E.OptimalK ==64)
  j_64=j_64+1;  
end
end
j4 = [j4 j_4];
j8 = [j8 j_8];
j15 = [j15 j_15];
j16 = [j16 j_16];
j32 = [j32 j_32];
j64 = [j64 j_64];
end
sigma = [25:1:35];
figure(snr-24)
plot(sigma,j4)
hold on
plot(sigma,j8)
hold on
plot(sigma,j15)
hold on
plot(sigma,j16)
hold on
plot(sigma,j32)
hold on
plot(sigma,j64)
title('')
xlabel('snr')
ylabel('Frequency')
legend({'Cluster No. 4','Cluster No. 8','Cluster No. 15','Cluster No. 16','Cluster No. 32','Cluster No. 64'},'Location','eastoutside')