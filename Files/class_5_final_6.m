function class = class_5_final(sig1,t1,t2)

X = [real(sig1(1:100)), imag(sig1(1:100))];
E = evalclusters(X,'linkage','silhouette','KList',[4,16,64]);
%plot(E)
if E.OptimalK==4
    class = 1;
elseif E.OptimalK==16
    class=7;
elseif E.OptimalK==64
    if(abs(hos(sig1,8,4))>t1)
        if(abs(hos(sig1,2,0))>t2)
            class=19;
        else
            class=25;
        end
    else
        class = 13;
    end
% else
%      class =25;
end
end