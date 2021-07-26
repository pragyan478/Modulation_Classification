function mom = Theoretical_Moments(k,p,q,m1,m2,theta1,theta2)
mom = k^p*((m1.^(p-q)).*((conj(m1)).^q))*exp(1j*(theta1)*(p-2*q)) + (p-q)*(k^(p-1))*(m1.^(p-q-1)).*(m2).*((conj(m1)).^(q))*exp(1j*((p-2*q-1)*theta1 + theta2)) + ((p-q)*(p-q-1)/2)*(k^(p-2)).*(m1.^(p-q-2)).*(m2.^2).*(conj(m1).^(q)).*exp(1j*((p-2*q-2)*theta1 +2*theta2)) + ((q*(q-1))/2)*(k^(p-2)).*(m1.^(p-q)).*(conj(m1)^(q-2)).*(conj(m2).^2).*exp(1j*((p-2*q+2)*theta1-theta2)) +(k^(p-1))*q.*(m1^(p-q)).*(conj(m2)).*((conj(m1)^(q-1))).*exp(1j*((p-2*q+1)*theta1 - theta2)) +(k^(p-2))*(p-q)*q.*(m2.*(conj(m2))).*(m1^(p-q-1)).*(conj(m1)^(q-1)).*exp(1j*((p-2*q)*theta1));
mom = mean(mom);

end