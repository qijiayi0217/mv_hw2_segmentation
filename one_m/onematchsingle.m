function [m,d] = onematchsingle(f,F)

% function [m,d] = onematchsingle(f,F)
%
%     EECS Foundation of Computer Vision;
%     Jason Corso
%
% Wrapper for function to matching an feature vector to a feature matrix
%
%  f is the vector 
%  F is the matrix
%
% m is the matched index
% d is the distance for the match


%%%%%%%%%%% add your code below
%disp('Loop');
%disp(size1);
q1=zeros(size(F,2),1);
q2=zeros(size(F,2),1);
for j=1:size(F,2)
   dif=f-F(:,j);
   qqq=dif.*dif;
   he=sum(qqq(:));
   sq=sqrt(he);
   if sum(F(:,j))==0
       sq=99999;
   end
   q1(j)=j;
   q2(j)=sq;
end
minv=min(q2(:));
index=0;
%disp(minv);
for s=1:size(F,2)
    if q2(s)==minv
        index=s;
    end
end
if sum(f(:))==0
    minv=99999;
end
m=index;
d=minv;
%disp('m:');
%disp(m);

%disp('d:');
%disp(d);
%disp(m);
%disp('End');
return

%%%%%%%%%% add your code above
