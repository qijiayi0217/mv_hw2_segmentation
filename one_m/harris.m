function C = harris(dx,dy,Whalfsize)

% function C = harris(dx,dy,Whalfsize)
%
%     EECS Foundation of Computer Vision;
%     Jason Corso
%
%   dx is the horizontal gradient image
%   dy is the vertical gradient image
%   Whalfsize is the half size of the window.  Wsize = 2*Whalfsize+1
%
%  output
%   C is an image (same size as dx and dy) where every pixel contains the
%   corner strength.  



kappa = ones(2*Whalfsize+1);

%%%%%%%%% fill in below
xsize=size(dx);
x=dx.*dx;
y=dy.*dy;
a=dx.*dy;
g=fspecial('gaussian',2*Whalfsize+1,1);
x1=conv2(x,g,'same');
y1=conv2(y,g,'same');
a1=conv2(a,g,'same');
C=dx;
for i=1:xsize(1)
    for j=1:xsize(2)
        M=[x1(i,j),a1(i,j);a1(i,j),y1(i,j)];
        eigv=eig(M);
        %C(i,j)=eigv(1)*eigv(2)-0.1*(eigv(1)+eigv(2))^2; %harris
        C(i,j)=min(eigv(1),eigv(2)); %Shi-Tomasi
    end
end
C=C+0.8;
return
%M=[sum(x(:)),sum(a(:));sum(a(:)),sum(y(:))]; %secomd moment matrix
%eigv=eig(M);0.96 0.95 -- off,  0.96
%R=eigv(1)*eigv(2)-0.1*(eigv(1)+eigv(2))^2;



%%%%%%%% done
