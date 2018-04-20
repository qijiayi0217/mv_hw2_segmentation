function [X,S]=dog(im)

gaussian1=fspecial('gaussian',15,1.2);
gaussian2=fspecial('gaussian',15,1.2*1.6);
gaussian3=fspecial('gaussian',15,1.2*1.6*1.6);
gaussian4=fspecial('gaussian',15,1.2*1.6*1.6*1.6);
H1=gaussian1-gaussian2;
H2=gaussian2-gaussian3;
H3=gaussian3-gaussian4;
dog1=conv2(im,H1,'same');
dog2=conv2(im,H2,'same');
dog3=conv2(im,H3,'same');
tmp=zeros(size(dog2,1),size(dog2,2));
for i=2:size(dog2,1)-1
    for j=2:size(dog2,2)-1
        pos=1;
        neigh=zeros(1,26);
        for m=-1:1
            for n=-1:1
                neigh(pos)=dog1(i+m,j+n);
                pos=pos+1;
                neigh(pos)=dog3(i+m,j+n);
                pos=pos+1;
                if (m~=0)&&(n~=0)
                    neigh(pos)=dog2(i+m,j+n);
                    pos=pos+1;
                end
            end
        end
        if (dog2(i,j)<min(neigh))||(dog2(i,j)>max(neigh))
            tmp(i,j)=1;
        end
    end
end
l=sum(tmp(:));
X=zeros(2,l);
pos=1;
for i=1:size(tmp,1)
    for j=1:size(tmp,2)
        if tmp(i,j)==1
            X(2,pos)=i;
            X(1,pos)=j;
            pos=pos+1;
        end
    end
end
S=1;
return
        