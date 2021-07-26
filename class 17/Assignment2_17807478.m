sigma = 1;
legends = [];

for rho = -10:5:10
    Pd = [];
    Pfa = [];
    Pd_Theoritical = [];
    Pfa_Theoritical = [];
    rho_value = 10^(rho/10);
    s_bar = sqrt(rho_value)*[1 -1 1 -1]';
    s_bar_norm =  norm(s_bar);
    for gamma = -1000:0.2:1000
        nfa=0;
        nd=0;
        for i = 0:1000
            v = randn(4, 1);
            y_H0 = v;
            y_H1 = s_bar+v;
            if dot(s_bar,y_H0)>gamma
                nfa = nfa+1;
            end
            if dot(s_bar,y_H1)>gamma
                nd = nd+1;
            end
        end
        Pd = [Pd nd/1000];
        Pfa = [Pfa nfa/1000];
        
        Pd_Theoritical = [Pd_Theoritical qfunc((gamma-s_bar_norm^2)/(sigma*s_bar_norm))];
        Pfa_Theoritical = [Pfa_Theoritical qfunc((gamma)/(sigma*s_bar_norm))];
    end
    plot(Pfa_Theoritical, Pd_Theoritical);
    legends = [legends strcat('RHO_{Theoretical}=',string(rho))];
    hold on;
    plot(Pfa, Pd, '-.');
    hold on;
    legends = [legends strcat('RHO_{Simulated}=',string(rho))];
end
legend(legends);
xlabel('P\_FA');
ylabel('P\_D');
title('ROC Curve');