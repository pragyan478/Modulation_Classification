%function avg = acc(N)
N = 1000;

fin = [];

%for N = 5000:5000:30000
fin_accu1 = [];
fin_accu2 = [];
fin_accu3 = [];
fin_accu4 = [];
fin_accu5 = [];
fin_accu6 = [];
fin_accu7 = [];
fin_accu8 = [];
fin_accu9 = [];
fin_accu10 = [];
fin_accu11 = [];
fin_accu12 = [];
fin_accu13 = [];
for snr = 1:35
    accuracy_y1 = 0;
    accuracy_y2 = 0;
    accuracy_y3 = 0;
    accuracy_y4 = 0;
    accuracy_y5 = 0;
    accuracy_y6 = 0;
    accuracy_y7 = 0;
    accuracy_y8 = 0;
    accuracy_y9 = 0;
    accuracy_y10 = 0;
    accuracy_y11 = 0;
    accuracy_y12 = 0;
    accuracy_y13 = 0;
    
    for k = 1:100
        data = data_generation_25classes_new(N,snr);
        sig1 = data(:,1);
        sig2 = data(:,2);
        sig3 = data(:,3);
        sig4 = data(:,4);
        sig5 = data(:,5);
        sig6 = data(:,6);
        sig7 = data(:,7);
        sig8 = data(:,8);
        sig9 = data(:,9);
        sig10 = data(:,10);
        sig11 = data(:,11);
        sig12 = data(:,12);
        sig13 = data(:,13);
        
        c1 = class_19(sig1);
        if c1==1
            accuracy_y1 = accuracy_y1 + 1;
        end
        
        c2 = class_19(sig2);
        if c2==2
            accuracy_y2 = accuracy_y2 + 1;
        end
        
        c3 = class_19(sig3);
        if c3==3
            accuracy_y3 = accuracy_y3 + 1;
        end
        
        c4 = class_19(sig4);
        if c4==4
            accuracy_y4 = accuracy_y4 + 1;
        end
        
        c5 = class_19(sig5);
        if c5==5
            accuracy_y5 = accuracy_y5 + 1;
        end
        
        c6 = class_19(sig6);
        if c6==6
            accuracy_y6 = accuracy_y6 + 1;
        end
        
        c7 = class_19(sig7);
        if c7==7
            accuracy_y7 = accuracy_y7 + 1;
        end
        
        c8 = class_19(sig8);
        if c8==8
            accuracy_y8 = accuracy_y8 + 1;
        end
        
        c9 = class_19(sig9);
        if c9==9
            accuracy_y9 = accuracy_y9 + 1;
        end
        
        c10 = class_19(sig10);
        if c10==12
            accuracy_y10 = accuracy_y10 + 1;
        end
        
        c11 = class_19(sig11);
        if c11==11
            accuracy_y11 = accuracy_y11 + 1;
        end
        
        c12 = class_19(sig12);
        if c12==12
            accuracy_y12 = accuracy_y12 + 1;
        end
        
        c13 = class_19(sig13);
        if c13==13
            accuracy_y13 = accuracy_y13 + 1;
        end
        
        
        
    end
    
    fin_accu1 = [fin_accu1 accuracy_y1];
    fin_accu2 = [fin_accu2 accuracy_y2];
    fin_accu3 = [fin_accu3 accuracy_y3];
    fin_accu4 = [fin_accu4 accuracy_y4];
    fin_accu5 = [fin_accu5 accuracy_y5];
    fin_accu6 = [fin_accu6 accuracy_y6];
    fin_accu7 = [fin_accu7 accuracy_y7];
    fin_accu9 = [fin_accu9 accuracy_y9];
    fin_accu8 = [fin_accu8 accuracy_y8];
    fin_accu10 = [fin_accu10 accuracy_y10];
    fin_accu11 = [fin_accu11 accuracy_y11];
    fin_accu12 = [fin_accu12 accuracy_y12];
    
    fin_accu13 = [fin_accu13 accuracy_y13];
%     avg = (accuracy_y1+ accuracy_y2 + accuracy_y4 + accuracy_y6 + accuracy_y7 + accuracy_y9)/6;
    avg = (accuracy_y1 + accuracy_y2 + accuracy_y3 + accuracy_y4 + accuracy_y5 + accuracy_y6 + accuracy_y7 + accuracy_y9 + accuracy_y8 + accuracy_y10 + accuracy_y11 + accuracy_y12 + accuracy_y13)/13;
    
    fin = [fin, avg];
    snr
end
sigma = [1:1:35];
figure(1)
plot(sigma,fin_accu1)
hold on
plot(sigma,fin_accu2)
hold on
plot(sigma,fin_accu3)
hold on
plot(sigma,fin_accu4)
hold on
legend({'BPSK-BPSK','BPSK-QPSK','BPSK-8PSK','BPSK-16QAM'},'Location','southeast')
title('Individual Accuracy')
xlabel('SNR')
ylabel('Accuracy(in %)')
figure(2)
plot(sigma,fin_accu5)
hold on
plot(sigma,fin_accu6)
hold on
plot(sigma,fin_accu7)
hold on
plot(sigma,fin_accu8)
hold on
legend({'QPSK-BPSK','QPSK-QPSK','QPSK-8PSK','QPSK-16QAM'},'Location','southeast')
title('Individual Accuracy')
xlabel('SNR')
ylabel('Accuracy(in %)')
figure(3)
plot(sigma,fin_accu9)
hold on
plot(sigma,fin_accu10)
hold on
plot(sigma,fin_accu11)
hold on
plot(sigma,fin_accu12)
hold on
plot(sigma,fin_accu13)
hold on
legend({'8PSK-BPSK','8PSK-QPSK','8PSK-8PSK','8PSK-16QAM','16QAM-BPSK'},'Location','southeast')
title('Individual Accuracy')
xlabel('SNR')
ylabel('Accuracy(in %)')
figure(4)
plot(sigma,fin)
title('Average Accuracy')
xlabel('SNR')
ylabel('Ac  curacy(in %)')


