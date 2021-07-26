M5=8;k5=log2(M5);n5=k5*1;
theta1 = 0;
theta2 = 0;
k=4;
Symbols51 = qammod([0:M5-1],M5,'UnitAveragePower',true);
Symbols52 = qammod([0:M5-1],M5,'UnitAveragePower',true);
scatterplot(Symbols51);
y = [];
for i = 1:length(Symbols51)
   for j =1:length(Symbols52)
      y = [y k*Symbols51(i)*exp(1i*theta1)+Symbols52(j)*exp(1i*theta2)]; 
   end
end

y = (y)/sqrt(mean((abs(y)).^2));
scatterplot(y);
hos(y,2,0)