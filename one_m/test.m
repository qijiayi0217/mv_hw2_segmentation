function test(im1,im2,c)

%oneload;
X=onedetect(im1);
Y=onedetect(im2);
F1=onereduce(im1);
F2=onereduce(im2);
M=onematch(F1,F2,c);
oneshow(im1,X,im2,Y,M);
