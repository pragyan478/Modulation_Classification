classdef H_eps
    methods(Static)
        function vec = spectrum(N, a, eps, Ts)
            ff = linspace(0, 0.5, N/2+1);
            vec1 = zeros(1,N/2+1);
            vec = zeros(1,N);
            for i=1:(N/2+1)
                f = ff(i);
                if(abs(f) < (1-a)/2)
                    vec1(i) = exp(-2j*pi*f*eps);
                else
                    vec1(i) = exp(1j*pi*eps)*exp(-2j*pi*f*eps)*(cos(pi*eps) ...
                             + 1j*sin(pi*eps)*sin((pi/a)*(f - 0.5)));
                end
            end
            vec(N/2:N) = vec1;
            vec(1:N/2+1) = conj(fliplr(vec1));
        end
        
        function p = real_power(eps, d, a)
            d = d + 1e-10;
            A = sin(pi*d*a)/(2*pi*d);
            B = sin(pi*d*a)/(4*pi*d) - sin(pi*(d*a + 1))/(8*pi*(d + 1/a)) - sin(pi*(d*a - 1))/(8*pi*(d - 1/a));
            C = sin(pi*(1-2*d*a)/2)/(2*pi*(1/a - 2*d)) - sin(pi*(1+2*d*a)/2)/(2*pi*(1/a + 2*d));
            ib = sin(pi*d*(1-a))/(2*pi*d);
            ob = A*cos(pi*eps)*cos(pi*(eps-d)) + B*sin(pi*eps)*sin(pi*(eps-d))...
                + C*(sin(pi*d));
            p = 2*(ib + ob);
        end
        
        function p = dp_de(eps, d, a)
            d = d + 1e-10;
            A = sin(pi*d*a)/(2*pi*d);
            B = sin(pi*d*a)/(4*pi*d) - sin(pi*(d*a + 1))/(8*pi*(d + 1/a)) - sin(pi*(d*a - 1))/(8*pi*(d - 1/a));
            ob1 = -A*pi*(sin(2*pi*eps));
            ob2 =  B*pi*(sin(2*pi*eps));
            p = 2*(ob1 + ob2);
        end
    end
end        
