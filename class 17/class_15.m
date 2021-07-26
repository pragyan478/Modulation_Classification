function class = class_15(sig1)

X = [real(sig1), imag(sig1)];
E = evalclusters(X,'linkage','silhouette','KList',[4,8,16,32,64,128]);
plot(E)
if E.OptimalK==4
    class = 1;
end

if E.OptimalK ==8
    
    cent = [];
    for d = 1:E.OptimalK
        cent = [cent mean(sig1(find(E.OptimalY==d)))];
    end
    cent = cent';
%     temp = [real(cent),imag(cent)];
%     dist = pdist(temp);
%     Z = squareform(dist);
     
      [max_2, indx2] = maxk(abs(cent),2);
    
    temp1 = abs(cent - cent(indx2(1)));
    temp2 = abs(cent - cent(indx2(2)));
    
    [min1_4, idx1_4] = mink(temp1,4);
    [min2_4, idx2_4] = mink(temp2,4);
    
    centered1_4 = cent(idx1_4)-mean(cent(idx1_4));
    centered2_4 = cent(idx2_4)-mean(cent(idx2_4));   
    qp = [abs(centered1_4), abs(centered2_4)];
    
    if var(abs(qp))<.007
        class = 2;
    else
        class = 6;
    end
end


if E.OptimalK ==16
    
    cent = [];
    for d = 1:E.OptimalK
        cent = [cent mean(sig1(find(E.OptimalY==d)))];
    end
    
    cent = cent';
    temp = [real(cent),imag(cent)];
    dist = pdist(temp);
    Z = squareform(dist);
    
    %%%% for 2BPSK-8PSK %%%%%%%
    %     [r1, r2] = find(ismember(Z, max(Z(:))));
    %     [minValues1, idx1] = mink(Z(:,r1(1)),E.OptimalK/2);
    %     [minValues2, idx2] = mink(Z(:,r1(2)),E.OptimalK/2);
    
    [min_8, indx2] = maxk(abs(cent),E.OptimalK/2);
    [minValues1, idx1] = mink(Z(:,indx2(1)),E.OptimalK/2);
    [minValues2, idx2] = mink(Z(:,indx2(2)),E.OptimalK/2);
    
    psk8_1 =  cent(idx1) - mean(cent(idx1));
    psk8_2 =  cent(idx2) - mean(cent(idx2));
    
    p8 = [psk8_1; psk8_2];
    
    if var(abs(p8))<.01
        class = 3;
    else
        
        %%%%%% for 2QPSK-QPSK %%%%%%%
        
        [min_4, indx4] = maxk(abs(cent),E.OptimalK/4);
        
        [minValues_qp1, idx_qp1] = mink(Z(:,indx4(1)),E.OptimalK/4);
        [minValues_qp2, idx_qp2] = mink(Z(:,indx4(2)),E.OptimalK/4);
        [minValues_qp3, idx_qp3] = mink(Z(:,indx4(3)),E.OptimalK/4);
        [minValues_qp4, idx_qp4] = mink(Z(:,indx4(4)),E.OptimalK/4);
        
        qpsk_1 = mean(cent(idx_qp1));
        qpsk_2 = mean(cent(idx_qp2));
        qpsk_3 = mean(cent(idx_qp3));
        qpsk_4 = mean(cent(idx_qp4));
        
        
        qpp = [qpsk_1, qpsk_2, qpsk_3, qpsk_4];
        aa1 = sort(radtodeg(angle(qpp)))+360;
        
        ss = [];
        tempp= [];
        tempp = [aa1,aa1(1)];
        for d = 1:length(tempp)-1
            ss(d) = tempp(d+1)-tempp(d);
        end
        ss = mod(ss,360);
        if  sum((85 < ss)&(ss < 95))==4
            class = 7;
        else
            [min_2, indx_2] = maxk(abs(cent),2);
            [minValues_qam1, idx_qam1] = mink(Z(:,indx_2(1)),8);
            [minValues_qam2, idx_qam2] = mink(Z(:,indx_2(2)),8);
            
            qam_8_1 = cent(idx_qam1) - mean(cent(idx_qam1));
            qam_8_2 = cent(idx_qam2) - mean(cent(idx_qam2));
            
            
            
            temp1 = [real(qam_8_1),imag(qam_8_1)];
            dist1 = pdist(temp1);         
            Z1 = squareform(dist1);
            [max_qam_temp1,indx_temp1] = maxk(abs(qam_8_1),2);
            [min_qam_temp1,indx_1] = mink(Z1(:,indx_temp1(1)),4);
            [min_qam_temp2,indx_2] = mink(Z1(:,indx_temp1(2)),4);
            qps1 = qam_8_1(indx_1) - mean(qam_8_1(indx_1));
            qps2 = qam_8_1(indx_2) - mean(qam_8_1(indx_2));
            
            
            temp2 = [real(qam_8_2),imag(qam_8_2)];
            dist2 = pdist(temp2);         
            Z2 = squareform(dist2);
            [max_qam_temp2,indx_temp2] = maxk(abs(qam_8_2),2);
            [min_qam_temp3,indx_3] = mink(Z2(:,indx_temp2(1)),4);
            [min_qam_temp4,indx_4] = mink(Z2(:,indx_temp2(2)),4);
            qps3 = qam_8_2(indx_3) - mean(qam_8_2(indx_3));
            qps4 = qam_8_2(indx_4) - mean(qam_8_2(indx_4));
            qps = [qps1, qps2, qps3, qps4];
            %plot(real(qps),imag(qps),'*');
            
            aa1 = sort(radtodeg(angle(qps1)))+360;
            aa2 = sort(radtodeg(angle(qps2)))+360;
            aa3 = sort(radtodeg(angle(qps3)))+360;
            aa4 = sort(radtodeg(angle(qps4)))+360;
            %disp(size(aa1));
            %disp(size(aa1(1)));
            ss1 = [];
            ss2 = [];
            ss3 = [];
            ss4 = [];
            tempp1= [];
            tempp2= [];
            tempp3= [];
            tempp4= [];
            tempp1 = [aa1;aa1(1)];
            %disp(size(tempp1));
            tempp2 = [aa2;aa2(1)];
            tempp3 = [aa3;aa3(1)];
            tempp4 = [aa4;aa4(1)];
            for d = 1:length(tempp1)-1
               ss1(d) = tempp1(d+1)-tempp1(d);
               ss2(d) = tempp2(d+1)-tempp2(d);
               ss3(d) = tempp3(d+1)-tempp3(d);
               ss4(d) = tempp4(d+1)-tempp4(d);
            end
            
            ss1 = mod(ss1,360);
            ss2 = mod(ss2,360);
            ss3 = mod(ss3,360);
            ss4 = mod(ss4,360);
            if  sum((85 < ss1)&(ss1 < 95)) + sum((85 < ss2)&(ss2 < 95)) + sum((85 < ss3)&(ss3 < 95))+ sum((85 < ss4)&(ss4 < 95))==16
                class =4;
            else
                [max_2, indx2] = maxk(abs(cent),2);
                regenerated_signal = [];
                for l = 1:2
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
                dis =0;
                for i = 1:16
                    min =100;
                    for j = 1:16
                            d = norm(regenerated_signal(i) - cent(j));            
                        if(min>d)
                            min = d;
                        end
                        
                    end
                    dis = dis + min;
                end
                if(dis<.2)
                    class =16;
                else
                    class=11;
                end
            end
        end
    end
