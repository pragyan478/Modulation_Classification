clear all
clc
data = data_generation_25classes(1000,35);
sig1 = data(:,5);

%Calculating K(scaling factor) values

X = [real(sig1), imag(sig1)];
E = evalclusters(X,'linkage','silhouette','KList',[4,8,16,32,64]);  %evaluating clusters

if E.OptimalK==4          %2bpsk - bpsk
    class = 1;
    
    cent = [];
    for d = 1:E.OptimalK
        cent = [cent mean(sig1(find(E.OptimalY==d)))];   %finding centroids of individual clusters
    end
  
    [max_2, indx2] = maxk(abs(cent),2);       %finding max 2 centroids
    
    temp1 = abs(cent - cent(indx2(1)));       %centering around those max centroid
    temp2 = abs(cent - cent(indx2(2)));
    
     [min1_2, idx1_2] = mink(temp1,2);        %forming 2 groups
     [min2_2, idx2_2] = mink(temp2,2);
     
     centered1_2 = cent(idx1_2)-mean(cent(idx1_2));   %centering the G1 & G2 around center
    centered2_2 = cent(idx2_2)-mean(cent(idx2_2));   
    bpsk_small = [abs(centered1_2), abs(centered2_2)];   %since both are same bpsk(i.e. both are shifted forms of one bpsk) taking the absolute and the mean
    bpsk_small = mean(bpsk_small);      
    bpsk_large = mean(abs(cent(idx1_2)));    %doubt 
    
    k = bpsk_large/bpsk_small;   %finding ratio K

end

if E.OptimalK ==8
    
    cent = [];
    for d = 1:E.OptimalK
        cent = [cent mean(sig1(find(E.OptimalY==d)))];  %evaluating clusters centroids
    end
    
    
    %%%% 2BPSK-QPSK %%%%
   [max_2, indx2] = maxk(abs(cent),2);    %finding max 2 points (farthest from center)
    
    temp1 = abs(cent - cent(indx2(1)));   %centering around them and then taking min 4 i.e. closest 3 points to max point
    temp2 = abs(cent - cent(indx2(2)));
    
    [min1_4, idx1_4] = mink(temp1,4);
    [min2_4, idx2_4] = mink(temp2,4);
    
    centered1_4 = cent(idx1_4)-mean(cent(idx1_4));  %then centering these groups around origin
    centered2_4 = cent(idx2_4)-mean(cent(idx2_4));   
    qp = [abs(centered1_4), abs(centered2_4)];
    
    
%     plot(real(cent(idx1_4)),imag(cent(idx1_4)),'*')
%     hold on
%     plot(real(cent(idx2_4)),imag(cent(idx2_4)),'*')
%     plot(real(mean(cent(idx2_4))),imag(mean(cent(idx2_4))),'*')
%      plot(real(mean(cent(idx1_4))),imag(mean(cent(idx1_4))),'*')
    
    
    
   

if var(abs(qp))<.007
    qpsk_amp = mean(qp);        %if variance is low then 2bpsk - qpsk and qpsk amplitude is mean of 2 groups (formed in the end)
    bpsk_amp = [mean(cent(idx1_4)), mean(cent(idx2_4))];    %bpsk amplitude is distance of mean of (mean of 2 groups from center)
    bpsk_amp = mean(abs(bpsk_amp));
    class = 2;
    k = bpsk_amp/qpsk_amp;    %the ratio - K
