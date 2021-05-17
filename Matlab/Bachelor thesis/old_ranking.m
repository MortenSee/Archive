%% Cell-array der Daten für die Bachelorarbeit
%Format:
%{'filename','8px 1px-versatz','8px 4px-versatz','16px 1px-versatz','16px 8px-versatz','16px 4px-versatz','Bytesizes','Label'};
% Für jeden filename sind alle weiteren Einträge 4x2 :
%(original,-0.1,0.1,-0.1+0.1)x(score vor scaling,score nach scaling)
%Bytesize ist 1x2 : (original größe, at komprimierte größe)
%Label ist 1x1 : Meine Einschätzung ob das Bild Texturlastig oder Geometrielastig ist
% '0' Keine Textur , '0.25' wenig Textur, '0.5' Ausgeglichen, '0.75' wenig  Geometrie , '1' Keine Geometrie
% Die Verteilung der 104 Bilderlabels ist [10, 16, 19, 21, 38]
%Compression Label: Wenn Besser als Durchschnitt komprimiert wurde als Texturarm gelabled

load('database.mat');
data_array=data;

[n,m]=size(data_array);
%compression_factors=zeros(n,1);
% (4 different preprocesses)x(9 different Window/hop-size combinations)
MyRankings=zeros(n,36);
rankings=zeros(n,36);
%% calculate ranking
for k=2:n
row=data_array(k,:);

mat8_1=cell2mat(row(2));
mat8_2=cell2mat(row(3));
mat8_4=cell2mat(row(4));
mat8_8=cell2mat(row(5));
mat16_1=cell2mat(row(6));
mat16_2=cell2mat(row(7));
mat16_4=cell2mat(row(8));
mat16_8=cell2mat(row(9));
mat16_16=cell2mat(row(10));
bytes=cell2mat(row(11));
Mylabel=cell2mat(row(12));
label=cell2mat(row(13));

%comp_factor=bytes(2)/bytes(1);
%compression_factors(k,1)=comp_factor;
%take all the non scaled entries (1 col of each) and assemble them in a 36x1
scores=[mat8_1(:,1);mat8_2(:,1);mat8_4(:,1);mat8_8(:,1);mat16_1(:,1);mat16_2(:,1);mat16_4(:,1);mat16_8(:,1);mat16_16(:,1)];
%% Rank them acording to size w.r.t label( see bookmark)
%0-.5: small to large  | 0.75-1: large to small
if Mylabel<=0.5
   Myorder = 'ascend'; 
else
   Myorder = 'descend';
end
if label<=0.5
   order = 'ascend'; 
else
   order = 'descend';
end
[~,Myp] = sort(scores,Myorder);
r=1:length(scores);
MyRankings(k,:)=r(Myp);

[~,p] = sort(scores,order);
r=1:length(scores);
rankings(k,:)=r(p);
end

%% sum up placements for each id for all k images to determine final ranking
final_score=sum(MyRankings,1);
[~,MyRanking]=sort(final_score,'ascend');

final_score=sum(rankings,1);
[~,Ranking]=sort(final_score,'ascend');

%translate rankings












