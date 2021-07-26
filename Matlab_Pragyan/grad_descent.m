function [a1, a2, fo1, fo2, diff] = grad_descent(psd, Tsampling, T1, T2, f01, f02)
    % CNC_BETA_ESTIMATE
    % We estimate the roll offs of the two carriers, given the symbol times
    % of both carriers (in relation to sampling time). 
    % The method involves fitting the psd curve obtained to the theoretical
    % psd expected when two independent carriers overlap. Method used is
    % projection of "psd" vector into "theoretical psd vector space".
    % Paramters for best fit are then chosen to maximise the projection.
    % Parameters obtained by gradient descent (the error is an approximate 
    % parabola wrt all the variables, realised empirically).
    %
    % The method tries estimating fo1 and fo2 loosely too. It also accounts
    % the difference in power levels of the two carriers.
    %
    % Inputs - 
    %   psd       - The PSD of the received signal before MF. (vector)
    %   Tsampling - Sampling rate
    %   T1, T2    - Symbol times of the two carriers. 
    %   f01, f02  - Initial estimate/guess of the frequency offset of both
    %               the carriers
    %
    % Outputs -
    %   a1  - beta estimate of carrier 1
    %   fo1 - frequency offset of carrier 1 (in terms of the ratio of sample rate)
    %   a2  - beta estimate of carrier 2
    %   fo2 - frequency offset of carrier 2 (in terms of the ratio of sample rate)
    %   diff - difference of power levels between carrier 1 and 2 in dB
    %
    %
    % Initial estimates are chosen such that no gradient is zero
    r = 0.5;
    a1 = 0.5; % initial estimate
    a2 = 0.1; % initial estimate
    fo1 = f01;
    fo2 = f02;
    N = length(psd);
    y = psd'/sum(psd); % normalised to unit power
    
    steps = 0;
    while steps < 1000
        steps = steps + 1;
        A1 = psd_gen.S(a1, N, T1, fo1, Tsampling)';
        A2 = psd_gen.S(a2, N, T2, fo2, Tsampling)';
        A = r*A1 + (1-r)*A2;
        Ay = A'*y;
        ATA_1 = inv(A'*A + 1e-20);
        factor = 2*ATA_1*Ay*y - 2*Ay*(ATA_1^2)*Ay*A;
        dA1da1 = r*psd_gen.dSda(a1, N, T1, fo1, Tsampling)';
        dA2da2 = (1-r)*psd_gen.dSda(a2, N, T2, fo2, Tsampling)';
        dA1dfo1 = (r)*psd_gen.dSdfo(a1, N, T1, fo1, Tsampling)';
        dA2dfo2 = (1-r)*psd_gen.dSdfo(a2, N, T2, fo2, Tsampling)';
        dAdr = A1 - A2;
        
        grad = factor'*[dA1da1 dA1dfo1 dA2da2 dA2dfo2 dAdr];

        % backtracking
        step_size = 100;
        beta = 0.5;
        gamma = 1e-6;
        J = Ay*ATA_1*Ay;
        while true
           a1_1 = min(max(a1 + step_size * grad(1), 1e-5),1);
           f1 = fo1 + step_size * grad(2);
           a2_1 = min(max(a2 + step_size * grad(3), 1e-5),1);
           f2 = fo2 + step_size * grad(4);
           A1_1 = psd_gen.S(a1_1, N, T1, f1, Tsampling)';
           A2_1 = psd_gen.S(a2_1, N, T2, f2, Tsampling)';
           r1 = min(max(0, r + step_size * grad(5)), 0.5);
           A_1 = r1*A1_1 + (1-r1)*A2_1;
           ATA_1_2 = inv(A_1'*A_1 + 1e-20);
           JJ = (y'*A_1)*ATA_1_2*(A_1'*y);
           if JJ >= J + gamma*step_size*norm(grad,2)^2
               break
           end
           step_size = beta*step_size;
        end
        
        a1 = min(max(a1 + step_size*grad(1), 1e-5), 1);
        fo1 = fo1 + step_size * grad(2);
        a2 = min(max(a2 + step_size*grad(3), 1e-5), 1);
        fo2 = fo2 + step_size * grad(4);
        r = min(max(0, r + step_size * grad(5)), 0.5);
        
        % stopping criterion
        if norm(grad) < 1e-10
            break
        end
    end
%     a2 = a1;
    diff = 10*log(r/(1-r));
    fo1 = Tsampling*fo1; fo2 = Tsampling*fo2; 
end

