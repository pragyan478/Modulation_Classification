function error = class_10_new(cent)
error=1000;
if length(cent)==64
        [max_2, indx2] = maxk(abs(cent),4);
        point = [];
        for l = 1:4
            temp = abs(cent - cent(indx2(l)));
            %disp(cent(indx2(l)));
            
            [min, indx] = mink(temp,3);
            %scatterplot([cent(indx(1)) cent(indx(2)) cent(indx(3))])
            m_1 = (imag(cent(indx(2)))-imag(cent(indx(1))))/(real(cent(indx(2)))- real(cent(indx(1))));
            %disp(m_1);
            d_1 = sqrt((imag(cent(indx(2)))-imag(cent(indx(1))))^2 + (real(cent(indx(2)))- real(cent(indx(1))))^2);
            m_2 = (imag(cent(indx(3)))-imag(cent(indx(1))))/(real(cent(indx(3)))- real(cent(indx(1))));
            d_2 = sqrt((imag(cent(indx(3)))-imag(cent(indx(1))))^2 + (real(cent(indx(3)))- real(cent(indx(1))))^2);
            m  = [m_1 m_2];
            d  = [d_1 d_2];
            point_new_1 = [cent(indx2(l))];
            sign1 = 1;
            sign2 = 1;
            if(real(cent(indx(2)))<real(cent(indx(1))))
                sign1 = -1;
            end
            if(real(cent(indx(3)))<real(cent(indx(1))))
                sign2 = -1;
            end
            for j = 1:3
                        y_new_1 = imag(cent(indx(1))) + m_2*sign2*(j*d_2/(sqrt(1+m_2^2)));
                        x_new_1 = real(cent(indx(1))) + j*sign2*d_2/sqrt(1+m_2^2);
                        point_new_1 = [point_new_1 complex(x_new_1,y_new_1)];
            end
            for i = 1:3
                    y_new = imag(cent(indx(1))) + m_1*sign1*(i*d_1/(sqrt(1+m_1^2)));
                    x_new = real(cent(indx(1))) + i*sign1*d_1/sqrt(1+m_1^2);
                    point_new_1 = [point_new_1 complex(x_new,y_new)];
                    for j = 1:3
                        y_new_1 = y_new + m_2*sign2*(j*d_2/(sqrt(1+m_2^2)));
                        x_new_1 = x_new + j*sign2*d_2/sqrt(1+m_2^2);
                        point_new_1 = [point_new_1 complex(x_new_1,y_new_1)];
                    end
            end
        point = [point point_new_1];
        end
        %scatterplot(point);
        dis =0;
        for i = 1:64
            min =100;
            for j = 1:64
                    d = norm(point(i) - cent(j));            
                if(min>d)
                    min = d;
                end
                
            end
            dis = dis + min;
        end
        %scatterplot(point)
        dis = dis/64;
        error = dis;
end
end