function order1 = order(asd)
%%
dd = size(asd);
zz = dd(1,2);
for i = 1:zz
     asd(:,i) = asd(:,i)/sqrt(mean((abs(asd(:,i))).^2));
end
 
for qq = 1:100
    qwe = [real(asd(:,qq)) imag(asd(:,qq))];

minpts = 50;

[RD, CD, order ] = optics(qwe, minpts);
xx = RD(order);

pks = findpeaks(xx);


if nnz(pks) == 1
    threshold = .4*pks;
elseif nnz(pks)>1
    sort_pks = sort(pks,'descend');
    threshold = .4*mean(sort_pks(1:2));
end


pks1 = pks;

for i = 1:length(pks)
      if pks(i) < threshold;
          pks(i) = 0;
      end
end

temp = nnz(pks);
temp = temp+1;
  
for n = 1:9
    qq1(n) = abs(2^n - temp);
end
[value index] = min(qq1);
order1(qq) = 2^index;
end

  accuracy_2 = nnz(order1==2);
 accuracy_4 = nnz(order1==4);
 accuracy_8 = nnz(order1==8);
 accuracy_16 = nnz(order1==16);
 accuracy_32 = nnz(order1==32);
 accuracy_64 = nnz(order1==64);
 
 %%
end