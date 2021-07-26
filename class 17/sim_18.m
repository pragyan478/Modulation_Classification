
for snr = 34:34
    snr
    error_10 =[];
    error_13 =[];
    error_14 =[];
    error_18 =[];
   j=0;
    while(j<100)
          data = data_generation_25classes(1000,snr);
          sig1 =  (data(:,10));
          X = [real(sig1), imag(sig1)];
          E = evalclusters(X,'linkage','silhouette','KList',[4,8,16,32,64,128]);

          if E.OptimalK==64
            j = j+1;
            cent = [];
            for d_1 = 1:E.OptimalK
                 cent = [cent mean(sig1(find(E.OptimalY==d_1)))];
            end
            cent = cent';
            error_10 = [error_10 class_18(cent)];
          end
    end
     error_10
   j=0;
    while(j<100)
          data = data_generation_25classes(1000,snr);
          sig1 =  (data(:,13));
          X = [real(sig1), imag(sig1)];
          E = evalclusters(X,'linkage','silhouette','KList',[4,8,16,32,64,128]);

          if E.OptimalK==64
            j = j+1;
            cent = [];
            for d_1 = 1:E.OptimalK
                 cent = [cent mean(sig1(find(E.OptimalY==d_1)))];
            end
            cent = cent';
            error_13 = [error_13 class_18(cent)];
          end
    end
     error_13
   j=0;
    while(j<100)
          data = data_generation_25classes(1000,snr);
          sig1 =  (data(:,14));
          X = [real(sig1), imag(sig1)];
          E = evalclusters(X,'linkage','silhouette','KList',[4,8,16,32,64,128]);

          if E.OptimalK==64
            j = j+1;
            cent = [];
            for d_1 = 1:E.OptimalK
                 cent = [cent mean(sig1(find(E.OptimalY==d_1)))];
            end
            cent = cent';
            error_14 = [error_14 class_18(cent)];
          end
    end
     error_14
   j=0;
    while(j<100)
          data = data_generation_25classes(1000,snr);
          sig1 =  (data(:,18));
          X = [real(sig1), imag(sig1)];
          E = evalclusters(X,'linkage','silhouette','KList',[4,8,16,32,64,128]);

          if E.OptimalK==64
            j = j+1;
            cent = [];
            for d_1 = 1:E.OptimalK
                 cent = [cent mean(sig1(find(E.OptimalY==d_1)))];
            end
            cent = cent';
            error_18 = [error_18 class_18(cent)];
          end
    end
     error_18
     sigma = [1:1:100];
figure(snr-24)
plot(sigma,error_10)
hold on
plot(sigma,error_13)
hold on
plot(sigma,error_14)
hold on
plot(sigma,error_18)
title('Error')
xlabel('x')
ylabel('Error')
legend({'Class 10','Class 13','Class 14','Class 18'},'Location','eastoutside')
   
end
