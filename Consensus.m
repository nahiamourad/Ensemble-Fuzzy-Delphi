function [sigma,consensus]=Consensus(R,R_star)
[K,M]=size(R);
if(size(R_star,1)~=K)
    disp('error in the consensus Function the sizes of the ranks are not compatible')
end

diff=zeros(M,1);
for m=1:M
   diff(m)=norm(R_star-R(:,m))^2;
end
sigma=sqrt(mean(diff)/2);

q=zeros(K,M);
for m=1:M
    q(:,m)=normpdf(R_star-R(:,m),0,sigma);
    q(:,m)=q(:,m)/normpdf(0,0,sigma);
end

consensus=sum(sum(q))/(K*M);
end