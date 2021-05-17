
%Set1 sampling eines reelen intervalls,
%Set2 sampling eines reelen intervalls
%dist Jaccard distance der Intervalle, range 0-1, größer -> besser seperiert
function [dist] = MyJaccard(Set1,Set2)
%oBdA Set1 hat kleinere Werte
max1=max(Set1);
min2=min(Set2);

%Berechnen des Schnitts
int1=Set1(Set1>=min2);
int2=Set2(Set2<=max1);
intSize=length(int1)+length(int2);
%Berechnen der Vereinigung
unionSize=length(Set1)+length(Set2);

dist= (unionSize - intSize)/unionSize; 
end
