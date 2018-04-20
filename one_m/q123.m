q=0;
for i=1:size(F2,2)
    if sum(F2(:,i))==0
        q=q+1;
    end
end
F200=zeros(q,1);
c=1;
for i=1:size(F2,2)
    if sum(F2(:,i))==0
        F200(c)=i;
        c=c+1;
    end
end