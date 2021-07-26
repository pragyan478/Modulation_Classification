function class = class_5_final(sig1)

X = [real(sig1(1:100)), imag(sig1(1:100))];
E = evalclusters(X,'linkage','silhouette','KList',[4,16,64]);
%plot(E)
if E.OptimalK==4
    class = 1;
elseif E.OptimalK==16
    class=7;
elseif E.OptimalK==64
    cent = [];
    for d = 1:E.OptimalK
        cent = [cent mean(sig1(find(E.OptimalY==d)))];   %finding individual cluster centroids
    end
    cent = cent';
    sig = cent;
    X = [real(sig), imag(sig)];
    E = evalclusters(X,'linkage','silhouette','KList',[16]);
    cent1 = [];
    for d = 1:E.OptimalK
        cent1 = [cent1 mean(sig(find(E.OptimalY==d)))];   %finding individual cluster centroids
    end
    if(var(abs(cent1))>0.11)
        X = [real(sig1), imag(sig1)];
        E = evalclusters(X,'linkage','silhouette','KList',[4,16,64]);
        cent = [];
            for d = 1:E.OptimalK
                cent = [cent mean(sig1(find(E.OptimalY==d)))];   %finding individual cluster centroids
            end
            cent = cent';
            sig = cent;
            X = [real(sig), imag(sig)];
            E = evalclusters(X,'linkage','silhouette','KList',[1 16]);
            cent1 = [];
            for d = 1:E.OptimalK
                cent1 = [cent1 mean(sig(find(E.OptimalY==d)))];   %finding individual cluster centroids
            end
        if(abs(hos(cent1,4,1))>0.5)
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