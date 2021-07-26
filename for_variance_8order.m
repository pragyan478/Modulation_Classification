clear all
clc
R = [];
for snr = 15:25
    K = [];
    for runs = 1:10
    data = data_generation_25classes(1000,snr);    %generating data using the defined function  
    sig1 = data(:,7);   %2qpsk-qpsk

    %breaking the signal into real and its imaginary part
    
    X = [real(sig1), imag(sig1)];
    
    %evaluating clusters using agglomerative clustering and calculating optimum K by testing the silhoutte measure on the given values
    
    E = evalclusters(X,'linkage','silhouette','KList',[4,8,16,32,64]);   
    
    
    if E.OptimalK ==16

    cent = [];
    for d = 1:E.OptimalK    
        %appending centroids of each individual clusters in the array cent
        cent = [cent mean(sig1(find(E.OptimalY==d)))];        
    end
    cent = cent'; %converting it to a vector
    temp = [real(cent),imag(cent)]; 
    
    dist = pdist(temp);  %measuring the distance b/w the values in temp
    Z = squareform(dist);     % forms a matrix showing distance(i,j) is at Z[i,j]
    [r1, r2] = find(ismember(Z, max(Z(:))));
    
     [minValues1, idx1] = mink(Z(:,r1(1)),E.OptimalK/2);
     [minValues2, idx2] = mink(Z(:,r1(2)),E.OptimalK/2);

     bpsk_1 =  cent(idx1) - mean(cent(idx1));
     bpsk_2 =  cent(idx2) - mean(cent(idx2));
     
     yy = [abs(bpsk_1); abs(bpsk_2)];
     B = var(yy);
    else
        B = 100;
     
    end
    K = [K, B];
    end
    R = [R;K];
    

end







    