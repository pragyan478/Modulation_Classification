
run 'parameters.m'

 

% RRC filter design
rrcFilter1 = rcosdesign(beta_1, span, sps);
rrcFilter2 = rcosdesign(beta_2, span, sps);

% Make sure that F1 and F2  are less than 2/(SPS*4). In the sampling
% domain, we cannot do better than 1/4 since the QAM has an ambiguity of
% pi/4.
F1 = 0.01;
F2 = 0.0101;
lag = 8; % Time lag between samples.

 mmse =[];
for No_samp  = [1000000];
    error=[];
    for times =1:20
        %% TX Generation
        % User1
        
        data1 = randi([0 mod_1-1], No_samp, 1);
        modData1 = qammod(data1, mod_1,'UnitAveragePower',true);
        
        % User 2
        data2 = randi([0 mod_2-1], No_samp, 1);
        modData2 = qammod(data2, mod_2,'UnitAveragePower',true);
        
        % Upsample the data and filter the data
        txSig1=   upfirdn(modData1, rrcFilter1, sps,1);
        txSig2 =  upfirdn(modData2, rrcFilter2, sps,1);
        
        
        
        %% Channel
        
        txSig_freq1 = 1*exp(1i*pi*F1*(1:length(txSig1))).*txSig1.';
        txSig_freq2 = 0.35*exp(1i*pi*F2*(1:length(txSig2))).*txSig2.';
        
        txSig = txSig_freq1(lag:end) +txSig_freq2(1:end-(lag-1));
        
        snr = EbNo  - 10*log10(sps);
        rxSig = awgn(txSig, snr, 'measured');
        
        
        
        
        %% Receiver
        
        % Will there be Doppler estimation that is requried?
        
        %First detect if it is a CNC signal?
        
        % Residual frequency estimation. Put an arma process and track
        % the frequency.
        rrcFilter3 = rcosdesign(1, span*2, sps);
        [F_est_final]=CNC_freq_est(rxSig,rrcFilter3,sps)
        %https://www.wirelessinnovation.org/assets/Proceedings/2008/sdr08-1.4-3-schreuder.pdf
        
        % optimal sample timing 
        
        % Beta factor estimation
        
        % Symbol timing estimation
        
        % Channel gain (tap) estimation
        
        % Modulation estimation
        
        % FEC estimation
        
        FE_input = sort([F1,F2]);
        if(length(F_est_final) == 2)
            error = [error norm(sort(F_est_final)'-FE_input ).^2];
            f_final=[];
        else
            error=[error norm(FE_input ).^2];
            f_final=[];
            
        end
    end
    mmse =[mmse mean(error)];
    
end
%% Now do the logic for finding the stuff.



% grid on
% [tb,btns] = axtoolbar({'zoomin','zoomout','restoreview'});
% hold on


% expo=4;
%
% ABC= rxFilt.^expo;
% pmusic(ABC,4);
%plot(f1,20*log10(abs(p1)));
% plot(f2,20*log10(abs(p2)),'r')

% Correlator

% Check espint and minnorm






