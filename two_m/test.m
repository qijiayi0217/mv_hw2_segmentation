function test(a,key,tau)

[S,C] = twosegment(a);
C = tworeduce(a,C,S);
B = twocut(S,C,key,tau);
twoshow(a,C,S,B);
