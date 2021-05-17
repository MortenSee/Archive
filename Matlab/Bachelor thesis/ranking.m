%Ranking based on jaccard metric.

%% load data
load('database_with_scaling_final.mat');
% Jaccard distances are the last(106) row.
scores=cell2mat(data(106,2:10));
%% Determine best score
[~,ranks]=sort(scores,'descend');


%% translate ranking into window/hopsize and preprocessing

windowing={'8px--8px','8px--4px','8px--2px','8px--1px','16px--16px','16px--8px','16px--4px','16px--2px','16px--1px'};
preprocess={'Scaled-Both','Original','Scaled-Original','LessContrast','Scaled-LessContrast','MoreContrast','Scaled-MoreContrast','Both'};

preID=rem(ranks,8);
winID=fix((ranks-1)./8);
word_ranks=cell(1,72);
for k=1:72
    word_ranks{k}=strcat(windowing{winID(k)+1},': ',preprocess{preID(k)+1});
end
