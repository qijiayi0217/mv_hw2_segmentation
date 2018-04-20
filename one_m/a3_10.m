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
r=im(:,:,1);
g=im(:,:,2);
b=im(:,:,3);
[Gmagr,Gdirr]=imgradient(r);
[Gmagg,Gdirg]=imgradient(g);
[Gmagb,Gdirb]=imgradient(b);
Gdirr=(Gdirr+180)/360*2*pi;
Gdirg=(Gdirg+180)/360*2*pi;
Gdirb=(Gdirb+180)/360*2*pi;
gradient=[1,0,-1];
gradrx=conv2(r,gradient,'same');
gradgx=conv2(g,gradient,'same');
gradbx=conv2(b,gradient,'same');
gradry=conv2(r,gradient','same');
gradgy=conv2(g,gradient','same');
gradby=conv2(b,gradient','same');
%compute gradx and y for r
r_gradx=gradrx(x-7:x+8,y-7:y+8);
r_grady=gradry(x-7:x+8,y-7:y+8);
%compute gradx and y for g
g_gradx=gradgx(x-7:x+8,y-7:y+8);
g_grady=gradgy(x-7:x+8,y-7:y+8);
%compute gradx and y for b
b_gradx=gradbx(x-7:x+8,y-7:y+8);
b_grady=gradby(x-7:x+8,y-7:y+8);
gaussian=fspecial('gaussian',16,6);
%compute magnitude and orientation of r
r_mag=zeros(16,16);
r_ori=zeros(16,16);
for i=1:16
    for j=1:16
        r_mag(i,j)=sqrt(r_gradx(i,j)^2+r_grady(i,j)^2);
        if ((r_gradx(i,j)>0)&&(r_grady(i,j)>0))||((r_gradx(i,j)>0)&&(r_grady(i,j)<0))
            r_ori(i,j)=atan(r_gradx(i,j)/r_grady(i,j));
        elseif (r_gradx(i,j)<0)&&(r_grady(i,j)>0)
            r_ori(i,j)=atan(-r_gradx(i,j)/r_grady(i,j))+pi/2;
        elseif (r_gradx(i,j)<0)&&(r_grady(i,j)<0)
            r_ori(i,j)=atan(-r_gradx(i,j)/r_grady(i,j))-pi/2;
        elseif (r_gradx(i,j)==0)&&(r_grady(i,j)>0)
            r_ori(i,j)=pi/2;
        elseif (r_gradx(i,j)==0)&&(r_grady(i,j)<0)
            r_ori(i,j)=-pi/2;
        elseif (r_gradx(i,j)>0)&&(r_grady(i,j)==0)
            r_ori(i,j)=pi;
        elseif (r_gradx(i,j)<0)&&(r_grady(i,j)==0)
            r_ori(i,j)=-pi;
        else
            r_ori(i,j)=NaN;
        end
    end
end
r_ori=Gdirr(x-7:x+8,y-7:y+8);
r_mag=Gmagr(x-7:x+8,y-7:y+8);
%r_ori=r_ori+q;
if sum(r_mag(:))==0
    disp('rmag000000');
end
r_mag=r_mag.*gaussian;
%compute magnitude and orientation of g
g_mag=zeros(16,16);
g_ori=zeros(16,16);
for i=1:16
    for j=1:16
        g_mag(i,j)=sqrt(g_gradx(i,j)^2+g_grady(i,j)^2);
        %orig(i,j)=atan(gradx(i,j)/grady(i,j));
        if ((g_gradx(i,j)>0)&&(g_grady(i,j)>0))||((g_gradx(i,j)>0)&&(g_grady(i,j)<0))
            g_ori(i,j)=atan(g_gradx(i,j)/g_grady(i,j));
        elseif (g_gradx(i,j)<0)&&(g_grady(i,j)>0)
            g_ori(i,j)=atan(-g_gradx(i,j)/g_grady(i,j))+pi/2;
        elseif (g_gradx(i,j)<0)&&(g_grady(i,j)<0)
            g_ori(i,j)=atan(-g_gradx(i,j)/g_grady(i,j))-pi/2;
        elseif (g_gradx(i,j)==0)&&(g_grady(i,j)>0)
            g_ori(i,j)=pi/2;
        elseif (g_gradx(i,j)==0)&&(g_grady(i,j)<0)
            g_ori(i,j)=-pi/2;
        elseif (g_gradx(i,j)>0)&&(g_grady(i,j)==0)
            g_ori(i,j)=pi;
        elseif (g_gradx(i,j)<0)&&(g_grady(i,j)==0)
            g_ori(i,j)=-pi;
        else
            g_ori(i,j)=NaN;
        end
    end
end
g_ori=Gdirg(x-7:x+8,y-7:y+8);
g_mag=Gmagg(x-7:x+8,y-7:y+8);
%g_ori=g_ori+q;
g_mag=g_mag.*gaussian;
%compute magnitude and orientation of b
b_mag=zeros(16,16);
b_ori=zeros(16,16);
for i=1:16
    for j=1:16
        b_mag(i,j)=sqrt(b_gradx(i,j)^2+b_grady(i,j)^2);
        %orig(i,j)=atan(gradx(i,j)/grady(i,j));
        if ((b_gradx(i,j)>0)&&(b_grady(i,j)>0))||((b_gradx(i,j)>0)&&(b_grady(i,j)<0))
            b_ori(i,j)=atan(b_gradx(i,j)/b_grady(i,j));
        elseif (b_gradx(i,j)<0)&&(b_grady(i,j)>0)
            b_ori(i,j)=atan(-b_gradx(i,j)/b_grady(i,j))+pi/2;
        elseif (b_gradx(i,j)<0)&&(b_grady(i,j)<0)
            b_ori(i,j)=atan(-b_gradx(i,j)/b_grady(i,j))-pi/2;
        elseif (b_gradx(i,j)==0)&&(b_grady(i,j)>0)
            b_ori(i,j)=pi/2;
        elseif (b_gradx(i,j)==0)&&(b_grady(i,j)<0)
            b_ori(i,j)=-pi/2;
        elseif (b_gradx(i,j)>0)&&(b_grady(i,j)==0)
            b_ori(i,j)=pi;
        elseif (r_gradx(i,j)<0)&&(b_grady(i,j)==0)
            b_ori(i,j)=-pi;
        else
            b_ori(i,j)=NaN;
        end
    end
end
b_ori=Gdirb(x-7:x+8,y-7:y+8);
b_mag=Gmagb(x-7:x+8,y-7:y+8);
%b_ori=b_ori+q;
b_mag=b_mag.*gaussian;
%compute histogram r
r_des=zeros(4,4,8);
for row=0:3
    for col=0:3
        h=[0,0,0,0,0,0,0,0];
        for i=1:4
            for j=1:4
                if isnan(r_ori(row*4+i,col*4+j))
                    nothing=0;
                else
                    if fix(r_ori(row*4+i,col*4+j)/(pi/4))==8
                        index=8;
                    else
                        index=fix(r_ori(row*4+i,col*4+j)/(pi/4))+1;
                    end
                    h(index)=h(index)+r_mag(row*4+i,col*4+j);
                end
            end
        end
        max1=-1;
        in1=0;
        for i=1:8
            if max1<h(i)
                max1=h(i);
                in1=i;
            end
        end
        if in1==8
            off=h(1)/(h(7)+h(1));
        elseif in1==1
            off=h(2)/(h(8)+h(2));
        else
            off=h(in1+1)/(h(in1-1)+h(in1+1));
        end
        angle=(in1-1)*pi/4+(pi/4)*off;
        for i=1:4
            for j=1:4
                r_ori(row*4+i,col*4+j)=r_ori(row*4+i,col*4+j)-angle;
                if r_ori(row*4+i,col*4+j)<0
                    r_ori(row*4+i,col*4+j)=r_ori(row*4+i,col*4+j)+2*pi;
                end
            end
        end
        %compute histogram again after rotation
        h=[0,0,0,0,0,0,0,0];
        for i=1:4
            for j=1:4
                if isnan(r_ori(row*4+i,col*4+j))
                    nothing=0;
                else
                    if fix(r_ori(row*4+i,col*4+j)/(pi/4))==8
                        index=8;
                    else
                        index=fix(r_ori(row*4+i,col*4+j)/(pi/4))+1;
                    end
                    h(index)=h(index)+r_mag(row*4+i,col*4+j);
                end
            end
        end
        r_des(row+1,col+1,:)=h;
    end
end


%compute histogram g
g_des=zeros(4,4,8);
for row=0:3
    for col=0:3
        h=[0,0,0,0,0,0,0,0];
        for i=1:4
            for j=1:4
                if isnan(g_ori(row*4+i,col*4+j))
                    nothing=0;
                else
                    if fix(g_ori(row*4+i,col*4+j)/(pi/4))==8
                        index=8;
                    else
                        index=fix(g_ori(row*4+i,col*4+j)/(pi/4))+1;
                    end
                    h(index)=h(index)+g_mag(row*4+i,col*4+j);
                end
            end
        end
        max1=-1;
        in1=0;
        for i=1:8
            if max1<h(i)
                max1=h(i);
                in1=i;
            end
        end
        if in1==8
            off=h(1)/(h(7)+h(1));
        elseif in1==1
            off=h(2)/(h(8)+h(2));
        else
            off=h(in1+1)/(h(in1-1)+h(in1+1));
        end
        angle=(in1-1)*pi/4+(pi/4)*off;
        for i=1:4
            for j=1:4
                g_ori(row*4+i,col*4+j)=g_ori(row*4+i,col*4+j)-angle;
                if g_ori(row*4+i,col*4+j)<0
                    g_ori(row*4+i,col*4+j)=g_ori(row*4+i,col*4+j)+2*pi;
                end
            end
        end
        %compute histogram again after rotation
        h=[0,0,0,0,0,0,0,0];
        for i=1:4
            for j=1:4
                if isnan(g_ori(row*4+i,col*4+j))
                    nothing=0;
                else
                    if fix(g_ori(row*4+i,col*4+j)/(pi/4))==8
                        index=8;
                    else
                        index=fix(g_ori(row*4+i,col*4+j)/(pi/4))+1;
                    end
                    h(index)=h(index)+g_mag(row*4+i,col*4+j);
                end
            end
        end
        g_des(row+1,col+1,:)=h;
    end
end

%compute histogram b
b_des=zeros(4,4,8);
for row=0:3
    for col=0:3
        h=[0,0,0,0,0,0,0,0];
        for i=1:4
            for j=1:4
                if isnan(b_ori(row*4+i,col*4+j))
                    nothing=0;
                else
                    if fix(b_ori(row*4+i,col*4+j)/(pi/4))==8
                        index=8;
                    else
                        index=fix(b_ori(row*4+i,col*4+j)/(pi/4))+1;
                    end
                    %disp(index);
                    h(index)=h(index)+b_mag(row*4+i,col*4+j);
                end
            end
        end
        max1=-1;
        in1=0;
        for i=1:8
            if max1<h(i)
                max1=h(i);
                in1=i;
            end
        end
        if in1==8
            off=h(1)/(h(7)+h(1));
        elseif in1==1
            off=h(2)/(h(8)+h(2));
        else
            off=h(in1+1)/(h(in1-1)+h(in1+1));
        end
        angle=(in1-1)*pi/4+(pi/4)*off;
        for i=1:4
            for j=1:4
                b_ori(row*4+i,col*4+j)=b_ori(row*4+i,col*4+j)-angle;
                if b_ori(row*4+i,col*4+j)<0
                    b_ori(row*4+i,col*4+j)=b_ori(row*4+i,col*4+j)+2*pi;
                end
            end
        end
        %compute histogram again after rotation
        h=[0,0,0,0,0,0,0,0];
        for i=1:4
            for j=1:4
                if isnan(b_ori(row*4+i,col*4+j))
                    nothing=0;
                else
                    if fix(b_ori(row*4+i,col*4+j)/(pi/4))==8
                        index=8;
                    else
                        index=fix(b_ori(row*4+i,col*4+j)/(pi/4))+1;
                    end
                    h(index)=h(index)+b_mag(row*4+i,col*4+j);
                end
            end
        end
        b_des(row+1,col+1,:)=h;
    end
end
v(1,:)=r_des(:)';
v(2,:)=g_des(:)';
v(3,:)=b_des(:)';
%%%%%%%%  fill in above

v = v(:);
return