else
    class = 6;   %else 2qpsk-bpsk
    
    [max_2, indx2] = maxk(abs(cent),4);   %taking max points from each bpsk
    
    temp1 = abs(cent - cent(indx2(1)));   %centering each group by their max values and then forming groups of 2
    temp2 = abs(cent - cent(indx2(2)));
    temp3 = abs(cent - cent(indx2(3)));
    temp4 = abs(cent - cent(indx2(4)));
    
    [min1_4, idx1_4] = mink(temp1,2);
    [min2_4, idx2_4] = mink(temp2,2);
    [min3_4, idx3_4] = mink(temp3,2);
    [min4_4, idx4_4] = mink(temp4,2);
    
    centered1_2 = cent(idx1_4)-mean(cent(idx1_4));  %centering each bpsk group by their mean values
    centered2_2 = cent(idx2_4)-mean(cent(idx2_4)); 
    centered3_2 = cent(idx3_4)-mean(cent(idx3_4)); 
    centered4_2 = cent(idx4_4)-mean(cent(idx4_4)); 
    
    qpsk_power = [mean(cent(idx1_4)), mean(cent(idx2_4)), mean(cent(idx3_4)), mean(cent(idx4_4))]; %taking mean of all amps of 4 groups of bpsk
    qpsk_power = mean(abs(qpsk_power));    
    qp = [abs(centered1_2), abs(centered2_2),  abs(centered3_2),  abs(centered4_2)]; %taking means of centers of 4 groups of bpsk(i.e. qpsk)
    bpsk_power = mean(qp);
    k = qpsk_power/bpsk_power;   %calculating the ratio
    
end
end


if E.OptimalK ==16
    
    cent = [];
    for d = 1:E.OptimalK
        cent = [cent mean(sig1(find(E.OptimalY==d)))];
    end
    
    
    %%%%%%% for  2BPSK-8PSK %%%%%%
    
   [min_8, indx2] = maxk(abs(cent),2); %taking 2 max distant points from center from each 8psk groups
    
    temp1 = abs(cent - cent(indx2(1)));  %centering them around the max points and extracting the groups
    temp2 = abs(cent - cent(indx2(2)));  
    
    [minValues1, idx1] = mink(temp1,8);
    [minValues2, idx2] = mink(temp2,8);
    
    psk8_1 =  cent(idx1) - mean(cent(idx1)); %centering the 8psk points about their mean after removing bpsk part
    psk8_2 =  cent(idx2) - mean(cent(idx2));
    
    p8 = [psk8_1, psk8_2];
    
    if var(abs(p8))<.01    %low variance as 8psk have ideally same abs values
        class = 3;
       bpsk_power = [  mean(cent(idx1)), mean(cent(idx2))]; % taking mean of 8 psk groups to get bpsk signal and then taking mean of the 2 parts of bpsk
       bpsk_power = mean(abs(bpsk_power));
       psk8_power = mean(abs(p8));   %mean of 16 centroids - 2 groups of 8psks
       k = bpsk_power/psk8_power;
    
    else
        
        %%%%%% for 2QPSK-QPSK and 2BPSK-8QAM %%%%%%%
        
        [min_4, indx4] = maxk(abs(cent),4);     %taking 4 max distant points from each qpsk shifted signal
        
         temp1 = abs(cent - cent(indx4(1)));    %centering about these max points and forming 4 groups of 4 qpsks 
         temp2 = abs(cent - cent(indx4(2)));
         temp3 = abs(cent - cent(indx4(3))); 
         temp4 = abs(cent - cent(indx4(4))); 
        
        
        [minValues_qp1, idx_qp1] = mink(temp1,4);
        [minValues_qp2, idx_qp2] = mink(temp2,4);
        [minValues_qp3, idx_qp3] = mink(temp3,4);
        [minValues_qp4, idx_qp4] = mink(temp4,4);
        
        qpsk_1 = mean(cent(idx_qp1));   %taking the mean of original G1,G2,G3,G4 to form the qpsk signal by which the these signals are shifted i.e. K-qpsk
        qpsk_2 = mean(cent(idx_qp2));
        qpsk_3 = mean(cent(idx_qp3));
        qpsk_4 = mean(cent(idx_qp4));
        
        
        qpp = [qpsk_1, qpsk_2, qpsk_3, qpsk_4]; %combining them to form the qpsk
        aa1 = sort(radtodeg(angle(qpp)))+360;    %using the angle = 90 property for identification
        
        ss = [];
        tempp= [];
        tempp = [aa1,aa1(1)];
        for d = 1:length(tempp)-1
            ss(d) = tempp(d+1)-tempp(d);
        end
        ss = mod(ss,360);
        if  sum((85 < ss)&(ss < 95))==4
            class = 7;    %identified as K-qpsk qpsk
                       
          qpsk_large = mean(abs(qpp));  %taking the mean of the absolute values of the identified K-qpsk
          
          temp1 = cent(idx_qp1) - qpsk_1;      %centering the groups about center
          temp2 = cent(idx_qp2) - qpsk_2;
          temp3 = cent(idx_qp3) - qpsk_3;
          temp4 = cent(idx_qp4) - qpsk_4;
          
          t = [temp1, temp2, temp3, temp4];   % combining them
          
          qpsk_small = mean(abs(t));         %finding the mean of the absolute values
          k = qpsk_large/qpsk_small;          %taking the ratio
       
        else
            
            %%%% 2BPSK-8QAM %%%%
            class = 4;
            
          [min_2, indx2] = maxk(abs(cent),2);  %obtaining 2 max distant points from each group of 8qam 
        
         temp1 = abs(cent - cent(indx2(1)));   %centering around the points and then grouping them into G1 G2
         temp2 = abs(cent - cent(indx2(2)));  
          
         [minValues_qp1, idx_qp1] = mink(temp1,8);   
        [minValues_qp2, idx_qp2] = mink(temp2,8);
            
        bpsk_1 = mean(cent(idx_qp1));    %taking mean of G1 and mean G2 to find the K-bpsk that shifted the 8qam signal
        bpsk_2 = mean(cent(idx_qp2));
        bp = [bpsk_1, bpsk_2];   %forming the bpsk signal
        
        bpsk_power = mean(abs(bp));  %calculating its power 
        
        qam8_1 = cent(idx_qp1)-bpsk_1;    %centering both the G1 and G2 8qam around centers and calculating the power
        qam8_2 = cent(idx_qp2)-bpsk_2;
        qam8 = [qam8_1, qam8_2];
        qam8_power = mean(abs(qam8));
        
        k = bpsk_power/qam8_power;  % calculating the ratio
      
        end
    end
