function [Scores]=data2()
[Data]=data();
Scores=zeros(length(Data),3);

for k=1:length(Data)
   Scores(k,1)= Data{k,3} / Data{k,2};
end


end