function class = moments(sig1,t1,t2)
% t1 = 4.8;
% t2 = 0.17;
X = [real(sig1(1:100)), imag(sig1(1:100))];                            %considering first 100 points only
E = evalclusters(X,'linkage','silhouette','KList',[4,16,64]);          % evaluating number of clusters using silhouette measure
%plot(E)
if E.OptimalK==4                                    % if number of clusters is 4 signal is BPSK-BPSK
    class = 1;
elseif E.OptimalK==16                               % if number of clusters is 16 signal is QPSK-QPSK
    class=7;
elseif E.OptimalK==64                               % if number of clusters is 64 then signal can be either of the remaining signals
    if(abs(hos(sig1,8,4))>t1)                       % if M84 < t1 then class is 8PSK-8PSK 
        if(abs(hos(sig1,2,0))>t2)                   % if M20 > t2 then class is 8QAM-8QAM
            class=19;
        else
            class=25;                               % if M20 < t2 then class is 16QAM-16QAM
        end
    else
        class = 13;
    end
end
end