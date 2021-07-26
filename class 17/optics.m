function [RD1,CD1,order1]=optics(x,k)

[m,n]=size(x);
CD1=zeros(1,m);
RD1=ones(1,m)*10^10;

% Calculate Core Distances
for i=1:m        
    D=sort(dist_test(x(i,:),x));
    CD1(i)=D(k+1);  
end

order1=[];
seeds=[1:m];

ind=1;

while ~isempty(seeds)
    ob=seeds(ind);        
    seeds(ind)=[]; 
    order1=[order1 ob];
    mm=max([ones(1,length(seeds))*CD1(ob);dist_test(x(ob,:),x(seeds,:))]);
    ii=(RD1(seeds))>mm;
    RD1(seeds(ii))=mm(ii);
    [i1 ind]=min(RD1(seeds));
    
end   

RD1(1)=max(RD1(2:m))+.1*max(RD1(2:m));
end