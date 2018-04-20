function [l,Copt] = slic(image,k)

% function [S,Copt] = slic(image,numsegs)
%     EECS Foundation of Computer Vision;
%     Jason Corso
%
% Implementation of Achanta et al. "SLIC Superpixels Compared 
%  to State-of-the-art Superpixel Methods" PAMI 2011.
% Notation is directly from this paper when possible.
%
% k is the number of segments
% l is an index image with a unique id associated with each segments
% Copt is the structure array describing the segment information
%    it is an optional output


[r,c,b] = size(image);
N = r*c;
S = ceil(sqrt(N/k));

%fprintf('r=%d,c=%d,N=r*c=%d\n',r,c,N);
%fprintf('S=%d\n',S);

% convert the image to Lab space
I = RGB2Lab(image);
IL = I(:,:,1);
Ia = I(:,:,2);
Ib = I(:,:,3);
dy = conv2(IL,fspecial('sobel'),'same');
dx = conv2(IL,fspecial('sobel')','same');

% set up how we will store the cluster centers
C = struct( 'index',{}...         
           ,'l'    ,{}...
           ,'a'    ,{}...
           ,'b'    ,{}...
           ,'x'    ,{}...
           ,'y'    ,{}...
           ,'x_sub',{}... % subpixel x
           ,'y_sub',{}... % subpixel y
           ,'fv'   ,{}... % a feature vector that will get used later
          );
            
% initialize the seed points
i=1;
for y=S/2:S:r
    for x=S/2:S:c
        C(i).index = i;
        C(i).x = x;
        C(i).y = y;
        C(i).l = IL(y,x);
        C(i).a = Ia(y,x);
        C(i).b = Ib(y,x);
        i = i + 1;
    end
end
clear i x y;

% assert length(centers) = k
k = length(C);

% recenter seed points
M = dx.*dx+dy.*dy;
for i = 1:k
    minr = max(1,C(i).y-1);
    minc = max(1,C(i).x-1);
    maxr = min(r,C(i).y+1);
    maxc = min(c,C(i).x+1);
    g = M(minr:maxr,minc:maxc);
    
    [~,ix] = min(g(:));
    [y,x] = ind2sub([3 3],ix);
    y = C(i).y+y-2;
    x = C(i).x+x-2;
    C(i).x = x;
    C(i).y = y;
    C(i).l = IL(y,x);
    C(i).a = Ia(y,x);
    C(i).b = Ib(y,x);
end

% initialize other variables
% label l
l = ones(r,c)*-1;
% distance
d = inf(r,c);
% residual error
E = 1e20;
% m -- scalar weight on the distance function
m = 15;
m2overS2 = m*m/(S*S);   % m^2 / S^2

% main loop of algorithm
for iteration=1:12   % max 12 iterations
    
    %%%%%  fill in the main body of the SLIC algorithm here
    for i=1:k
        if C(i).y-S<=0
            lowy=1;
        else
            lowy=round(C(i).y-S);
        end
        if C(i).y+S>=r
            highy=r;
        else
            highy=round(C(i).y+S);
        end
        if C(i).x-S<=0
            lowx=1;
        else
            lowx=round(C(i).x-S);
        end
        if C(i).x+S>=c
            highx=c;
        else
            highx=round(C(i).x+S);
        end
        for y=lowy:highy
            for x=lowx:highx
                %disp(x);
                %disp(y);
                dc=sqrt((IL(y,x)-C(i).l)^2+(Ia(y,x)-C(i).a)^2+(Ib(y,x)-C(i).b)^2);
                ds=sqrt((y-C(i).y)^2+(x-C(i).x)^2);
                D=sqrt(dc^2+(ds/S)^2*m^2);
                if D<d(y,x)
                    d(y,x)=D;
                    l(y,x)=i;
                end
            end
        end
    end
    %compute new cluster centers
    sumx=zeros(1,k);
    sumy=zeros(1,k);
    suml=zeros(1,k);
    suma=zeros(1,k);
    sumb=zeros(1,k);
    count=zeros(1,k);
    for y=1:r
        for x=1:c
            sumx(l(y,x))=sumx(l(y,x))+x;
            sumy(l(y,x))=sumy(l(y,x))+y;
            suml(l(y,x))=suml(l(y,x))+IL(y,x);
            suma(l(y,x))=suma(l(y,x))+Ia(y,x);
            sumb(l(y,x))=sumb(l(y,x))+Ib(y,x);
            count(l(y,x))=count(l(y,x))+1;
        end
    end
    

    % at each iteration, compute the current residual error (sum of change in x,y for all segments)
    %  use a variable named err for that.
    err=0;
    for i=1:k
        L2=[C(i).x,C(i).y];
        C(i).x=sumx(i)/count(i);
        C(i).y=sumy(i)/count(i);
        C(i).l=suml(i)/count(i);
        C(i).a=suma(i)/count(i);
        C(i).b=sumb(i)/count(i);
        ds=sqrt((L2(2)-C(i).y)^2+(L2(1)-C(i).x)^2);
        err=err+ds;
    end

    %%%%% do not change below this line

    % check residual
    if (E-err) < 1
       break;
    else
        E = err;
    end
    
end


% finish
if nargout==2
    Copt = C;
end
