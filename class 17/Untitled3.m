function error = Untitled3(cent)
       [m,ind] = maxk(abs(cent),4);
       dis12 = norm(cent(ind(2))-cent(ind(1)));
       dis13 = norm(cent(ind(3))-cent(ind(1)));
       dis14 = norm(cent(ind(4))-cent(ind(1)));
       regig=[];
       dis = [dis12 dis13 dis14];
%        dis
       min(dis)
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
