function class = class_5_final_7(sig1,t1,t2,t3)
cum = moment_statistics(sig1);
X = [real(sig1(1:100)), imag(sig1(1:100))];
E = evalclusters(X,'linkage','silhouette','KList',[16,64]);

if(abs(cum(5))<t1)  %threshold 1
    if(abs(cum(13))>t2) %threshold 2
         class=19;
    else
         class=25;
    end
else
    if(abs(cum(4))>t3) %threshold 3
        class=1;
    elseif(E.OptimalK==16)
        class=7;
    else 
        class=13;
    end
        
end
end
% else
%      class =25;