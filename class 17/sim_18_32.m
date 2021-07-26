for snr = 25:29
    snr
    error_5 =[];
    error_8 =[];
    error_9 =[];
    error_12 =[];
    error_17=[];
    error_18 =[];
   j=0;
    while(j<100)
          data = data_generation_25classes(1000,snr);
          sig1 =  (data(:,5));
          X = [real(sig1), imag(sig1)];
          E = evalclusters(X,'linkage','silhouette','KList',[4,8,16,32,64,128]);

          if E.OptimalK==32
            j = j+1;
            cent = [];
            for d_1 = 1:E.OptimalK
                 cent = [cent mean(sig1(find(E.OptimalY==d_1)))];
            end
            cent = cent';
            error_5 = [error_5 class_18_2(cent)];
          end
    end
     error_5
   j=0;
    while(j<100)
          data = data_generation_25classes(1000,snr);
          sig1 =  (data(:,8));
          X = [real(sig1), imag(sig1)];
          E = evalclusters(X,'linkage','silhouette','KList',[4,8,16,32,64,128]);

          if E.OptimalK==32
            j = j+1;
            cent = [];
            for d_1 = 1:E.OptimalK
                 cent = [cent mean(sig1(find(E.OptimalY==d_1)))];
            end
            cent = cent';
            error_8 = [error_8 class_18_2(cent)];
          end
    end
     error_8
   j=0;
    while(j<100)
          data = data_generation_25classes(1000,snr);
          sig1 =  (data(:,9));
          X = [real(sig1), imag(sig1)];
          E = evalclusters(X,'linkage','silhouette','KList',[4,8,16,32,64,128]);

          if E.OptimalK==32
            j = j+1;
            cent = [];
            for d_1 = 1:E.OptimalK
                 cent = [cent mean(sig1(find(E.OptimalY==d_1)))];
            end
            cent = cent';
            error_9 = [error_9 class_18_2(cent)];
          end
    end
     error_9
   j=0;
    while(j<100)
          data = data_generation_25classes(1000,snr);
          sig1 =  (data(:,12));
          X = [real(sig1), imag(sig1)];
          E = evalclusters(X,'linkage','silhouette','KList',[4,8,16,32,64,128]);

          if E.OptimalK==32
            j = j+1;
            cent = [];
            for d_1 = 1:E.OptimalK
                 cent = [cent mean(sig1(find(E.OptimalY==d_1)))];
            end
            cent = cent';
            error_12 = [error_12 class_18_2(cent)];
          end
    end
     error_12
  j=0;
    while(j<100)
          data = data_generation_25classes(1000,snr);
          sig1 =  (data(:,17));
          X = [real(sig1), imag(sig1)];
          E = evalclusters(X,'linkage','silhouette','KList',[4,8,16,32,64,128]);

          if E.OptimalK==32
            j = j+1;
            cent = [];
            for d_1 = 1:E.OptimalK
                 cent = [cent mean(sig1(find(E.OptimalY==d_1)))];
            end
            cent = cent';
            error_17 = [error_17 class_18_2(cent)];
          end
    end
     error_17
     j=0;
    while(j<100)
          data = data_generation_25classes(1000,snr);
          sig1 =  (data(:,18));
          X = [real(sig1), imag(sig1)];
          E = evalclusters(X,'linkage','silhouette','KList',[4,8,16,32,64,128]);

          if E.OptimalK==32
            j = j+1;
            cent = [];
            for d_1 = 1:E.OptimalK
                 cent = [cent mean(sig1(find(E.OptimalY==d_1)))];
            end
            cent = cent';
            error_18 = [error_18 class_18_2(cent)];
          end
    end
     error_18
     sigma = [1:1:100];
figure(snr-24)
plot(sigma,error_5)
hold on
plot(sigma,error_8)
hold on
plot(sigma,error_9)
hold on
plot(sigma,error_12)
hold on
plot(sigma,error_17)
hold on
plot(sigma,error_18)
title('Error')
xlabel('x')
ylabel('Error')
legend({'Class 5','Class 8','Class 9','Class 12','Class 17','Class 18'},'Location','eastoutside')
   
end
