function class = cumulants(sig1)
cum = moment_statistics(sig1);           %evaluating cumulants of the signal
[RD1,CD1,order1]=optics(sig1,20);        %calculating the reachability distances of points and their order using optics algorithm
t1 = 0.5;
t2 =15.1766;
t3 =.5684;
mean(RD1(order1))
cum(5)
if(abs(cum(5))<t1)                       % if C42 <t1 then possible classes are 8-qam,8-qam and 16-qam,16-qam                             % if C83 <t2 ->16qam-16qam
         class=4;
else                                     % % if C42 >t1 then possible classes are BPSK-BPSK, QPSK-QPSK and 8-PSK and 8-PSK
    if(abs(cum(4))>t3)                   % if C41>t3 ->BPSK-BPSK
        class=1;
    elseif(mean(RD1(order1))>0.245)      % else if mean of reachability distance < 0.245 then class is 8PSK-8PSK  
        class=3;
    else                                 % if mean of reachability distance >0.245 then class is QPSK-QPSK
        class=2;
    end
        
end
end