end

if E.OptimalK ==32
    
    cent = [];
    for d = 1:E.OptimalK
        cent = [cent mean(sig1(find(E.OptimalY==d)))];
    end
    
    cent32 = cent;
    
    
    %%%%%%% 2BPSK-16QAM %%%%%%%%%%%%%%%
    
    [max_2, indx2] = maxk(abs(cent32),2);       %identifying 2 max distant points i.e. from each 16qam group
    
    temp1 = abs(cent32 - cent32(indx2(1)));    %centering about these points and seperating the groups of 16qam
    temp2 = abs(cent32 - cent32(indx2(2)));
    
    [min1_16, idx1_16] = mink(temp1,16);
    [min2_16, idx2_16] = mink(temp2,16);
    
    centered1_16 = cent32(idx1_16)-mean(cent32(idx1_16));   %centering the groups of 16qam about the centers
    centered2_16 = cent32(idx2_16)-mean(cent32(idx2_16));
    
    ss1 = qam16_test(centered1_16);   %gives angle differences among the centroids when grouped in 4 groups of 4 then angle b/w them is 90 when centered about their mean 
    ss2 = qam16_test(centered2_16);
    
    if  sum((80 < ss1)&(ss1 < 100))==16 & sum((80 < ss2)&(ss2 < 100))==16   %checking if angles are close to 90
        class = 5;   %kbpsk - 16qam
        
        bpsk_p = [mean(cent32(idx1_16)), mean(cent32(idx2_16))];  %taking means of 2 groups to get the bpsk signal
        bpsk_p = mean(abs(bpsk_p));     %calculating power of bpsk
        
        qam16_p = [centered1_16, centered2_16];   %calculating power of both 16qam 
        qam16_p = mean(abs(qam16_p));
        
        k = bpsk_p/qam16_p;   %evaluating K
      
    else
        
        %%%%%%%%%%%%% for 2QPSK-8PSK %%%%%%%%%%%%%%%%%%
       
       [min_8, indx8] = maxk(abs(cent),4);    %finding 4 max distant points of each 8psk 
        
        temp1 = abs(cent - cent(indx8(1)));   %centering around the max distant points and identifying the 4 8psk as 4 groups
        temp2 = abs(cent - cent(indx8(2)));
        temp3 = abs(cent - cent(indx8(3)));
        temp4 = abs(cent - cent(indx8(4)));
        
        
        [minValues_8p1, idx_8p1] = mink(temp1,8);
        [minValues_8p2, idx_8p2] = mink(temp2,8);
        [minValues_8p3, idx_8p3] = mink(temp3,8);
        [minValues_8p4, idx_8p4] = mink(temp4,8);
        
        psk8_1 = mean(cent(idx_8p1));      %evaluating the mean of centroid of each 8psk to find the qpsk 
        psk8_2 = mean(cent(idx_8p2));
        psk8_3 = mean(cent(idx_8p3));
        psk8_4 = mean(cent(idx_8p4));
        
        ps8 = [psk8_1, psk8_2, psk8_3, psk8_4];
        aa1 = sort(radtodeg(angle(ps8)))+360;   %checking if the signal is qpsk or not by the angle difference property
        
        ss = [];
        tempp= [];
        tempp = [aa1,aa1(1)];
        for d = 1:length(tempp)-1
            ss(d) = tempp(d+1)-tempp(d);
        end
        ss = mod(ss,360);
        
        if sum((85 < ss)&(ss < 95))==4     %if yes then then qpsk present
            
            p81 = cent(idx_8p1) - psk8_1;
            p82 = cent(idx_8p2) - psk8_2;
            p83 = cent(idx_8p3) - psk8_3;
            p84 = cent(idx_8p4) - psk8_4;
            
            kk = [p81,p82,p83,p84];
            if var(abs(kk))<.005    %checking for low variance of 8psk
                class = 8;     %Kqpsk-8psk
                
                qpsk_p = mean(abs(ps8));   %power of qpsk
                psk8_p = mean(abs(kk));    %power of 8psks
                
                k = qpsk_p/psk8_p;   %ratio
                
            else     %if qpsk involved and variance is high then this is Kqpsk-8qam
                class = 9;
                
                qpsk_p = mean(abs(ps8));    %power of qpsk   
                qam8_p = mean(abs(kk));     %power of 8qam
                
                k = qpsk_p/qam8_p;
               
            end
            
        else     %doubt
            p81 = cent(idx_8p1) - psk8_1;
            p82 = cent(idx_8p2) - psk8_2;
            p83 = cent(idx_8p3) - psk8_3;
            p84 = cent(idx_8p4) - psk8_4;
            
            kk = [p81,p82,p83,p84];
            class = 9;
            
               
                qpsk_p = mean(abs(ps8));       
                qam8_p = mean(abs(kk));
                
                k = qpsk_p/qam8_p;
            
        end
        
        
    end
    
    
