function error = class_18_2(cent)
    %scatterplot(cent);
    error =0;
    [min,ind] = mink(abs(cent),5);
    indd = [];
     for i=2:5
        if(real(cent(ind(i)))>0 && imag(cent(ind(i)))>0)
            indd = [indd ind(i)];
        end
     end
    for i=2:5
        if(real(cent(ind(i)))<0 && imag(cent(ind(i)))>0)
            indd = [indd ind(i)];
        end
     end
    for i=2:5
        if(real(cent(ind(i)))<0 && imag(cent(ind(i)))<0)
            indd = [indd ind(i)];
        end
     end
    for i=2:5
        if(real(cent(ind(i)))>0 && imag(cent(ind(i)))<0)
            indd = [indd ind(i)];
        end
    end
%     for i=1:4
%     scatterplot(cent(indd(i)))
%     end
    temp = zeros(4,5);
    
    for i = 1:4
    if(i<3)
    z =  cent(indd(i))-cent(indd((i+2)));

    temp(i,:) = cent(ind)+z;
    %scatterplot(temp(i,:));
    end
    if(i>2)
    z =  cent(indd(i))-cent(indd((i-2)));

    temp(i,:) = cent(ind)+z;
    %scatterplot(temp(i,:));

    end
    
    end
    
    min_dis = [];
    for i = 1:4
        min_d =0;
       for j=1:5
           d=1000;
          for k=1:32
              if(norm(temp(i,j)-cent(k))<d)
                  d = norm(temp(i,j) - cent(k));
              end
          end

          min_d = min_d+d;
       end
       min_dis = [min_dis min_d];
    end
    [min_temp,index] = mink(min_dis,4);
    %index
    dis1 = cent(indd(index(4))) - cent(ind(1));
    dis2 = cent(indd(index(3))) - cent(ind(1));
    dis3 = cent(indd(index(2))) - cent(ind(1));
    dis4 = cent(indd(index(1))) - cent(ind(1));
    regsig = [temp(index(1),:) temp(index(2),:) cent(indd(index(3))) cent(indd(index(4))) cent(ind(1))];
    %scatterplot(regsig);
    
    for i=1:13
        d =1000;
       for j = 1:32
           if(norm(regsig(i)-cent(j))<d)
               d=norm(regsig(i)-cent(j));
           end
       end
       error = error+d;
    end

    error = error ;
    error = error/15+ abs(cent(ind(1)));
end 