N = 500;
cfo = [0.00001 0.00005 0.0001 0.0005 0.001];
%cfo = [0.0001];
avg_acc = [];
acc_1 = [];
acc_2= [];
acc_3 = [];
acc_8 = [];
acc_6 = [];
acc_7 = [];
acc_11 = [];
acc_12 = [];
acc_13 = [];
for e = 1:length(cfo)

fin = [];

%for N = 5000:5000:30000
fin_accu1 = [];
fin_accu2 = [];
fin_accu6 = [];
fin_accu7 = [];
fin_accu3 = [];
fin_accu8 = [];
fin_accu11 = [];
fin_accu12 = [];
fin_accu13= [];

for snr = 1:35
    accuracy_y1 = 0;
    accuracy_y7 = 0;
    accuracy_y6 = 0;
    accuracy_y2 = 0;
    accuracy_y3 = 0;
    accuracy_y8 = 0;
    accuracy_y11 = 0;
    accuracy_y12 = 0;
    accuracy_y13 = 0;
    for k = 1:100
        data = data_generation_25classes_cfo(N,snr,cfo(e),2);
        sig1 = data(:,1);
        sig7 = data(:,7);
        sig6 = data(:,6);
        sig2 = data(:,2);
        sig3 = data(:,3);
        sig8 = data(:,8);
        sig11 = data(:,11);
        sig12 = data(:,12);
        sig13 = data(:,13);

        
        c1 = algorithm(sig1);
        if c1==1
            accuracy_y1 = accuracy_y1 + 1;
        end
        
        c7 = algorithm(sig7);
        if c7==7
            accuracy_y7 = accuracy_y7 + 1;
        end
        
        c6 = algorithm(sig6);
        if c6==6
            accuracy_y6 = accuracy_y6 + 1;
        end
        
        c2 = algorithm(sig2);
        if c2==2
            accuracy_y2 = accuracy_y2 + 1;
        end
        c3 = algorithm(sig3);
        if c3==3
            accuracy_y3 = accuracy_y3 + 1;
        end
        c8 = algorithm(sig8);
        if c8==8
            accuracy_y8 = accuracy_y8 + 1;
        end
        c11 = algorithm(sig11);
        if c11==11
            accuracy_y11 = accuracy_y11 + 1;
        end
        c12 = algorithm(sig12);
        if c12==12
            accuracy_y12 = accuracy_y12 + 1;
        end
        c13 = algorithm(sig13);
        if c13==13
            accuracy_y13 = accuracy_y13 + 1;
        end
       
    end
    fin_accu1 = [fin_accu1 accuracy_y1];
    fin_accu2 = [fin_accu2 accuracy_y2];
    fin_accu6 = [fin_accu6 accuracy_y6];
    fin_accu7 = [fin_accu7 accuracy_y7];
    fin_accu3 = [fin_accu3 accuracy_y3];
    fin_accu8 = [fin_accu8 accuracy_y8];
    fin_accu11 = [fin_accu11 accuracy_y11];
    fin_accu12 = [fin_accu12 accuracy_y12];
    fin_accu13 = [fin_accu13 accuracy_y13];
    avg = (accuracy_y1+ accuracy_y7 + accuracy_y6 + accuracy_y2+ accuracy_y3+ accuracy_y8+ accuracy_y11+ accuracy_y12+ accuracy_y13)/9;
    fin = [fin, avg];
    snr
end
    avg_acc = [avg_acc;fin];
    acc_1 = [acc_1;fin_accu1];
    acc_2 = [acc_2;fin_accu2];
    acc_6= [acc_6;fin_accu6];
    acc_7 = [acc_7;fin_accu7];
    acc_3 = [acc_3;fin_accu3];
    acc_8 = [acc_8;fin_accu8];
    acc_11 = [acc_11;fin_accu11];
    acc_12 = [acc_12;fin_accu12];
    acc_13 = [acc_13;fin_accu13];
