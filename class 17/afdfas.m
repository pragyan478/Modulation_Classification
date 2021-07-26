function [error] = afdfas(cent)
    error=0;
    [min, ind] = mink(abs(cent),8);
    %scatterplot(cent(ind));
    %loop
     indd = [];
     for i=1:4
        if(real(cent(ind(i)))>0 && imag(cent(ind(i)))>0)
            indd = [indd ind(i)];
        end
     end
    for i=1:4
        if(real(cent(ind(i)))<0 && imag(cent(ind(i)))>0)
            indd = [indd ind(i)];
        end
     end
    for i=1:4
        if(real(cent(ind(i)))<0 && imag(cent(ind(i)))<0)
            indd = [indd ind(i)];
        end
     end
    for i=1:4
        if(real(cent(ind(i)))>0 && imag(cent(ind(i)))<0)
            indd = [indd ind(i)];
        end
    end
    min = zeros(4);
    for i =1:4
      for j=5:8
        min(i,j-4) = norm(cent(indd(i))-cent(ind(j))); 
      end
    end


    [min__, inddd1] = mink(min(1,:),1);
    [min__, inddd2] = mink(min(2,:),1);
    [min__, inddd3] = mink(min(3,:),1);
    [min__, inddd4] = mink(min(4,:),1);

    in = [ind(inddd1+4) ind(inddd2+4) ind(inddd3+4) ind(inddd4+4)];

    %cent(in)

    temp = zeros(4);

    for i = 1:4
    if(i<3)
    z =  cent(in(i))-cent(indd((i+2)));

    temp(i,:) = cent(indd)+z;
    %scatterplot(temp(i,:));
    end
    if(i>2)
    z =  cent(in(i))-cent(indd((i-2)));

    temp(i,:) = cent(indd)+z;
    %scatterplot(temp(i,:));

    end
    end
    min_dis = [];
    for i = 1:4
        min_d =0;
       for j=1:4
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
    [min_temp,index] = mink(min_dis,2);


    regsig = [temp(index(1),:) temp(index(2),:) cent(indd(1)) cent(indd(2)) cent(indd(3)) cent(indd(4))];
    %scatterplot(regsig);
    
    for i=1:12
        d =1000;
       for j = 1:32
           if(norm(regsig(i)-cent(j))<d)
               d=norm(regsig(i)-cent(j));
           end
       end
       error = error+d;
    end

    error = error/12;
end


