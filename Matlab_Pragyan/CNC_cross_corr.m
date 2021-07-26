function[corr] = CNC_cross_corr(rxSig,L)

cor_len =floor(length(rxSig)/4);
cor_len_2 = floor(cor_len/2);
Y1= rxSig((-cor_len_2:1:cor_len_2)+cor_len);
corr= zeros(1,L);
for k=-L/2:1:L
    Y2 = rxSig(k+(-cor_len_2:1:cor_len_2)+cor_len);
    corr(k+L/2+1) = Y1*Y2';
end


end
