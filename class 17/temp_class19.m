function error = temp_class19(cent)
K = length(cent);
error=1000;
if K ==32
    %scatterplot(cent);
    [min,ind] = mink(abs(cent),4);
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
%     for i=1:4
%     %scatterplot(cent(indd(i)))
%     end
    temp = zeros(4,4);
    
    for i = 1:4
        if i==1
    z =  cent(indd(i))-cent(indd(i+3));

    temp(i,:) = cent(ind)+2*z;
    %scatterplot(temp(i,:));
        else
    z =  cent(indd(i))-cent(indd((mod((i+3),4))));

    temp(i,:) = cent(ind)+2*z;
    %scatterplot(temp(i,:));
        end
    
    end
    
    min_dis = [];
    for i = 1:4
        min_d =0;
       for j=1:4
           d=1000;
          for m=1:32
              if(norm(temp(i,j)-cent(m))<d)
                  d = norm(temp(i,j) - cent(m));
              end
          end

          min_d = min_d+d;
       end
       min_dis = [min_dis min_d];
    end
    [min_temp,index] = mink(min_dis,4);
    %index
    regsig = [temp(index(1),:) temp(index(2),:) cent(ind(1)) cent(ind(2)) cent(ind(3)) cent(ind(4))];
    %scatterplot(regsig);
    if((index(3))==1)
        dis = cent(indd(index(3))) -cent(indd(4));
    else
        dis = cent(indd(index(3))) -cent(indd(index(3)-1));
    end
    regsig1 = regsig+dis;
    regsig2 = regsig-dis;
    regsig = [regsig regsig1 regsig2];
    %scatterplot(regsig);
    error=0;
    for i=1:24
        d =1000;
       for j = 1:32
           if(norm(regsig(i)-cent(j))<d)
               d=norm(regsig(i)-cent(j));
           end
       end
       error = error+d;
    end
    error = error/24;
end
if K ==64
    
    %scatterplot(cent);
    indx2=[];
    cent1 = [];
    cent2 = [];
    cent3 = [];
    cent4 = [];
    for i =1:64
        
        
       if(real(cent(i))>0 && imag(cent(i))>0)
            cent1 = [cent1 i];
       end
       
    end
    
    for i =1:64
        
        
       if(real(cent(i))<0 && imag(cent(i))>0)
            cent2 = [cent2 i];
       end
       
    end
    for i =1:64
        
        
       if(real(cent(i))<0 && imag(cent(i))<0)
           cent3 = [cent3 i];
       end
       
    end
    for i =1:64
        
        
       if(real(cent(i))>0 && imag(cent(i))<0)
            cent4 = [cent4 i];
       end
       
    end
    [max1 ,ind1] = maxk(abs(cent(cent1)),1);
    [max2 ,ind2] = maxk(abs(cent(cent2)),1);
    [max3 ,ind3] = maxk(abs(cent(cent3)),1);
    [max4 ,ind4] = maxk(abs(cent(cent4)),1);
    indx2 = [cent1(ind1) cent2(ind2) cent3(ind3) cent4(ind4)];
%     scatterplot(cent(cent1));
%     scatterplot(cent(cent2));
%     scatterplot(cent(cent3));
%     scatterplot(cent(cent4));
    
    regenerated_signal = [];
                for l = 1:4
                temp = abs(cent - cent(indx2(l)));
                [min, indx] = mink(temp,3);
                %scatterplot([cent(indx(1))]);
                m_1 = (imag(cent(indx(2)))-imag(cent(indx(1))))/(real(cent(indx(2)))- real(cent(indx(1))));
                %disp(m_1);
                d_1 = sqrt((imag(cent(indx(2)))-imag(cent(indx(1))))^2 + (real(cent(indx(2)))- real(cent(indx(1))))^2);
                m_2 = (imag(cent(indx(3)))-imag(cent(indx(1))))/(real(cent(indx(3)))- real(cent(indx(1))));
                d_2 = sqrt((imag(cent(indx(3)))-imag(cent(indx(1))))^2 + (real(cent(indx(3)))- real(cent(indx(1))))^2);
                m  = [m_1 m_2];
                d  = [d_1 d_2];
                point = [];
                sign1 = 1;
                sign2 = 1;
                if(real(cent(indx(2)))<real(cent(indx(1))))
                    sign1 = -1;
                end
                if(real(cent(indx(3)))<real(cent(indx(1))))
                    sign2 = -1;
                end
                sign = [sign1 sign2];
                for i = 2:3
                    y_new = imag(cent(indx(i))) + m(i-1)*sign(i-1)*(d(i-1)/(sqrt(1+m(i-1)^2)));
                    x_new = real(cent(indx(i))) + sign(i-1)*d(i-1)/sqrt(1+m(i-1)^2);
                    point = [point complex(x_new,y_new)];
                end
                cent1 = cent - point(1);
                cent2 = cent - point(2);
                %scatterplot(point(1));
                [min ind] = mink(abs(cent1),1);
                [min2 ind2] = mink(abs(cent2),1);
                %scatterplot([cent(ind) cent(ind2)]);
                point_new_1 = [cent(indx(1)) cent(indx(2)) cent(indx(3))];
                if(min<min2)
                    for i = 1:2
                        y_new = imag(cent(indx(2))) + m_1*sign1*(i*d_1/(sqrt(1+m_1^2)));
                        x_new = real(cent(indx(2))) + i*sign1*d_1/sqrt(1+m_1^2);
                        point_new_1 = [point_new_1 complex(x_new,y_new)];
                    end
                    for i = 1:3
                        y_new = imag(cent(indx(3))) + m_1*sign1*(i*d_1/(sqrt(1+m_1^2)));
                        x_new = real(cent(indx(3))) + i*sign1*d_1/sqrt(1+m_1^2);
                        point_new_1 = [point_new_1 complex(x_new,y_new)];
                    end
                else
                    for i = 1:2
                        y_new = imag(cent(indx(3))) + m_2*sign2*(i*d_2/(sqrt(1+m_2^2)));
                        x_new = real(cent(indx(3))) + i*sign2*d_2/sqrt(1+m_2^2);
                        point_new_1 = [point_new_1 complex(x_new,y_new)];
                    end
                    for i = 1:3
                        y_new = imag(cent(indx(2))) + m_2*sign2*(i*d_2/(sqrt(1+m_2^2)));
                        x_new = real(cent(indx(2))) + i*sign2*d_2/sqrt(1+m_2^2);
                        point_new_1 = [point_new_1 complex(x_new,y_new)];
                    end
                end
                regenerated_signal = [regenerated_signal point_new_1];
                %scatterplot(point_new_1);
                end
                %scatterplot(regenerated_signal);
                error=0;
                dis =0;
                for i = 1:32
                    min =100;
                    for j = 1:64
                            d = norm(regenerated_signal(i) - cent(j));            
                        if(min>d)
                            min = d;
                        end
                        
                    end
                    dis = dis + min;
                end
                dis = dis/32;
                %dis
                error = dis;
                [minxx,index23] = mink(abs(cent),1);
                error = (error+abs(cent(index23)))/2;
end
end
