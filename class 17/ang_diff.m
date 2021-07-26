function ss = ang_diff(qpp)
%function sorts the signals on the basis of the phase or angle and then
%takes the difference b/w the consecutive elements 
%returns the values in degrees

aa1 = sort(radtodeg(angle(qpp)))+360;
        
        ss = [];
        tempp= [];
        tempp = [aa1,aa1(1)];
        for d = 1:length(tempp)-1
            ss(d) = tempp(d+1)-tempp(d);
        end
        ss = mod(ss,360);
end