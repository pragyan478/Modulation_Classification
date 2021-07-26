
function [D]=dist_test(i,x)
[m,n]=size(x);
D1 =((sum((((ones(m,1)*i)-x).^2)')));
D = sqrt(D1);

if n==1
   D=abs((ones(m,1)*i-x))';
end