end

if E.OptimalK ==64      %qpsk 16qam
    class = 10;
    
    cent = [];
    for d = 1:E.OptimalK
        cent = [cent mean(sig1(find(E.OptimalY==d)))];
    end   
    
     [max_2, indx2] = maxk(abs(cent),4);    %identifying four maximum distant points from each cluster of 16qam
    
    temp1 = abs(cent - cent(indx2(1)));     %centering them about the max points and grouping them - giving us 4 16 qam 
    temp2 = abs(cent - cent(indx2(2)));
    temp3 = abs(cent - cent(indx2(3)));
    temp4 = abs(cent - cent(indx2(4)));   
    
    [min1_16, idx1_16] = mink(temp1,16);
    [min2_16, idx2_16] = mink(temp2,16);
    [min3_16, idx3_16] = mink(temp3,16);
    [min4_16, idx4_16] = mink(temp4,16);
    
    centered1_16 = cent(idx1_16)-mean(cent(idx1_16));    %centering the 4 qams about their centroid i.e. removing the qpsk shift 
    centered2_16 = cent(idx2_16)-mean(cent(idx2_16));
    centered3_16 = cent(idx3_16)-mean(cent(idx3_16));
    centered4_16 = cent(idx4_16)-mean(cent(idx4_16));
    
    qam16_p = [centered1_16, centered2_16, centered3_16, centered4_16];  %taking means of absolute values to get power
    qam16_p = mean(abs(qam16_p));
    
    qpsk_p = [mean(cent(idx1_16)), mean(cent(idx2_16)), mean(cent(idx3_16)), mean(cent(idx4_16))];  %finding the arms of qpsk by calculating the shifts of centroids of 16 qam from origin 
    qpsk_p = mean(abs(qpsk_p));     %taking the mean
    
    k = qpsk_p/qam16_p;    %evaluating K
    
end
