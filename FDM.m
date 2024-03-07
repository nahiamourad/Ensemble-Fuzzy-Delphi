function[Scores,EDM_fuzzy,EDM_agg]=FDM(EDM,FNs,agg_function,score_function,min_score)
%%%Input: EDM: Expert Decision Matrix.
%%%       FNs: Array of cells containing fuzzy numbers in order.
%%%       agg_function: Name of the aggregation function to be used
%%%       score_function: Name of the score function to be used
%%%       min_score: Is the lower bound of the score function
%%%Output: Scores based on aggregation and defuzification
[s,n]=size(EDM);
EDM_fuzzy=Fuzzification(EDM,FNs);

EDM_agg=cell(1,n);
Scores=zeros(1,n);
agg_fun=str2func(agg_function);
score_fun=str2func(score_function);
for j=1:n
    EDM_agg{j}=agg_fun(EDM_fuzzy(:,j),ones(1,s)/s);
    Scores(j)=score_fun(EDM_agg{j});
end

Scores=(Scores-min_score);
Scores=Scores/max(Scores);

end