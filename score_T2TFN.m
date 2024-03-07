function Score=score_T2TFN(M)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% Input: M is a column of Type-2 Triangular/Trapezoidal Fuzzy Number
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

n=size(M,2);

if(n==10) %Type-2 Trapezoidal Fuzzy Number
    Score_upper=(M(:,1)+(1+M(:,5)).*M(:,2)+(1+M(:,5)).*M(:,3)+M(:,4))./(4+2.*M(:,5));
    Score_lower=(M(:,6)+(1+M(:,10)).*M(:,7)+(1+M(:,10)).*M(:,8)+M(:,9))./(4+2.*M(:,10));
    Score=(Score_upper+Score_lower)/2;
elseif(n==8) %Type-2 Triangular Fuzzy Number
    Score_upper=(M(:,1)+(1+M(:,4)).*M(:,2)+M(:,3))./(3+M(:,4));
    Score_lower=(M(:,5)+(1+M(:,8)).*M(:,6)+M(:,7))./(3+M(:,7));
    Score=(Score_upper+Score_lower)/2;
else
    disp('error in the score function')
    return
end