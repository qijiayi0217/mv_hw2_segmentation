function cap=calcap(a,b)

D=sqrt((a.l-b.l)^2+(a.a-b.a)^2+(a.b-b.b)^2+(a.x-b.x)^2+(a.y-b.y)^2);
sum1=histintersect(a.fv,b.fv);
sum2=exp(-D);
cap=sum1+sum2;
%disp(cap);
return