end

if E.OptimalK ==32
    
    cent = [];
    for d = 1:E.OptimalK
        cent = [cent mean(sig1(find(E.OptimalY==d)))];
    end
    
    cent32 = cent;
    
    [max_2, indx2] = maxk(abs(cent32),2);
    
    temp1 = abs(cent32 - cent32(indx2(1)));
    temp2 = abs(cent32 - cent32(indx2(2)));
    
    [min1_16, idx1_16] = mink(temp1,E.OptimalK/2);
    [min2_16, idx2_16] = mink(temp2,E.OptimalK/2);
    
    centered1_16 = cent32(idx1_16)-mean(cent32(idx1_16));
    centered2_16 = cent32(idx2_16)-mean(cent32(idx2_16));
    
    ss1 = qam16_test(centered1_16);
    ss2 = qam16_test(centered2_16);
    
    if  sum((80 < ss1)&(ss1 < 100))==16 & sum((80 < ss2)&(ss2 < 100))==16
        class = 5;
    else
        [max_2, indx2] = maxk(abs(cent),2);
        point = [];
        for l = 1:2
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
        for i = 1:32
            min =100;
            for j = 1:32
                    d = norm(point(i) - cent(j));            
                if(min>d)
                    min = d;
                end
                
            end
            dis = dis + min;
        end
        if(dis<1.5)
            class = 21;
        else
        
        cent = cent';
        temp = [real(cent),imag(cent)];
        dist = pdist(temp);
        Z = squareform(dist);
        
        [min_4, indx4] = maxk(abs(cent),E.OptimalK/8);
        
        [minValues_1, indx_1] = mink(Z(:,indx4(1)),E.OptimalK/8);
        [minValues_2, indx_2] = mink(Z(:,indx4(2)),E.OptimalK/8);
        [minValues_3, indx_3] = mink(Z(:,indx4(3)),E.OptimalK/8);
        [minValues_4, indx_4] = mink(Z(:,indx4(4)),E.OptimalK/8);
        
        w1 = cent(indx_1) - mean(cent(indx_1));
        w2 = cent(indx_2) - mean(cent(indx_2));
        w3 = cent(indx_3) - mean(cent(indx_3));
        w4 = cent(indx_4) - mean(cent(indx_4));
        
        aa1 = sort(radtodeg(angle(w1)))+360;
        aa2 = sort(radtodeg(angle(w2)))+360;
        aa3 = sort(radtodeg(angle(w3)))+360;
        aa4 = sort(radtodeg(angle(w4)))+360;
    %disp(size(aa1));
    %disp(size(aa1(1)));
        ss1 = [];
        ss2 = [];
        ss3 = [];
        ss4 = [];
        tempp1= [];
        tempp2= [];
        tempp3= [];
        tempp4= [];
        tempp1 = [aa1;aa1(1)];
    %disp(size(tempp1));
        tempp2 = [aa2;aa2(1)];
        tempp3 = [aa3;aa3(1)];
        tempp4 = [aa4;aa4(1)];
        for d = 1:length(tempp1)-1
           ss1(d) = tempp1(d+1)-tempp1(d);
           ss2(d) = tempp2(d+1)-tempp2(d);
           ss3(d) = tempp3(d+1)-tempp3(d);
           ss4(d) = tempp4(d+1)-tempp4(d);
        end
            
        ss1 = mod(ss1,360);
        ss2 = mod(ss2,360);
        ss3 = mod(ss3,360);
        ss4 = mod(ss4,360);
        if  sum((85 < ss1)&(ss1 < 95)) + sum((85 < ss2)&(ss2 < 95)) + sum((85 < ss3)&(ss3 < 95))+ sum((85 < ss4)&(ss4 < 95))==16
            class = 9 ;
            
        else
        [min4, ind4] = maxk(abs(cent),E.OptimalK/8);
        
        [minValues1, indx1] = mink(Z(:,ind4(1)),E.OptimalK/4);
        [minValues2, indx2] = mink(Z(:,ind4(2)),E.OptimalK/4);
        [minValues3, indx3] = mink(Z(:,ind4(3)),E.OptimalK/4);
        [minValues4, indx4] = mink(Z(:,ind4(4)),E.OptimalK/4);
        
        w_1 = cent(indx1) - mean(cent(indx1));
        w_2 = cent(indx2) - mean(cent(indx2));
        w_3 = cent(indx3) - mean(cent(indx3));
        w_4 = cent(indx4) - mean(cent(indx4));
        
        aa_1 = sort(radtodeg(angle(w_1)))+360;
        aa_2 = sort(radtodeg(angle(w_2)))+360;
        aa_3 = sort(radtodeg(angle(w_3)))+360;
        aa_4 = sort(radtodeg(angle(w_4)))+360;
    %disp(size(aa1));
    %disp(size(aa1(1)));
        ss_1 = [];
        ss_2 = [];
        ss_3 = [];
        ss_4 = [];
        tempp_1= [];
        tempp_2= [];
        tempp_3= [];
        tempp_4= [];
        tempp_1 = [aa_1;aa_1(1)];
    %disp(size(tempp1));
        tempp_2 = [aa_2;aa_2(1)];
        tempp_3 = [aa_3;aa_3(1)];
        tempp_4 = [aa_4;aa_4(1)];
        for d = 1:length(tempp_1)-1
           ss_1(d) = tempp_1(d+1)-tempp_1(d);
           ss_2(d) = tempp_2(d+1)-tempp_2(d);
           ss_3(d) = tempp_3(d+1)-tempp_3(d);
           ss_4(d) = tempp_4(d+1)-tempp_4(d);
        end
        disp(ss_1);
        ss_1 = mod(ss_1,360);
        ss_2 = mod(ss_2,360);
        ss_3 = mod(ss_3,360);
        ss_4 = mod(ss_4,360);
        if  sum((35 < ss_1)&(ss_1 < 55)) + sum((35 < ss_2)&(ss_2 < 55)) + sum((35 < ss_3)&(ss_3 < 55))+ sum((35 < ss_4)&(ss_4 < 55))==32
            class = 8 ;
            
        else
            
            class = 12;
        end
            
        end
        
        end
    end
    
    
