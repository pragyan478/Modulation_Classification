classdef psd_gen
    % CLASS - this has static functions to generate the theoretical PSD and
    % certain derivatives based on parameters
    methods(Static)
        function H = S(alpha, N, Ts, fo, Tsampling)
            fs = 1/Tsampling;
            f = linspace(-fs/2, fs/2, N);
            H = zeros(1, length(f));
            for i = 1:length(f)
                ff = f(i) - fo;
                if ff >= fs/2
                    ff = ff - fs;
                elseif ff <= -fs/2
                    ff = ff + fs;
                end
                if abs(ff) <= (1-alpha)/2/Ts
                    H(i) = 1;
                elseif abs(ff) > (1-alpha)/2/Ts && abs(ff) <= (1+alpha)/2/Ts
                    H(i) = 0.5*(1 + cos((pi*Ts/alpha) * (abs(ff) - (1-alpha)/2/Ts)));
                else
                    H(i) = 0;
                end
            end
            H = H*Ts;
        end
        
        function val = dSdT(alpha, N, Ts, fo, Tsampling)
            fs = 1/Tsampling;
            f = linspace(-fs/2, fs/2, N);
            val1 = zeros(1, length(f));
            for i = 1:length(f)
                ff = f(i) - fo;
                if ff >= fs/2
                    ff = ff - fs;
                elseif ff <= -fs/2
                    ff = ff + fs;
                end
                if abs(ff) <= (1-alpha)/2/Ts
                    val1(i) = 0;
                elseif abs(ff) > (1-alpha)/2/Ts && abs(ff) <= (1+alpha)/2/Ts
                    val1(i) = -0.5*(sin((pi*Ts/alpha) * (abs(ff) - (1-alpha)/2/Ts)));
                    val1(i) = val1(i) * pi * abs(ff)/alpha;
                else
                    val1(i) = 0;
                end
            end
            val1 = val1*Ts;
            val = val1 + psd_gen.S(alpha, N, Ts, fo, Tsampling)/Ts;
        end
        
        function val = dSda(alpha, N, Ts, fo, Tsampling)
            fs = 1/Tsampling;
            f = linspace(-fs/2, fs/2, N);
            val = zeros(1, length(f));
            for i = 1:length(f)
                ff = f(i) - fo;
                if ff >= fs/2
                    ff = ff - fs;
                elseif ff <= -fs/2
                    ff = ff + fs;
                end
                if abs(ff) <= (1-alpha)/2/Ts
                    val(i) = 0;
                elseif abs(ff) > (1-alpha)/2/Ts && abs(ff) <= (1+alpha)/2/Ts
                    val(i) = 0.5*(sin((pi*Ts/alpha) * (abs(ff) - (1-alpha)/2/Ts)));
                    val(i) = val(i) * pi * (Ts * abs(ff) - 0.5)/alpha^2;
                else
                    val(i) = 0;
                end
            end
            val = val*Ts;
        end
        
        function val = dSdfo(alpha, N, Ts, fo, Tsampling)
            fs = 1/Tsampling;
            f = linspace(-fs/2, fs/2, N);
            val = zeros(1, length(f));
            for i = 1:length(f)
                ff = f(i) - fo;
                if ff >= fs/2
                    ff = ff - fs;
                elseif ff <= -fs/2
                    ff = ff + fs;
                end
                if abs(ff) <= (1-alpha)/2/Ts
                    val(i) = 0;
                elseif abs(ff) > (1-alpha)/2/Ts && abs(ff) <= (1+alpha)/2/Ts
                    val(i) = -0.5*(sin((pi*Ts/alpha) * (abs(ff) - (1-alpha)/2/Ts)));
                    val(i) = val(i) * pi * Ts / alpha;
                    if f(i) > fo
                        val(i) = val(i) * -1;
                    end
                else
                    val(i) = 0;
                end
            end
            val = val*Ts;
        end
    end
end