function cum = moment_statistics(sig)


%%% second order %%%%
% 
c20 = hos(sig,2,0);
c21 = hos(sig,2,1);

%%% fourth order %%%%%

c40 = hos(sig,4,0)-3*hos(sig,2,0)^2;
c41 = hos(sig,4,0)-3*hos(sig,2,0)*hos(sig,2,1);
c42 = hos(sig,4,2)-abs(hos(sig,2,0))^2-2*hos(sig,2,1)^2;

%% sixth order %%%%%%
c60 = hos(sig,6,0)-15*hos(sig,2,0)*hos(sig,4,0)+30*hos(sig,2,0)^3;
c61 = hos(sig,6,1)-5*hos(sig,2,1)*hos(sig,4,0)-10*hos(sig,2,0)*hos(sig,4,1)+30*hos(sig,2,0)^2*hos(sig,2,1);
c62 = hos(sig,6,2)-6*hos(sig,2,0)*hos(sig,4,2)-8*hos(sig,2,1)*hos(sig,4,1)-hos(sig,2,2)*hos(sig,4,0)+6*hos(sig,2,0)^2*hos(sig,2,2)+24*hos(sig,2,1)^2*hos(sig,2,0);
c63 = hos(sig,6,3)-9*hos(sig,2,1)*hos(sig,4,2)+12*hos(sig,2,1)^3-3*hos(sig,2,0)*hos(sig,4,3)-3*hos(sig,2,2)*hos(sig,4,1)+18*hos(sig,2,0)*hos(sig,2,1)*hos(sig,2,2);
c62 = hos(sig,6,2)-15*hos(sig,4,0)*hos(sig,2,2)-20*(hos(sig,3,1))^2+30*hos(sig,4,0)*(hos(sig,2,0))^2+60*hos(sig,4,0)*(hos(sig,1,1))^2+ 240*hos(sig,3,1)*hos(sig,1,1)*hos(sig,2,0)+ 90*hos(sig,2,2)*(hos(sig,2,0))^2-90*(hos(sig,2,0))^4-540*((hos(sig,2,0))^2)*(hos(sig,1,1))^2;
%% eighth order %%%%%%
c80 = hos(sig,8,0)-35*(hos(sig,4,0))^2-630*(hos(sig,2,0))^4+420*((hos(sig,2,0))^2)*hos(sig,4,0);
c81 = hos(sig,8,1)-35*hos(sig,4,0)*hos(sig,4,1)-630*((hos(sig,2,0))^3)*hos(sig,2,1)+210*hos(sig,4,0)*hos(sig,2,0)*hos(sig,2,1)+210*hos(sig,2,0)*hos(sig,4,1);
c82 = hos(sig,8,2)-15*hos(sig,4,0)*hos(sig,4,2)-20*hos(sig,4,1)^2+30*hos(sig,4,0)*(hos(sig,2,0)^2)+60*hos(sig,4,0)*(hos(sig,2,1))^2+240*hos(sig,4,1)*hos(sig,2,1)*hos(sig,2,0)+ 90*hos(sig,4,2)*(hos(sig,2,0))^2-90*(hos(sig,2,0))^4-540*((hos(sig,2,0))^2)*((hos(sig,2,1))^2);
c83 = hos(sig,8,3)-5*hos(sig,4,0)*hos(sig,4,1)-30*hos(sig,4,1)*hos(sig,4,2)+ 90*hos(sig,4,1)*(hos(sig,2,0))^2+120*hos(sig,4,1)*((hos(sig,2,1))^2)+180*hos(sig,4,2)*hos(sig,2,1)*hos(sig,2,0) +30*hos(sig,4,0)*hos(sig,2,0)*hos(sig,2,1)-270*((hos(sig,2,0))^3)*hos(sig,2,1)-360*((hos(sig,2,1))^3)*hos(sig,2,0);
c84 = hos(sig,8,4)-(hos(sig,4,0))^2-18*(hos(sig,4,2))^2-16*(hos(sig,4,1))^2-54*(hos(sig,2,0))^4-144*(hos(sig,2,1))^4-432*((hos(sig,2,0))^2)*((hos(sig,2,1))^2)+12*hos(sig,4,0)*((hos(sig,2,0))^2)+96*hos(sig,4,1)*hos(sig,2,1)*hos(sig,2,0)+144*hos(sig,4,2)*(hos(sig,2,1))^2 + 72*hos(sig,4,2)*(hos(sig,2,0))^2+96*hos(sig,4,1)*hos(sig,2,0)*hos(sig,2,1);
cum= [c20; c21; c40; c41; c42; c60; c61; c62; c63; c80; c81; c82; c83; c84];


end