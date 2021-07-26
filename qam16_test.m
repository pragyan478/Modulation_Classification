function  ang = qam16_test(centered1_16) % we are passing a 16qam centered around origin

      [max4_1, indx4_1] = maxk(abs(centered1_16),4);  %taking farthest points from center
           
       
       temp4_1 = abs(centered1_16 - centered1_16(indx4_1(1)));   % subtracting the farthest point hence they become the center
       temp4_2 = abs(centered1_16 - centered1_16(indx4_1(2)));
       temp4_3 = abs(centered1_16 - centered1_16(indx4_1(3)));
       temp4_4 = abs(centered1_16 - centered1_16(indx4_1(4)));
       
       [min4_1, idx4_1] = mink(temp4_1,4);   %extracting the nearest 4 points from center i.e. also a point
       [min4_2, idx4_2] = mink(temp4_2,4);   %hence divinding 16 points in groups of 4
       [min4_3, idx4_3] = mink(temp4_3,4);
       [min4_4, idx4_4] = mink(temp4_4,4);
       
       centered4_1 = centered1_16(idx4_1) - mean(centered1_16(idx4_1));   %centering the clusters of 4 points around their centroids for all 4 clusters
       centered4_2 = centered1_16(idx4_2) - mean(centered1_16(idx4_2));
       centered4_3 = centered1_16(idx4_3) - mean(centered1_16(idx4_3));
       centered4_4 = centered1_16(idx4_4) - mean(centered1_16(idx4_4));
       
       
       ang4_1 = ang_diff(centered4_1);  % calculating and storing the angle difference of the 4 clusters centered around origin
       ang4_2 = ang_diff(centered4_2);
       ang4_3 = ang_diff(centered4_3);
       ang4_4 = ang_diff(centered4_4);
       
      ang = [ang4_1, ang4_2, ang4_3, ang4_4];
end
       
       