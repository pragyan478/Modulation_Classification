%function avg = acc(N)
N = 500;
%cfo = [0.0001 0.0005 0.001 0.005 0.01];
%scale = [1.2 1.4 1.6 1.8 2.0 2.2];
% cfo = [0.01 0.005 0.001];
% t1 = [0.5 0.5185 0.5404];
% t2 =[15.1766 14.023 8.576];
% t3 = [.5684 .4095 0.2975];
cfo = [0.001];
t1 = [0.5404];
t2 =[8.576];
t3 = [.2975];
%t1 = [4.8 4.1537 4.3443];
%t2 = [0.17 0.227 0.1464]
avg_acc = [];
acc_1 = [];
acc_7 = [];
acc_13 = [];
acc_19 = [];
acc_25 = [];
for e = 1:length(cfo)

fin = [];

%for N = 5000:5000:30000
fin_accu1 = [];
fin_accu7 = [];
fin_accu13 = [];
fin_accu19 = [];
fin_accu25 = [];
for snr = 5:35
    accuracy_y1 = 0;
    accuracy_y7 = 0;
    accuracy_y13 = 0;
    accuracy_y19 = 0;
    accuracy_y25 = 0;
    for k = 1:100
        data = data_generation_25classes_cfo(N,snr,cfo(e),1.6);
        sig1 = data(:,1);
        sig7 = data(:,7);
        sig13 = data(:,13);
        sig19 = data(:,19);
        sig25 = data(:,25);
        
        c1 = class_5_final_9(sig1,t1(e),t2(e),t3(e));
        if c1==1
            accuracy_y1 = accuracy_y1 + 1;
        end
        
        c7 = class_5_final_9(sig7,t1(e),t2(e),t3(e));
        if c7==7
            accuracy_y7 = accuracy_y7 + 1;
        end
        
        c13 = class_5_final_9(sig13,t1(e),t2(e),t3(e));
        if c13==13
            accuracy_y13 = accuracy_y13 + 1;
        end
        
        c19 = class_5_final_9(sig19,t1(e),t2(e),t3(e));
        if c19==19
            accuracy_y19 = accuracy_y19 + 1;
        end
        
        c25 = class_5_final_9(sig25,t1(e),t2(e),t3(e));
        if c25==25
            accuracy_y25 = accuracy_y25 + 1;
        end
    end
    fin_accu1 = [fin_accu1 accuracy_y1];
    fin_accu7 = [fin_accu7 accuracy_y7];
    fin_accu13 = [fin_accu13 accuracy_y13];
    fin_accu19 = [fin_accu19 accuracy_y19];
    fin_accu25 = [fin_accu25 accuracy_y25];
    avg = (accuracy_y1+ accuracy_y7 + accuracy_y13 + accuracy_y19+accuracy_y25)/5;
    fin = [fin, avg];
    snr
end
    avg_acc = [avg_acc;fin];
    acc_1 = [acc_1;fin_accu1];
    acc_7 = [acc_7;fin_accu7];
    acc_13 = [acc_13;fin_accu13];
    acc_19 = [acc_19;fin_accu19];
    acc_25 = [acc_25;fin_accu25];
end
sigma = [5:1:35];
figure(1)

for i =1:length(cfo)
plot(sigma,avg_acc(i,:),'-o')
title(strcat('Average Accuracy N = ',num2str(N)))
xlabel('SNR')
ylabel('Accuracy(in %)')
hold on
grid on
ylim([0 100])
end
legend({'CFO = 0.01','CFO = 0.005','CFO = 0.001'},'Location','southeast')
figure(2)

for i =1:length(cfo)
plot(sigma,acc_1(i,:),'-o')
title(strcat('BPSK-BPSK N = ',num2str(N)))
xlabel('SNR')
ylabel('Accuracy(in %)')
hold on
grid on
ylim([0 100])
end
legend({'CFO = 0.01','CFO = 0.005','CFO = 0.001'},'Location','southeast')
figure(3)

for i =1:length(cfo)
plot(sigma,acc_7(i,:),'-o')
title(strcat('QPSK-QPSK N = ',num2str(N)))
xlabel('SNR')
ylabel('Accuracy(in %)')
hold on
grid on
ylim([0 100])
end
legend({'CFO = 0.01','CFO = 0.005','CFO = 0.001'},'Location','southeast')
figure(4)

for i =1:length(cfo)
plot(sigma,acc_13(i,:),'-o')
title(strcat('8PSK-8PSK N = ',num2str(N)))
xlabel('SNR')
ylabel('Accuracy(in %)')
hold on
grid on
ylim([0 100])
end
legend({'CFO = 0.01','CFO = 0.005','CFO = 0.001'},'Location','southeast')
figure(5)

for i =1:length(cfo)
plot(sigma,acc_19(i,:),'-o')
title(strcat('8QAM-8QAM N = ',num2str(N)))
xlabel('SNR')
ylabel('Accuracy(in %)')
hold on
grid on
ylim([0 100])
end
legend({'CFO = 0.01','CFO = 0.005','CFO = 0.001'},'Location','southeast')
figure(6)

for i =1:length(cfo)
plot(sigma,acc_25(i,:),'-o')
title(strcat('16QAM-16QAM N = ',num2str(N)))
xlabel('SNR')
ylabel('Accuracy(in %)')
hold on
grid on
ylim([0 100])
end
legend({'CFO = 0.01','CFO = 0.005','CFO = 0.001'},'Location','southeast')