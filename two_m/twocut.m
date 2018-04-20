function [B] = twocut(segmentimage,segments,keyindex,tau)

% function [B] = twocut(segmentimage,segments,keyindex
%
%     Jason Corso
%     Chenliang Xu
%
% Function to take a superpixel set and a keyindex and convert to a 
%  foreground/background segmentation.
%
% keyindex is the index to the superpixel we wish to use as foreground and
% find its relevant neighbors.
% 
% tau is a parameter (optional) that weights between unary and binary. 
% 

if nargin == 3
    tau = 0.5;
end

% compute basic adjacency information of superpixels
adjacency = segNeighbors(segmentimage);

k = length(segments);

capacity = zeros(k+2,k+2);
source = k+1;
sink = k+2;

% this is a single planar graph with an extra source and sink
%
% Capacity of a present edge in the graph is to be defined as the sum of
%  1:  the histogram similarity between the two color histogram feature vectors.
%      use the histintersect function below to compute this similarity 
%  2:  the spatial proximity between the two superpixels connected by the edge.
%      use exp(-D(a,b)) where D is the euclidean distance between superpixels a and b,
%
% source gets connected to every node except sink
%  capacity is with respect to the keyindex superpixel
% sink gets connected to every node except source; 
%  capacity is opposite that of the corresponding source-connection (from each superpixel)
%  in our case, the max capacity on an edge is 4; so, 4 minus corresponding capacity
% 
% superpixels get connected to each other.
%  capacity defined as above, but weighted by parameter tau. 

%%%%% Fill in the capacity here
for i=1:k+2
    for j=1:k+2
        if i<=k&&j<=k
            capacity(i,j)=tau*calcap(segments(i),segments(j))*adjacency(i,j);
        elseif i<=k&&j==sink
            capacity(i,j)=4-calcap(segments(i),segments(keyindex));
        elseif i==source&&j<=k
            capacity(i,j)=calcap(segments(j),segments(keyindex));
        else
            capacity(i,j)=0;
        end
    end
end
%disp(capacity);




%%%%% End of code block


% compute the cut
[s,t] = find(capacity);
weights = zeros(size(s));
for i = 1:length(s)
    weights(i) = capacity(s(i),t(i));
end
G = digraph(s,t,weights);
% plot(G,'EdgeLabel',G.Edges.Weight,'Layout','layered'); % visualize graph
[~,~,cs,ct] = maxflow(G,source,sink);

B = zeros(size(segmentimage));
for i = 1:length(cs)
    B(segmentimage==cs(i)) = 1;
end

%cap=capacity;
end




function c = histintersect(a,b)
    c = sum(min(a,b));
end
