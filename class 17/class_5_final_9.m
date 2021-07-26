function class = class_5_final_9(sig1,t1,t2,t3)
cum = moment_statistics(sig1);
[RD1,CD1,order1]=optics(sig1,10);

if(abs(cum(5))<t1)  %threshold 1
    if(abs(cum(13))>t2) %threshold 2
         class=19;
    else
         class=25;
    end
else
    if(abs(cum(4))>t3) %threshold 3
        class=1;
    elseif(mean(RD1(order1))>0.16)
        class=13;
    else 
        class=7;
    end
        
end
end
% else
%      class =25;