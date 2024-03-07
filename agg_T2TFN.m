function agg_T2TFN=agg_T2TFN(T2TFNs,w)
%%% GTFNs is a column array of cells containing the GTzFNs or GTrFNs to be aggregated
%%% GTzFNs (rep. GTrFNs) are generalized Trapezoidal (Traingular) FNs
%%% w is the weight of aggregation

if(size(T2TFNs)~=size(w))
    if(isrow(w))
        w=w';
    end
    if(isrow(T2TFNs))
        T2TFNs=T2TFNs';
    end
else
    disp('Incorrect Aggregartion. Check aggregation function');
    return
end


M=cell2mat(T2TFNs);
n=size(M,2)/2;                                    %size of each
w=repmat(w,1,n-1);
agg_T2TFN_upper=sum(M(:,1:n-1).*w);              %Aggregate all upper values except the height
agg_T2TFN_upper=[agg_T2TFN_upper,min(M(:,n))];  %Choose the minimum height
agg_T2TFN_lower=sum(M(:,n+1:end-1).*w);          %Aggregate all lower values except the height
agg_T2TFN_lower=[agg_T2TFN_lower,min(M(:,end))];%Choose the minimum height
agg_T2TFN=[agg_T2TFN_upper,agg_T2TFN_lower];
end
