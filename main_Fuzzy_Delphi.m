%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%Basic Parameters
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%clc;
%clear;
filename=char('Fuzzy Delphi data last update.xlsx');
sheet_criteria=char('Criteria');
sheet_score=char('Scores');
n=61;%number of  criteria
s=14;%number of Experts
letter=char(('A':'Z').').';

ns=5;%Likert scale to be used
%Scenarios=9;% #Scenarios for Sensitivity Analysis
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%Fuzzy Numbers
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%Generalized Triangular Fuzzy Numbers
GTrFN{5}=[0.6	0.8	1,1];
GTrFN{4}=[0.4	0.6	0.8,1];
GTrFN{3}=[0.2	0.4	0.6,1];
GTrFN{2}=[0	0.2	0.4,1];
GTrFN{1}=[0	0	0.2,1];

%%Generalized Trapezoidal Fuzzy Numbers
GTzFN{5}=[0.6	0.8	0.9	1,1];
GTzFN{4}=[0.4	0.6	0.7	0.8,1];
GTzFN{3}=[0.2	0.4	0.5	0.6,1];
GTzFN{2}=[0	0.2	0.3	0.4,1];
GTzFN{1}=[0	0	0.1	0.2,1];

%%Interval Type-2 Trapezoidal Fuzzy Numbers
T2TzFN{5}=[0.9, 1, 1,1, 1,0.95, 1, 1,1, 0.9];
T2TzFN{4}=[0.7, 0.9, 0.9,1, 1,0.8, 0.9, 0.9, 0.95,0.9];
T2TzFN{3}=[0.3, 0.5, 0.5, 0.7, 1,0.4, 0.5, 0.5, 0.6, 0.9];
T2TzFN{2}=[0,0.1,0.1,0.3,1,0.05, 0.1, 0.1, 0.2, 0.9];
T2TzFN{1}=[0,0,0,0.1,1,0,0,0,0.5,0.9];

%%Interval Type-2 Triangular Fuzzy Numbers
T2TrFN{5}=[0.9, 1.0, 1.0, 1, 0.95, 1.0, 1.00, 0.9];
T2TrFN{4}=[0.7, 0.9, 1.0, 1, 0.80, 0.9, 0.95, 0.9];
T2TrFN{3}=[0.3, 0.5, 0.7, 1, 0.40, 0.5, 0.60, 0.9];
T2TrFN{2}=[0.0, 0.1, 0.3, 1, 0.05, 0.1, 0.20, 0.9];
T2TrFN{1}=[0.0, 0.0, 0.1, 1, 0.00, 0.0, 0.50, 0.9];

min_score=0; %%Lower bound of the score function

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%Expert's Decision Matrix
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if(n<=26)
    position=char([letter(2),'2:',letter(n+1),num2str(s+1)]);
else
    position=char([letter(2),'2:',letter(floor(n/26)),letter(mod(n,26)+1),num2str(s+1)]);
end
EDM=readmatrix(filename,'Sheet',sheet_criteria,'Range',position);

%%%Fuzzy Delphi Method (FDM)
[Scores_GTrFN,EDM_GTrF,EDM_GTrFN_agg]=FDM(EDM,GTrFN,'agg_GTFN','score_centroid',min_score);
[Scores_GTzFN,EDM_GTzF,EDM_GTzFN_agg]=FDM(EDM,GTzFN,'agg_GTFN','score_centroid',min_score);
[Scores_T2TrFN,EDM_T2TrF,EDM_T2TrFN_agg]=FDM(EDM,T2TrFN,'agg_T2TFN','score_T2TFN',min_score);
[Scores_T2TzFN,EDM_T2TzF,EDM_T2TzFN_agg]=FDM(EDM,T2TzFN,'agg_T2TFN','score_T2TFN',min_score);

writematrix(cell2mat([EDM_GTrF;EDM_GTrFN_agg]),filename,'Sheet',sheet_criteria,'Range',char([letter(2),num2str(s+6)]));
writematrix(cell2mat([EDM_GTzF;EDM_GTzFN_agg]),filename,'Sheet',sheet_criteria,'Range',char([letter(2),num2str(2*s+10)]));
writematrix(cell2mat([EDM_T2TrF;EDM_T2TrFN_agg]),filename,'Sheet',sheet_criteria,'Range',char([letter(2),num2str(3*s+14)]));
writematrix(cell2mat([EDM_T2TzF;EDM_T2TzFN_agg]),filename,'Sheet',sheet_criteria,'Range',char([letter(2),num2str(4*s+18)]));

Scores=[Scores_GTrFN',Scores_GTzFN',Scores_T2TrFN',Scores_T2TzFN'];
Scores(:,5)=mean(Scores,2);     %Ensemble by statistical mean
rank=zeros(n,5);
result=zeros(n,10);
for i=1:5
    rank(:,i)=rankWithDuplicates(Scores(:,i));
    result(:,2*(i-1)+1:2*(i-1)+2)=[Scores(:,i),rank(:,i)];
end
writematrix(result,filename,'Sheet',sheet_score,'Range',char([letter(2),'2']));
Index=find(Scores(:,5)>=0.7);
Decision=cell(n,1);
for i=1:size(Index)
    Decision{Index(i)}='accepted';
end
writecell(Decision,filename,'Sheet',sheet_score,'Range',char([letter(12),'2']));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%Consensus Calculations
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%Consensus by decision between each Fuzzy enviroment and the ensemble
A=Scores;
A(A>=0.7)=1;
A(A<0.7)=0;

[sigma,consensus]=Consensus(A(:,1:4),A(:,5));
writematrix([sigma,consensus],filename,'Sheet',sheet_score,'Range',char([letter(15),'2']));
[sigma,consensus]=Consensus(rank(:,1:4),rank(:,5));
writematrix([sigma,consensus],filename,'Sheet',sheet_score,'Range',char([letter(15),'3']));
[sigma,consensus]=Consensus(Scores(:,1:4),Scores(:,5));
writematrix([sigma,consensus],filename,'Sheet',sheet_score,'Range',char([letter(15),'4']));

%%Consensus by scores between each expert's opinion and the score within
%%each Fuzzy enviroment
EDM_score=zeros(s,n,4);
for j=1:n
    EDM_score(:,j,1)=score_centroid(cell2mat(EDM_GTrF(:,j)));
    EDM_score_agg(:,1)=score_centroid(cell2mat(EDM_GTrFN_agg'));
    EDM_score(:,j,2)=score_centroid(cell2mat(EDM_GTzF(:,j)));
    EDM_score_agg(:,2)=score_centroid(cell2mat(EDM_GTzFN_agg'));
    EDM_score(:,j,3)=score_T2TFN(cell2mat(EDM_T2TrF(:,j)));
    EDM_score_agg(:,3)=score_T2TFN(cell2mat(EDM_T2TrFN_agg'));
    EDM_score(:,j,4)=score_T2TFN(cell2mat(EDM_T2TzF(:,j)));
    EDM_score_agg(:,4)=score_T2TFN(cell2mat(EDM_T2TzFN_agg'));
end
[expert_sigma,expert_consensus,expert_sigma_2,expert_consensus_2]=deal(zeros(4,1));
for k=1:4
    [expert_sigma(k),expert_consensus(k)]=Consensus(EDM_score(:,:,k)',EDM_score_agg(:,k));
    [expert_sigma_2(k),expert_consensus_2(k)]=Consensus(EDM',5*Scores(:,k));
end
writematrix([expert_sigma,expert_consensus],filename,'Sheet',sheet_score,'Range',char([letter(15),'15']));
writematrix([expert_sigma_2,expert_consensus_2],filename,'Sheet',sheet_score,'Range',char([letter(17),'15']));