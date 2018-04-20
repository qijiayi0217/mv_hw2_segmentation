function des=calhist(mag,dir)

%disp(size(dir));
des=zeros(4,4,8);
for row=0:3
    for col=0:3
        hist=[0,0,0,0,0,0,0,0];
        index=0;
        for i=1:4
            for j=1:4
                if fix(dir(row*4+i,col*4+j)/(pi/4))==8
                    index=8;
                else
                    index=fix(dir(row*4+i,col*4+j)/(pi/4))+1;
                end
                hist(index)=hist(index)+mag(row*4+i,col*4+j);
            end
        end
        max1=-1;
        highest=0;
        for s=1:8
            if hist(s)>max1
                max1=hist(s);
                highest=s;
                %disp('done');
            end
        end
        if highest==8
            off=hist(1)/(hist(1)+hist(7));
        elseif highest==1
            off=hist(2)/(hist(8)+hist(2));
        else
            off=hist(highest+1)/(hist(highest+1)+hist(highest-1));
        end
        angle=((highest-1)*(pi/4))+off*(pi/4);
        for m=1:4
            for n=1:4
                dir(row*4+m,col*4+n)=dir(row*4+m,col*4+n)-angle;
                if dir(row*4+m,col*4+n)<0
                    dir(row*4+m,col*4+n)=dir(row*4+m,col*4+n)+2*pi;
                end
            end
        end
        hist=[0,0,0,0,0,0,0,0];
        index=0;
        for i=1:4
            for j=1:4
                if isnan(dir(row*4+i,col*4+j))
                    nothing=0;
                else
                    if fix(dir(row*4+i,col*4+j)/(pi/4))==8
                        index=8;
                    else
                        index=fix(dir(row*4+i,col*4+j)/(pi/4))+1;
                    end
                    %disp(index);
                    hist(index)=hist(index)+mag(row*4+i,col*4+j);
                end
            end
        end
        des(row+1,col+1,:)=hist;
    end
end
return