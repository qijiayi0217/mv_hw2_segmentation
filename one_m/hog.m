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
r=im(:,:,1);
g=im(:,:,2);
b=im(:,:,3);
[Gmagr,Gdirr]=imgradient(r);
[Gmagg,Gdirg]=imgradient(g);
[Gmagb,Gdirb]=imgradient(b);
Gdirr=(Gdirr+180)/360*2*pi;
Gdirg=(Gdirg+180)/360*2*pi;
Gdirb=(Gdirb+180)/360*2*pi;
gaussian=fspecial('gaussian',16,6);
r_mag=Gmagr(y-7:y+8,x-7:x+8).*gaussian;
g_mag=Gmagg(y-7:y+8,x-7:x+8).*gaussian;
b_mag=Gmagb(y-7:y+8,x-7:x+8).*gaussian;
r_dir=Gdirr(y-7:y+8,x-7:x+8);
g_dir=Gdirg(y-7:y+8,x-7:x+8);
b_dir=Gdirb(y-7:y+8,x-7:x+8);
r_des=calhist(r_mag,r_dir);
g_des=calhist(g_mag,g_dir);
b_des=calhist(b_mag,b_dir);
v(1,:)=r_des(:)';
v(2,:)=g_des(:)';
v(3,:)=b_des(:)';
%%%%%%%%  fill in above

v = v(:);
return