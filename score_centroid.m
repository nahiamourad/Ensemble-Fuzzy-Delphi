function [Score,x,y]=score_centroid(GTFN)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% Input: DTFN is a column of Generalized Triangular or Trapezoidal FNs
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if(size(GTFN,2)~=5 && size(GTFN,2)~=4)
    disp('error in the score function')
    return
end
n=size(GTFN,2);
M=GTFN(:,n-1); %Exclude the height
x=sum(M,2)/(n-1);
y=GTFN(:,end)/2;
Score=x;
end