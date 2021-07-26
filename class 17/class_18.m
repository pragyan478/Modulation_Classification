function error = class_18(cent)

[min, ind] = mink(abs(cent),12);
%scatterplot(cent(ind));
indd=[];
 for i=5:8
    if(real(cent(ind(i)))>0 && imag(cent(ind(i)))>0)
        indd = [indd ind(i)];
    end
 end
for i=5:8
    if(real(cent(ind(i)))<0 && imag(cent(ind(i)))>0)
        indd = [indd ind(i)];
    end
 end
for i=5:8
    if(real(cent(ind(i)))<0 && imag(cent(ind(i)))<0)
        indd = [indd ind(i)];
    end
 end
for i=5:8
    if(real(cent(ind(i)))>0 && imag(cent(ind(i)))<0)
        indd = [indd ind(i)];
    end
end
min = zeros(4);
%scatterplot(cent(indd));
for i =1:4
  for j=9:12
    min(i,j-8) = norm(cent(indd(i))-cent(ind(j))); 
  end
end
%min

[min__, inddd1] = mink(min(1,:),1);
[min__, inddd2] = mink(min(2,:),1);
[min__, inddd3] = mink(min(3,:),1);
[min__, inddd4] = mink(min(4,:),1);

in = [ind(inddd1+8) ind(inddd2+8) ind(inddd3+8) ind(inddd4+8)];
%scatterplot(cent(in))


 temp = zeros(4,8);

    for i = 1:4
    if(i<3)
    z =  cent(in(i))-cent(indd((i+2)));

    temp(i,:) = cent(ind(1:8))+z;
    %scatterplot(temp(i,:));
    end
    if(i>2)
    z =  cent(in(i))-cent(indd((i-2)));

    temp(i,:) = cent(ind(1:8))+z;
    %scatterplot(temp(i,:));

    end
    end
    
%     for i=1:4
%         scatterplot(temp(i,:))
%     end
    
    min_dis = [];
    for i = 1:4
        min_d =0;
       for j=1:8
           d=1000;
          for k=1:64
              if(norm(temp(i,j)-cent(k))<d)
                  d = norm(temp(i,j) - cent(k));
              end
          end

          min_d = min_d+d;
       end
       min_dis = [min_dis min_d];
    end
    [min_temp,index] = mink(min_dis,2);


    regsig = [temp(index(1),:) temp(index(2),:) cent(ind(1)) cent(ind(2)) cent(ind(3)) cent(ind(4)) cent(ind(5)) cent(ind(6)) cent(ind(7)) cent(ind(8))];
    %scatterplot(regsig)
    error =0;
    for i=1:24
        d =1000;
       for j = 1:64
           if(norm(regsig(i)-cent(j))<d)
               d=norm(regsig(i)-cent(j));
           end
       end
       error = error+d;
    end

    error = error/24;
    
end