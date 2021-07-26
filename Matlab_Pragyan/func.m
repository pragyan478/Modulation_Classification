classdef func
    % This file contains the mathematical functions required
    
    methods(Static)
        function value = rc(t, alpha, T)
            %{
                Raised cosine in time domain
                t: time
                alpha: roll-off factor
                T: symbol time
            %}
            value = func.s(t,T).*func.c(t,alpha,T);
        end 

        function val = s(t, T)
            t = t/T + 1e-10;
            val = sin(pi*t)./(pi*t);
        end
        
        function val = ds(t, T)
            t = t/T + 1e-10;
            val = (pi*t.*cos(pi*t) - sin(pi*t))./(pi*t.^2);
        end
        
        function val = d2s(t,T)
            t = t/T + 1e-10;
            A = (pi*cos(pi*t) - pi^2*t.*sin(pi*t) - pi*cos(pi*t));
            B = (pi*t.*cos(pi*t) - sin(pi*t));
            val = A./t.^2/pi - 2*B./t.^3/pi;
        end
        
        function val = c(t, a, T)
            t = t/T + 1e-10;
            d = (1 - 4*a^2*t.^2);
            val = cos(pi*a*t)./d;
        end
        
        function val = dc(t, a, T)
            t = t/T + 1e-10;
            d = (1 - 4*a^2*t.^2);
            A = -pi*a*sin(pi*a*t)./d;
            B = 8*a^2*cos(pi*a*t)./d.^2;
            val = A + B;
        end
        
        function val = d2c(t, a, T)
            t = t/T + 1e-10;
            d = (1 - 4*a^2*t.^2);
            A = -pi^2*a^2*cos(pi*a*t)./d;
            B = -8*pi*a^3*t.*sin(pi*a*t)./d.^2;
            C = -8*a^3*pi*sin(pi*a*t)./d.^2;
            D = 64*a^4*t.*cos(pi*a*t)./d.^3;
            val = A + B + C + D;
        end
        
        function val = dgdt(t, a, T)
            %{
                Raised cosine in time domain derivative
                t: time
                a: roll-off factor
                T: symbol time
            %}
            t = t/T + 1e-10;
            val = func.c(t,a,T).*func.ds(t,T) + func.s(t,T).*func.dc(t,a,T);
        end    
        
        function val = d2gdt2(t, a, T)
            %{
                Raised cosine in time domain derivative
                t: time
                a: roll-off factor
                T: symbol time
            %}
            t = t/T + 1e-10;
            val = 2*func.ds(t,T).*func.dc(t,a,T) + func.c(t,a,T).*func.d2s(t,T) ...
                + func.s(t,T).*func.d2c(t,a,T);
        end    
        
        function val = dgdT(t, alpha, T)
            %{
                Raised cosine derivative wrt Ts
                t: time
                alpha: roll-off factor
                T: symbol time
            %}
            val = func.dgdt(t, alpha, T) .* (-t/T^2);
        end
        
        function val = d2gdT2(t, alpha, T)
            %{
                Raised cosine derivative wrt Ts
                t: time
                alpha: roll-off factor
                T: symbol time
            %}
            val = func.d2gdt2(t, alpha, T) .* (-t/T^2);
        end


        function val = srrc(t, alpha, T)
            %{
                Square Root Raised cosine in time domain
                t: time
                alpha: roll-off factor
                T: symbol time
            %}
            t = t/T + 1e-10;
            d = (1-16*(alpha^2)*(t.^2) + 1e-12);
            A = sin(pi*t*(1-alpha)) + 4*alpha*t.*cos(pi*t.*(1+alpha));

            val = A./t./d/pi/T;
        end
    end
end