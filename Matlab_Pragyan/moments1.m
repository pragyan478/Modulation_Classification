function class = moments1(sig1)
sig1 = sig1/sqrt(mean(abs(sig1).^2));
% t1 = 4.8;
% t2 = 0.17;
X = [real(sig1), imag(sig1)];                            %considering first 100 points only
E = evalclusters(X,'linkage','silhouette','KList',[4,16,64]);          % evaluating number of clusters using silhouette measure
CV = E.CriterionValues;
Optimalnum = E.OptimalK;
Optimalnum
if(CV(2)-CV(1)>0 && CV(3)-CV(2)>0 && CV(2)-CV(1)>CV(3)-CV(2))
    Optimalnum = 16;
end
figure()
plot(E)
abs(hos(sig1,8,4))
if Optimalnum==4                                    % if number of clusters is 4 signal is BPSK-BPSK
    class = 1;
elseif Optimalnum==16                               % if number of clusters is 16 signal is QPSK-QPSK
    class=2;
elseif Optimalnum==64                               % if number of clusters is 64 then signal can be either of the remaining signals
    if(abs(hos(sig1,8,4))>20)                       % if M84 < t1 then class is 8PSK-8PSK 
        class = 4;
    else
        class = 3;
    end
end
end