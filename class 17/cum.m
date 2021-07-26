theta = [-3.1:0.1:3.1];
result = [];

for i = 1:63
    temp3 = [];
    %a = [2 -2 2j -2j];
    %b = [-cos(theta(i))+1j*sin(theta(i)) -cos(theta(i))-1j*sin(theta(i)) cos(theta(i))-1j*sin(theta(i)) cos(theta(i))+1j*sin(theta(i))];
    %b = 2*[-1 1 1j -1j (1+1j)/sqrt(2) (1-1j)/sqrt(2) (-1+1j)/sqrt(2) (-1-1j)/sqrt(2)];
    b = 2*[-1 1];
    %a = [cos(theta(i))+1j*sin(theta(i)) cos(theta(i)+0.78539816339)+1j*sin(theta(i)+0.78539816339) cos(theta(i)+2*0.78539816339)+1j*sin(theta(i)+2*0.78539816339) cos(theta(i)+3*0.78539816339)+1j*sin(theta(i)+3*0.78539816339) cos(theta(i)+4*0.78539816339)+1j*sin(theta(i)+4*0.78539816339) cos(theta(i)+5*0.78539816339)+1j*sin(theta(i)+5*0.78539816339) cos(theta(i)+6*0.78539816339)+1j*sin(theta(i)+6*0.78539816339) cos(theta(i)+7*0.78539816339)+1j*sin(theta(i)+7*0.78539816339)];
    a=[cos(theta(i))+1j*sin(theta(i)) -(cos(theta(i))+1j*sin(theta(i)))];
    res =0;
    for j=1:2
       for k = 1:2
           temp = a(j) +b(k);
           %temp1 = temp*temp';
           temp3 = [temp3 temp];
           %temp1 = temp*temp*temp*temp;
           %temp2 = temp*temp;
           %temp2 = 0;
           %res = res+temp1-3*temp2;
       end
    end
    
    temp3 = temp3/sqrt(mean((abs(temp3)).^2));
    %scatterplot(temp3)
    result = [result abs(hos(temp3,2,0))];
end
%figure(1)
%scatterplot(temp3);
figure(2)
plot(theta,(result))
