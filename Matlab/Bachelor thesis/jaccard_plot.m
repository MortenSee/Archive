%% Options:
% window: range: 2-10 | determines window/hopsize
window=8;
% source: range: 1-8  | determines image source.
% Even numbers are scaled score versions.
% 1: Original, 3:less , 5:more , 7:both
source=4;
% p: range: 0-1 | % of data that gets cut off at both ends.
p=0.125;

%% Constructing the plot

data_column=cell2mat(data(2:105,window));
column=data_column(:,source);

ys=zeros(104,1);
labels=cell2mat(data(2:105,12));
for k=1:104 
   ys(k)=ys(k)+ labels(k)*0.1;
end
% Die Daten nach klasse aufgeteilt
class1=column(labels<0.5);
class2=column(labels>=0.5);
% z score berechnen für mittlere 60%
mean1=mean(class1);
std1=std(class1);
mean2=mean(class2);
std2=std(class2);

z_low=norminv(p);
z_high=norminv(1-p);
x1_low=z_low*std1 + mean1;
x2_low=z_low*std2 + mean2;
x1_high=z_high*std1 + mean1;
x2_high=z_high*std2 + mean2;

class1_cut=class1(class1<=x1_high);
class1_cut=class1_cut(class1_cut>=x1_low);

class2_cut=class2(class2<=x2_high);
class2_cut=class2_cut(class2_cut>=x2_low);

jaccard=MyJaccard(class1_cut,class2_cut)

gscatter(column,ys,labels);
figure();
scatter(class1,zeros(length(class1),1));
hold on;
scatter(class1_cut,zeros(length(class1_cut),1));
scatter(class2,ones(length(class2),1));
scatter(class2_cut,ones(length(class2_cut),1));
hold off;

