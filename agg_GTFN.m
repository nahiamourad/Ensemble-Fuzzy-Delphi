function agg_GTFN=agg_GTFN(GTFNs,w)
%%% GTrFNs is a column array of cells containing the GTrFNs to be aggregated
%%% w is the weight of aggregation

if(size(GTFNs)~=size(w))
    if(isrow(w))
        w=w';
    end
    if(isrow(GTFNs))
        GTFNs=GTFNs';
    end
else
    disp('Incorrect Aggregartion. Check aggregation function');
    return
end


M=cell2mat(GTFNs);
n=size(M,2)-1;     %Exclude the height
w=repmat(w,1,n);
agg_GTFN=sum(M(:,1:end-1).*w); %Aggregate all except the height
agg_GTFN=[agg_GTFN,min(M(:,end))];  %Choose the minimum height
end