end
sigma = [1:1:35];
figure(1)
for i =1:length(cfo)
plot(sigma,avg_acc(i,:),'-o')
title(strcat('Average Accuracy N = ',num2str(N)))
xlabel('SNR')
ylabel('Accuracy(in %)')
hold on
grid on
end
legend({'CFO = 0.00001','CFO = 0.00005','CFO = 0.0001','CFO = 0.0005','CFO = 0.001'},'Location','southeast')
figure(2)
for i =1:length(cfo)
plot(sigma,acc_1(i,:),'-o')
title(strcat('BPSK-BPSK N = ',num2str(N)))
xlabel('SNR')
ylabel('Accuracy(in %)')
hold on
grid on
end
legend({'CFO = 0.00001','CFO = 0.00005','CFO = 0.0001','CFO = 0.0005','CFO = 0.001'},'Location','southeast')
figure(3)
for i =1:length(cfo)
plot(sigma,acc_2(i,:),'-o')
title(strcat('BPSK-QPSK N = ',num2str(N)))
xlabel('SNR')
ylabel('Accuracy(in %)')
hold on
grid on
end
legend({'CFO = 0.00001','CFO = 0.00005','CFO = 0.0001','CFO = 0.0005','CFO = 0.001'},'Location','southeast')
figure(4)
for i =1:length(cfo)
plot(sigma,acc_6(i,:),'-o')
title(strcat('QPSK-BPSK N = ',num2str(N)))
xlabel('SNR')
ylabel('Accuracy(in %)')
hold on
grid on
end
legend({'CFO = 0.00001','CFO = 0.00005','CFO = 0.0001','CFO = 0.0005','CFO = 0.001'},'Location','southeast')
figure(5)
for i =1:length(cfo)
plot(sigma,acc_7(i,:),'-o')
title(strcat('QPSK-QPSK N = ',num2str(N)))
xlabel('SNR')
ylabel('Accuracy(in %)')
hold on
grid on
end
legend({'CFO = 0.00001','CFO = 0.00005','CFO = 0.0001','CFO = 0.0005','CFO = 0.001'},'Location','southeast')


figure(6)
for i =1:length(cfo)
plot(sigma,acc_3(i,:),'-o')
title(strcat('BPSK-8PSK N = ',num2str(N)))
xlabel('SNR')
ylabel('Accuracy(in %)')
hold on
grid on
end
legend({'CFO = 0.00001','CFO = 0.00005','CFO = 0.0001','CFO = 0.0005','CFO = 0.001'},'Location','southeast')
figure(7)
for i =1:length(cfo)
plot(sigma,acc_8(i,:),'-o')
title(strcat('QPSK-8PSK N = ',num2str(N)))
xlabel('SNR')
ylabel('Accuracy(in %)')
hold on
grid on
end
legend({'CFO = 0.00001','CFO = 0.00005','CFO = 0.0001','CFO = 0.0005','CFO = 0.001'},'Location','southeast')
figure(8)
for i =1:length(cfo)
plot(sigma,acc_11(i,:),'-o')
title(strcat('8PSK-BPSK N = ',num2str(N)))
xlabel('SNR')
ylabel('Accuracy(in %)')
hold on
grid on
end
legend({'CFO = 0.00001','CFO = 0.00005','CFO = 0.0001','CFO = 0.0005','CFO = 0.001'},'Location','southeast')
figure(9)
for i =1:length(cfo)
plot(sigma,acc_12(i,:),'-o')
title(strcat('8PSK-QPSK N = ',num2str(N)))
xlabel('SNR')
ylabel('Accuracy(in %)')
hold on
grid on
end
legend({'CFO = 0.00001','CFO = 0.00005','CFO = 0.0001','CFO = 0.0005','CFO = 0.001'},'Location','southeast')
figure(10)
for i =1:length(cfo)
plot(sigma,acc_13(i,:),'-o')
title(strcat('8PSK-8PSK N = ',num2str(N)))
xlabel('SNR')
ylabel('Accuracy(in %)')
hold on
grid on
end
legend({'CFO = 0.00001','CFO = 0.00005','CFO = 0.0001','CFO = 0.0005','CFO = 0.001'},'Location','southeast')