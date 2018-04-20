function v = hog(im,x,y,Wfull)

% function v = hog(im,x,y,Wfull)
%
%     EECS Foundation of Computer Vision;
%     Jason Corso
%
%  Compute the histogram of oriented gradidents on gray image (im) 
%   for a given location (x,y) and scale (Wfull)
%
%  v is the output column vector of the hog.  
%
%  Use Lowe IJCV 2004 Sections 5 and 6 to (1) adapt to local rotation
%    and (2) compute the histogram.  Use the parameters in the paper
%    Within the window a 4 by 4 array of histograms of oriented gradients 
%    with 8 discretized orientations per bin.  Do it separately per color channel
%    and then concatenate the resulting vectors.
%    Each v should be 3*128 dimensions = 3*4*4*8.
%

v = zeros(3,128); 

%%%%%%%%  fill in below
q=ones(16,16);
q=q*pi;
%gradient=[-1,0,1];
r=im(:,:,1);
g=im(:,:,2);
b=im(:,:,3);
%compute r channel magnitude and orientation
%tmp1=r(x-7:x+8,y-8:y+9);
tmp1=conv2(r,gradient,'same');
gradx=tmp1(x-7:x+8,x-7:x+8);
%tmp2=r(x-8:x+9,y-7:y+8);
tmp2=conv2(r,gradient','same');
grady=tmp2(x-7:x+8,x-7:x+8);
magr=zeros(16,16);
orir=zeros(16,16);
for i=1:16
    for j=1:16
        magr(i,j)=sqrt(gradx(i,j)^2+grady(i,j)^2);
        %orir(i,j)=atan(gradx(i,j)/grady(i,j));
        if ((gradx(i,j)>0)&&(grady(i,j)>0))||((gradx(i,j)>0)&&(grady(i,j)<0))
            orir(i,j)=atan(gradx(i,j)/grady(i,j));
        elseif (gradx(i,j)<0)&&(grady(i,j)>0)
            orir(i,j)=atan(-gradx(i,j)/grady(i,j))+pi/2;
        elseif (gradx(i,j)<0)&&(grady(i,j)<0)
            orir(i,j)=atan(-gradx(i,j)/grady(i,j))-pi/2;
        end
    end
end
orir=orir+q;
%compute g channel magnitude and orientation
%tmp1=g(x-7:x+8,y-8:y+9);
tmp1=conv2(g,gradient,'same');
gradx=tmp1(x-7:x+8,x-7:x+8);
%tmp2=g(x-8:x+9,y-7:y+8);
tmp2=conv2(g,gradient','same');
grady=tmp2(x-7:x+8,x-7:x+8);
magg=zeros(16,16);
orig=zeros(16,16);
for i=1:16
    for j=1:16
        magg(i,j)=sqrt(gradx(i,j)^2+grady(i,j)^2);
        %orig(i,j)=atan(gradx(i,j)/grady(i,j));
        if ((gradx(i,j)>0)&&(grady(i,j)>0))||((gradx(i,j)>0)&&(grady(i,j)<0))
            orig(i,j)=atan(gradx(i,j)/grady(i,j));
        elseif (gradx(i,j)<0)&&(grady(i,j)>0)
            orig(i,j)=atan(-gradx(i,j)/grady(i,j))+pi/2;
        elseif (gradx(i,j)<0)&&(grady(i,j)<0)
            orig(i,j)=atan(-gradx(i,j)/grady(i,j))-pi/2;
        end
    end
end
orig=orig+q;
%disp(orig);
%compute b channel magnitude and orientation
%tmp1=b(x-7:x+8,y-8:y+9);
tmp1=conv2(b,gradient,'same');
gradx=tmp1(x-7:x+8,x-7:x+8);
%tmp2=b(x-8:x+9,y-7:y+8);
tmp2=conv2(b,gradient','same');
grady=tmp2(x-7:x+8,x-7:x+8);
magb=zeros(16,16);
orib=zeros(16,16);
for i=1:16
    for j=1:16
        magb(i,j)=sqrt(gradx(i,j)^2+grady(i,j)^2);
        %orib(i,j)=atan(gradx(i,j)/grady(i,j));
        if ((gradx(i,j)>0)&&(grady(i,j)>0))||((gradx(i,j)>0)&&(grady(i,j)<0))
            orib(i,j)=atan(gradx(i,j)/grady(i,j));
        elseif (gradx(i,j)<0)&&(grady(i,j)>0)
            orib(i,j)=atan(-gradx(i,j)/grady(i,j))+pi/2;
        elseif (gradx(i,j)<0)&&(grady(i,j)<0)
            orib(i,j)=atan(-gradx(i,j)/grady(i,j))-pi/2;
        end
    end
end
orib=orib+q;
%weighting
gaussian=fspecial('gaussian',16,6);
magr=magr.*gaussian;
magg=magg.*gaussian;
magb=magb.*gaussian;
%disp(magr);
magr=magr*10000;
magg=magg*10000;
magb=magb*10000;
%disp(magb);
%compute r channel histogram
r_des=zeros(4,4,8);
for row=0:3
    for col=0:3
        hist=[0,0,0,0,0,0,0,0];
        for i=1:4
            for j=1:4
                if (orir(row*4+i,col*4+j)>=0)&&(orir(row*4+i,col*4+j)<=2*pi/8)
                    hist(1)=hist(1)+magr(row*4+i,col*4+j);
                elseif (orir(row*4+i,col*4+j)>2*pi/8)&&(orir(row*4+i,col*4+j)<=2*pi/8*2)
                    hist(2)=hist(2)+magr(row*4+i,col*4+j);
                elseif (orir(row*4+i,col*4+j)>2*pi/8*2)&&(orir(row*4+i,col*4+j)<=2*pi/8*3)
                    hist(3)=hist(3)+magr(row*4+i,col*4+j);
                elseif (orir(row*4+i,col*4+j)>2*pi/8*3)&&(orir(row*4+i,col*4+j)<=2*pi/8*4)
                    hist(4)=hist(4)+magr(row*4+i,col*4+j);
                elseif (orir(row*4+i,col*4+j)>2*pi/8*4)&&(orir(row*4+i,col*4+j)<=2*pi/8*5)
                    hist(5)=hist(5)+magr(row*4+i,col*4+j);
                elseif (orir(row*4+i,col*4+j)>2*pi/8*5)&&(orir(row*4+i,col*4+j)<=2*pi/8*6)
                    hist(6)=hist(6)+magr(row*4+i,col*4+j);
                elseif (orir(row*4+i,col*4+j)>2*pi/8*6)&&(orir(row*4+i,col*4+j)<=2*pi/8*7)
                    hist(7)=hist(7)+magr(row*4+i,col*4+j);
                elseif (orir(row*4+i,col*4+j)>2*pi/8*7)&&(orir(row*4+i,col*4+j)<=2*pi/8*8)
                    hist(8)=hist(8)+magr(row*4+i,col*4+j);
                end
            end
        end
        %disp(hist);
        max=-1;
        index=0;
        for n=1:8
            if hist(n)>max
                max=hist(n);
                index=n;
            end
        end
        angle=(index-1)*pi/4+pi/8;
        orir(row*4+1:row*4+4,col*4+1:col*4+4)=orir(row*4+1:row*4+4,col*4+1:col*4+4)-angle;
        hist=[0,0,0,0,0,0,0,0];
        for i=1:4
            for j=1:4
                if (orir(row*4+i,col*4+j)>=0)&&(orir(row*4+i,col*4+j)<=2*pi/8)
                    hist(1)=hist(1)+magr(row*4+i,col*4+j);
                elseif (orir(row*4+i,col*4+j)>2*pi/8)&&(orir(row*4+i,col*4+j)<=2*pi/8*2)
                    hist(2)=hist(2)+magr(row*4+i,col*4+j);
                elseif (orir(row*4+i,col*4+j)>2*pi/8*2)&&(orir(row*4+i,col*4+j)<=2*pi/8*3)
                    hist(3)=hist(3)+magr(row*4+i,col*4+j);
                elseif (orir(row*4+i,col*4+j)>2*pi/8*3)&&(orir(row*4+i,col*4+j)<=2*pi/8*4)
                    hist(4)=hist(4)+magr(row*4+i,col*4+j);
                elseif (orir(row*4+i,col*4+j)>2*pi/8*4)&&(orir(row*4+i,col*4+j)<=2*pi/8*5)
                    hist(5)=hist(5)+magr(row*4+i,col*4+j);
                elseif (orir(row*4+i,col*4+j)>2*pi/8*5)&&(orir(row*4+i,col*4+j)<=2*pi/8*6)
                    hist(6)=hist(6)+magr(row*4+i,col*4+j);
                elseif (orir(row*4+i,col*4+j)>2*pi/8*6)&&(orir(row*4+i,col*4+j)<=2*pi/8*7)
                    hist(7)=hist(7)+magr(row*4+i,col*4+j);
                elseif (orir(row*4+i,col*4+j)>2*pi/8*7)&&(orir(row*4+i,col*4+j)<=2*pi/8*8)
                    hist(8)=hist(8)+magr(row*4+i,col*4+j);
                end
            end
        end
        r_des(row+1,col+1,:)=hist;
    end
end

%compute g channel histogram
g_des=zeros(4,4,8);
for row=0:3
    for col=0:3
        hist=[0,0,0,0,0,0,0,0];
        for i=1:4
            for j=1:4
                if (orig(row*4+i,col*4+j)>=0)&&(orig(row*4+i,col*4+j)<=2*pi/8)
                    hist(1)=hist(1)+magg(row*4+i,col*4+j);
                elseif (orig(row*4+i,col*4+j)>2*pi/8)&&(orig(row*4+i,col*4+j)<=2*pi/8*2)
                    hist(2)=hist(2)+magg(row*4+i,col*4+j);
                elseif (orig(row*4+i,col*4+j)>2*pi/8*2)&&(orig(row*4+i,col*4+j)<=2*pi/8*3)
                    hist(3)=hist(3)+magg(row*4+i,col*4+j);
                elseif (orig(row*4+i,col*4+j)>2*pi/8*3)&&(orig(row*4+i,col*4+j)<=2*pi/8*4)
                    hist(4)=hist(4)+magg(row*4+i,col*4+j);
                elseif (orig(row*4+i,col*4+j)>2*pi/8*4)&&(orig(row*4+i,col*4+j)<=2*pi/8*5)
                    hist(5)=hist(5)+magg(row*4+i,col*4+j);
                elseif (orig(row*4+i,col*4+j)>2*pi/8*5)&&(orig(row*4+i,col*4+j)<=2*pi/8*6)
                    hist(6)=hist(6)+magg(row*4+i,col*4+j);
                elseif (orig(row*4+i,col*4+j)>2*pi/8*6)&&(orig(row*4+i,col*4+j)<=2*pi/8*7)
                    hist(7)=hist(7)+magg(row*4+i,col*4+j);
                elseif (orig(row*4+i,col*4+j)>2*pi/8*7)&&(orig(row*4+i,col*4+j)<=2*pi/8*8)
                    hist(8)=hist(8)+magg(row*4+i,col*4+j);
                end
            end
        end
        max=-1;
        index=0;
        for n=1:8
            if hist(n)>max
                max=hist(n);
                index=n;
            end
        end
        angle=(index-1)*pi/4+pi/8;
        orig(row*4+1:row*4+4,col*4+1:col*4+4)=orig(row*4+1:row*4+4,col*4+1:col*4+4)-angle;
        hist=[0,0,0,0,0,0,0,0];
        for i=1:4
            for j=1:4
                if (orig(row*4+i,col*4+j)>=0)&&(orig(row*4+i,col*4+j)<=2*pi/8)
                    hist(1)=hist(1)+magg(row*4+i,col*4+j);
                elseif (orig(row*4+i,col*4+j)>2*pi/8)&&(orig(row*4+i,col*4+j)<=2*pi/8*2)
                    hist(2)=hist(2)+magg(row*4+i,col*4+j);
                elseif (orig(row*4+i,col*4+j)>2*pi/8*2)&&(orig(row*4+i,col*4+j)<=2*pi/8*3)
                    hist(3)=hist(3)+magg(row*4+i,col*4+j);
                elseif (orig(row*4+i,col*4+j)>2*pi/8*3)&&(orig(row*4+i,col*4+j)<=2*pi/8*4)
                    hist(4)=hist(4)+magg(row*4+i,col*4+j);
                elseif (orig(row*4+i,col*4+j)>2*pi/8*4)&&(orig(row*4+i,col*4+j)<=2*pi/8*5)
                    hist(5)=hist(5)+magg(row*4+i,col*4+j);
                elseif (orig(row*4+i,col*4+j)>2*pi/8*5)&&(orig(row*4+i,col*4+j)<=2*pi/8*6)
                    hist(6)=hist(6)+magg(row*4+i,col*4+j);
                elseif (orig(row*4+i,col*4+j)>2*pi/8*6)&&(orig(row*4+i,col*4+j)<=2*pi/8*7)
                    hist(7)=hist(7)+magg(row*4+i,col*4+j);
                elseif (orig(row*4+i,col*4+j)>2*pi/8*7)&&(orig(row*4+i,col*4+j)<=2*pi/8*8)
                    hist(8)=hist(8)+magg(row*4+i,col*4+j);
                end
            end
        end
        g_des(row+1,col+1,:)=hist;
    end
end

%compute b channel histogram
b_des=zeros(4,4,8);
for row=0:3
    for col=0:3
        hist=[0,0,0,0,0,0,0,0];
        for i=1:4
            for j=1:4
                if (orib(row*4+i,col*4+j)>=0)&&(orib(row*4+i,col*4+j)<=2*pi/8)
                    hist(1)=hist(1)+magb(row*4+i,col*4+j);
                elseif (orib(row*4+i,col*4+j)>2*pi/8)&&(orib(row*4+i,col*4+j)<=2*pi/8*2)
                    hist(2)=hist(2)+magb(row*4+i,col*4+j);
                elseif (orib(row*4+i,col*4+j)>2*pi/8*2)&&(orib(row*4+i,col*4+j)<=2*pi/8*3)
                    hist(3)=hist(3)+magb(row*4+i,col*4+j);
                elseif (orib(row*4+i,col*4+j)>2*pi/8*3)&&(orib(row*4+i,col*4+j)<=2*pi/8*4)
                    hist(4)=hist(4)+magb(row*4+i,col*4+j);
                elseif (orib(row*4+i,col*4+j)>2*pi/8*4)&&(orib(row*4+i,col*4+j)<=2*pi/8*5)
                    hist(5)=hist(5)+magb(row*4+i,col*4+j);
                elseif (orib(row*4+i,col*4+j)>2*pi/8*5)&&(orib(row*4+i,col*4+j)<=2*pi/8*6)
                    hist(6)=hist(6)+magb(row*4+i,col*4+j);
                elseif (orib(row*4+i,col*4+j)>2*pi/8*6)&&(orib(row*4+i,col*4+j)<=2*pi/8*7)
                    hist(7)=hist(7)+magb(row*4+i,col*4+j);
                elseif (orib(row*4+i,col*4+j)>2*pi/8*7)&&(orib(row*4+i,col*4+j)<=2*pi/8*8)
                    hist(8)=hist(8)+magb(row*4+i,col*4+j);
                end
            end
        end
        max=-1;
        index=0;
        for n=1:8
            if hist(n)>max
                max=hist(n);
                index=n;
            end
        end
        angle=(index-1)*pi/4+pi/8;
        orib(row*4+1:row*4+4,col*4+1:col*4+4)=orib(row*4+1:row*4+4,col*4+1:col*4+4)-angle;
        hist=[0,0,0,0,0,0,0,0];
        for i=1:4
            for j=1:4
                if (orib(row*4+i,col*4+j)>=0)&&(orib(row*4+i,col*4+j)<=2*pi/8)
                    hist(1)=hist(1)+magb(row*4+i,col*4+j);
                elseif (orib(row*4+i,col*4+j)>2*pi/8)&&(orib(row*4+i,col*4+j)<=2*pi/8*2)
                    hist(2)=hist(2)+magb(row*4+i,col*4+j);
                elseif (orib(row*4+i,col*4+j)>2*pi/8*2)&&(orib(row*4+i,col*4+j)<=2*pi/8*3)
                    hist(3)=hist(3)+magb(row*4+i,col*4+j);
                elseif (orib(row*4+i,col*4+j)>2*pi/8*3)&&(orib(row*4+i,col*4+j)<=2*pi/8*4)
                    hist(4)=hist(4)+magb(row*4+i,col*4+j);
                elseif (orib(row*4+i,col*4+j)>2*pi/8*4)&&(orib(row*4+i,col*4+j)<=2*pi/8*5)
                    hist(5)=hist(5)+magb(row*4+i,col*4+j);
                elseif (orib(row*4+i,col*4+j)>2*pi/8*5)&&(orib(row*4+i,col*4+j)<=2*pi/8*6)
                    hist(6)=hist(6)+magb(row*4+i,col*4+j);
                elseif (orib(row*4+i,col*4+j)>2*pi/8*6)&&(orib(row*4+i,col*4+j)<=2*pi/8*7)
                    hist(7)=hist(7)+magb(row*4+i,col*4+j);
                elseif (orib(row*4+i,col*4+j)>2*pi/8*7)&&(orib(row*4+i,col*4+j)<=2*pi/8*8)
                    hist(8)=hist(8)+magb(row*4+i,col*4+j);
                end
            end
        end
        b_des(row+1,col+1,:)=hist;
    end
end
v(1,:)=r_des(:)';
v(2,:)=g_des(:)';
v(3,:)=b_des(:)';

%%%%%%%%  fill in above

v = v(:);
return