end

if E.OptimalK ==64
    cent = [];
    for d = 1:E.OptimalK
        cent = [cent mean(sig1(find(E.OptimalY==d)))];   %finding individual cluster centroids
    end
    cent = cent';
    %plot(real(cent),imag(cent),'*');
    temp = [real(cent),imag(cent)];
    dist = pdist(temp);
    Z = squareform(dist);
    
    [max_abs,indx] = maxk(abs(cent),E.OptimalK/16);
    [min_abs1,indx1] = mink(Z(:,indx(1)),4);
    [min_abs1,indx2] = mink(Z(:,indx(2)),4);
    [min_abs1,indx3] = mink(Z(:,indx(3)),4);
    [min_abs1,indx4] = mink(Z(:,indx(4)),4);
    
    sig1 = cent(indx1) - mean(cent(indx1));
    sig2 = cent(indx2) - mean(cent(indx2));
    sig3 = cent(indx3) - mean(cent(indx3));
    sig4 = cent(indx4) - mean(cent(indx4));
    %figure(2)
    %plot(real(sig1),imag(sig1),'*');
    aa1 = sort(radtodeg(angle(sig1)))+360;
    aa2 = sort(radtodeg(angle(sig2)))+360;
    aa3 = sort(radtodeg(angle(sig3)))+360;
    aa4 = sort(radtodeg(angle(sig4)))+360;
    %disp(size(aa1));
    %disp(size(aa1(1)));
    ss1 = [];
    ss2 = [];
    ss3 = [];
    ss4 = [];
    tempp1= [];
    tempp2= [];
    tempp3= [];
    tempp4= [];
    tempp1 = [aa1;aa1(1)];
    %disp(size(tempp1));
    tempp2 = [aa2;aa2(1)];
    tempp3 = [aa3;aa3(1)];
    tempp4 = [aa4;aa4(1)];
    for d = 1:length(tempp1)-1
       ss1(d) = tempp1(d+1)-tempp1(d);
       ss2(d) = tempp2(d+1)-tempp2(d);
       ss3(d) = tempp3(d+1)-tempp3(d);
       ss4(d) = tempp4(d+1)-tempp4(d);
     end
            
     ss1 = mod(ss1,360);
     ss2 = mod(ss2,360);
     ss3 = mod(ss3,360);
     ss4 = mod(ss4,360);
     if  sum((80 < ss1)&(ss1 < 100)) + sum((80 < ss2)&(ss2 < 100)) + sum((80 < ss3)&(ss3 < 100))+ sum((80 < ss4)&(ss4 < 100))>=12
         class =10;
     else
         [min_Value,indices] = mink(abs(cent),8);
         signal = cent(indices);
         %figure(3)
         %plot(real(signal),imag(signal),'*');
         aa = sort(radtodeg(angle(signal)))+360;
         %disp(aa);
         ss = [];
         tempp = [];
         tempp = [aa;aa(1)];
         for d = 1:length(tempp) - 1
             ss(d) = tempp(d+1) - tempp(d);
         end
         
         ss = mod(ss,360);
         disp(ss);
         disp(sum((ss>35)&(ss<55)));
         if sum((35<ss)&(ss<55))>=6
             class = 13;
         else
             class = 14;
         end      
     end

end

if E.OptimalK ==128
    class = 15;
end