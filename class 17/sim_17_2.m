for snr=25:35
   j=0;
   error_17_2 =[];
   while(j<100)
      data = data_generation_25classes(1000,snr);
      sig1 = data(:,17);
       X = [real(sig1), imag(sig1)];
       E = evalclusters(X,'linkage','silhouette','KList',[4,8,15,16,32,64,128]);
       if (E.OptimalK==15)
          j = j+1;
          cent = [];
           for d_1 = 1:E.OptimalK
                cent = [cent mean(sig1(find(E.OptimalY==d_1)))];
           end
           cent = cent';
           error_17_2 = [error_17_2 Untitled3(cent)] ;
       end
       
   end
   sigma = [1:1:100];
figure(snr-24)
plot(sigma,error_17_2);
end