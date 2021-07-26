function class = untitled(sig1)

X = [real(sig1), imag(sig1)];
E = evalclusters(X,'linkage','silhouette','KList',[4,8,16,32,64,128]);
plot(E)




if E.OptimalK == 32
    cent = [];
    for d = 1:E.OptimalK
        cent = [cent mean(sig1(find(E.OptimalY==d)))];
    end
    
    cent = cent';
    scatterplot(cent);
    [max_2, indx2] = maxk(abs(cent),4);
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
                scatterplot(regenerated_signal);
end