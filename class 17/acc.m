%function avg = acc(N)

N = 500;

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
fin_accu14 = [];
fin_accu15 = [];
fin_accu16 = [];
fin_accu17 = [];
fin_accu18 = [];
fin_accu21 = [];
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
    accuracy_y14 = 0;
    accuracy_y15 = 0;
    accuracy_y16 = 0;
    accuracy_y17 = 0;
    accuracy_y18 = 0;
    accuracy_y21 = 0;
    
    for k = 1:100
        data = data_generation_25classes_cfo(N,snr);
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
        sig14 = data(:,14);
        sig15 = data(:,15);
        sig16 = data(:,16);
        sig17 = data(:,17);
        sig18 = data(:,18);
        sig21 = data(:,21);
        
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
        if c10==10
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
        
        c14 = class_19(sig14);
        if c14==14
            accuracy_y14 = accuracy_y14 + 1;
        end
        
        c15 = class_19(sig15);
        if c15==15
            accuracy_y15 = accuracy_y15 + 1;
        end
        
        c16 = class_19(sig16);
        if c16==16
            accuracy_y16 = accuracy_y16 + 1;
        end
        c17 = class_19(sig17);
        if c17==17
            accuracy_y17 = accuracy_y17 + 1;
        end
        c18 = class_19(sig18);
        if c18==18
            accuracy_y18 = accuracy_y18 + 1;
        end
        
        
        c21 = class_19(sig21);
        if c21==21
            accuracy_y21 = accuracy_y21 + 1;
        end
        
        
        
    end
    
    fin_accu1 = [fin_accu1 accuracy_y1];
    fin_accu2 = [fin_accu2 accuracy_y2];
    fin_accu3 = [fin_accu3 accuracy_y3];
    fin_accu4 = [fin_accu4 accuracy_y4];
    fin_accu5 = [fin_accu5 accuracy_y5];
    fin_accu6 = [fin_accu6 accuracy_y6];
    fin_accu7 = [fin_accu7 accuracy_y7];
    fin_accu8 = [fin_accu8 accuracy_y8];
    fin_accu9 = [fin_accu9 accuracy_y9];
    fin_accu10 = [fin_accu10 accuracy_y10];
    fin_accu11 = [fin_accu11 accuracy_y11];
    fin_accu12 = [fin_accu12 accuracy_y12];
    fin_accu13 = [fin_accu13 accuracy_y13];
    fin_accu14 = [fin_accu14 accuracy_y14];
    fin_accu15 = [fin_accu15 accuracy_y15];
    fin_accu16 = [fin_accu16 accuracy_y16];
    fin_accu17 = [fin_accu17 accuracy_y17];
    fin_accu18 = [fin_accu18 accuracy_y18];
    
    fin_accu21 = [fin_accu21 accuracy_y21];
    avg = (accuracy_y1+ accuracy_y2 + accuracy_y4 + accuracy_y7 + accuracy_y8 + accuracy_y9)/6;
    avg = (accuracy_y1 + accuracy_y2 + accuracy_y3 + accuracy_y4 + accuracy_y5 + accuracy_y6 + accuracy_y7 + accuracy_y8 + accuracy_y9 + accuracy_y10 + accuracy_y11 + accuracy_y12 + accuracy_y13 + accuracy_y14 + accuracy_y15 + accuracy_y16 + accuracy_y17 + accuracy_y18+  accuracy_y21)/19;
    
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
plot(sigma,fin_accu5)
hold on
legend({'2BPSK-BPSK','2BPSK-QPSK','2BPSK-8PSK','2BPSK-8QAM','2BPSK-16QAM'},'Location','southeast')
title('Individual Accuracy')
xlabel('SNR')
ylabel('Accuracy(in %)')
figure(2)
plot(sigma,fin_accu6)
hold on
plot(sigma,fin_accu7)
hold on
plot(sigma,fin_accu8)
hold on
plot(sigma,fin_accu9)
hold on
plot(sigma,fin_accu10)
hold on
legend({'2QPSK-BPSK','2QPSK-QPSK','2QPSK-8PSK','2QPSK-8QAM','2QPSK-16QAM'},'Location','southeast')
title('Individual Accuracy')
xlabel('SNR')
ylabel('Accuracy(in %)')
figure(3)
plot(sigma,fin_accu11)
hold on
plot(sigma,fin_accu12)
hold on
plot(sigma,fin_accu13)
hold on
plot(sigma,fin_accu14)
hold on
plot(sigma,fin_accu15)
hold on
legend({'2-8PSK-BPSK','2-8PSK-QPSK','2-8PSK-8PSK','2-8PSK-8QAM','2-8PSK-16QAM'},'Location','southeast')
title('Individual Accuracy')
xlabel('SNR')
ylabel('Accuracy(in %)')
figure(4)
plot(sigma,fin)
title('Average Accuracy')
xlabel('SNR')
ylabel('Ac  curacy(in %)')

figure(5)
plot(sigma,fin_accu17)
title('Class 17 Accuracy')
xlabel('SNR')
ylabel('Accuracy(in %)')
 % end
 
 figure(6)
plot(sigma,fin_accu18)
title('Class 18 Accuracy')
xlabel('SNR')
ylabel('Accuracy(in %)')
 % end

figure(7)
plot(sigma,fin_accu16)
title('Class 16 Accuracy')
xlabel('SNR')
ylabel('Accuracy(in %)')
 % end

figure(8)
plot(sigma,fin_accu21)
title('Class 21 Accuracy')
xlabel('SNR')
ylabel('Accuracy(in %)')
%   end



