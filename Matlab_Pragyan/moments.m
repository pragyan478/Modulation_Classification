function class = moments(sig1)
% t1 = 4.8;
X = [real(sig1(1:64)), imag(sig1(1:64))];                                                              %considering first 100 points only
E = evalclusters(X,'linkage','silhouette','KList',[4,16]);          % evaluating number of clusters using silhouette measure
%plot(E)
if E.OptimalK==4                                    % if number of clusters is 4 signal is BPSK-BPSK
    class = 1;
elseif E.OptimalK==16                               % if number of clusters is 16 signal is QPSK-QPSK
    class=2;
end
end