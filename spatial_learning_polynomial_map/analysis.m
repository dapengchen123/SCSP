N=10;
res = [];
m=zeros(1,N);
for i=1:N
  m(i)=sum(LOSS2(i,:)==0)/316;
end
 res= [res, mean(m)];
for i=1:N
  m(i)=sum(LOSS2(i,:)<=4)/316;
end
 res = [res, mean(m)];
for i=1:N
  m(i)=sum(LOSS2(i,:)<=9)/316;
end
 res = [res, mean(m)];
 for i=1:N
  m(i)=sum(LOSS2(i,:)<=19)/316;
end
 res = [res, mean(m)];
 
for i=1:N
  m(i)=sum(LOSS2(i,:)<=24)/316;
end
 res = [res, mean(m)];
 
for i=1:N
  m(i)=sum(LOSS2(i,:)<=50)/316;
end
 res = [res, mean(m)];
res
