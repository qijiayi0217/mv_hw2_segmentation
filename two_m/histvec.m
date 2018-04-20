function v = histvec(image,mask,b)

% function v = histvec(image,mask,b)
%
%     EECS Foundation of Computer Vision;
%     Jason Corso
%
%  For each channel in the image, compute a b-bin histogram (uniformly space
%  bins in the range 0:1) of the pixels in image where the mask is true. 
%  Then, concatenate the vectors together into one column vector (first
%  channel at top).
%
%  mask is a matrix of booleans the same size as image.
% 
%  normalize the histogram of each channel so that it sums to 1.
%
%  You CAN use the hist function.  (since you have already worked on 
%    implementing hist from assignment 1)

chan = size(image,3);

c = 1/b;      % bin offset
x = c/2:c:1;  % bin centers


%%%%% implement below this line into a 3*b by 1 vector  v
%%  3*b because we have a color image and you have a separate 
%%  histogram per color channel
[r,c,l]=size(image);
red=image(:,:,1);
green=image(:,:,2);
blue=image(:,:,3);
tmp1=[];
tmp2=[];
tmp3=[];
pos=1;
for i=1:r
    for j=1:c
        if mask(i,j)==1
            tmp1(pos)=red(i,j);
            tmp2(pos)=green(i,j);
            tmp3(pos)=blue(i,j);
            pos=pos+1;
        end
    end
end
hr=hist(tmp1,x);
hr=hr/sum(hr);
hg=hist(tmp2,x);
hg=hg/sum(hg);
hb=hist(tmp3,x);
hb=hb/sum(hb);
result=[hr,hg,hb];
v=result';
return

