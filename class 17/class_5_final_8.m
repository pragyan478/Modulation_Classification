function class = class_5_final_7(sig1,t1,t2,t3)
cum = moment_statistics(sig1);
X = [real(sig1), imag(sig1)];
minpoints = 10;
epsilon = 0.085;
Clusters =main(X,epsilon,minpoints);

if(abs(cum(5))<t1)  %threshold 1
    if(abs(cum(13))>t2) %threshold 2
         class=19;
    else
         class=25;
    end
else
    if(abs(cum(4))>t3) %threshold 3
        class=1;
    elseif(Clusters>=2)
        class=7;
    else 
        class=13;
    end
        
end
end
% else
%      class =25;