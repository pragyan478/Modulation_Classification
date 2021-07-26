function class = algorithm(sig1)

X = [real(sig1(1:200)), imag(sig1(1:200))];
E = evalclusters(X,'linkage','silhouette','KList',[4,8,16,32,64]);
plot(E)
if E.OptimalK==4
    class = 1;
elseif E.OptimalK ==16
    if(abs(hos(sig1,2,0))>0.45)
        class=3;
    else
        if(abs(hos(sig1,4,0))>0.35)
            class = 7;
        else
            if(abs(hos(sig1,4,1))>0.3)
                class = 11;
            else
                class=12;
            end
        end
    end
elseif E.OptimalK==8
    if(abs(hos(sig1,2,0))>0.4)
        class=2;
    else
        class=6;
    end
elseif E.OptimalK ==32
    if(abs(hos(sig1,4,0))>0.4)
        class = 8;
    else
        class = 12;
    end
else
    class = 13;
end
end