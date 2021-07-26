function error = class_17(cent,K)
error=1000;
if(K==15)
    [m,ind] = maxk(abs(cent),4);
       dis12 = norm(cent(ind(2))-cent(ind(1)));
       dis13 = norm(cent(ind(3))-cent(ind(1)));
       dis14 = norm(cent(ind(4))-cent(ind(1)));
       regig=[];
       dis = [dis12 dis13 dis14];
%        dis
       %min(dis)
       [ma,max1] = maxk(dis,1);
       [ma2,min1] = mink(dis,1);
%        max1
%        min1
       mid = 6-max1-min1;
%        mid
       max_ind = ind(1+max1);
       min_ind = ind(1+min1);
       mid_ind = ind(1+mid);
       regsig = [cent(ind(1)) cent(ind(2)) cent(ind(3)) cent(ind(4))];
%        scatterplot(cent(ind(1)));
%        scatterplot(cent(max_ind));
%        scatterplot(cent(min_ind));
%        scatterplot(cent(mid_ind));
       z1 = (cent(min_ind)-cent(ind(1)))/2;
       regsig = [regsig cent(ind(1))+z1];
%        scatterplot(regsig)
       z2 = (cent(mid_ind)-cent(ind(1)))/4;
       regsig = [regsig cent(ind(1))+z2 cent(ind(1))+2*z2 cent(ind(1))+3*z2 ];
%        scatterplot(regsig)
       regsig = [regsig cent(ind(1))+z2+z1 cent(ind(1))+2*z2+z1 cent(ind(1))+3*z2+z1 cent(mid_ind)+z1 cent(ind(1))+z2+2*z1 cent(ind(1))+2*z2+2*z1 cent(ind(1))+3*z2+2*z1];
       %scatterplot(regsig)
       error=0;
       for i =1:15
           d=1000;
          for j=1:15
              if(norm(regsig(i)-cent(j))<d)
                 d = norm(regsig(i)-cent(j)); 
              end
          end
          error = error+d;
       end
       error = error/15;
    
end
if(K==32)
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
end