function mom = hos(sig,p,q)
mom = mean(sig.^(p-q).*conj(sig).^q);
end