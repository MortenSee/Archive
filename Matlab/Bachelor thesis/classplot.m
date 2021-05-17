% EDIT: 
% Die datei soll nur die plots erzeugen! 
load('database.mat');

column=more_data(:,8);


ys=zeros(104,1);
labels=cell2mat(data(2:105,13));
for k=1:104 
   ys(k)=ys(k)+ labels(k)*0.1;
end


gscatter(column,ys,labels);

%Aus database.mat laden
% load('database.mat');
% %9 => 8px 4px versatz
% column=cell2mat(data(2:105,9));
% 
% original=zeros(104,1);
% ys=zeros(104,1);
% labels=cell2mat(data(2:105,13));
% for k=1:104
%    original(k)=255*column(4+4*(k-1),1); 
%    ys(k)=ys(k)+ labels(k)*0.1;
% end
% 
% 
% gscatter(original,ys,labels);
