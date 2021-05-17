%Load data cell array
load('database_with_scaling.mat');
%Set percentage cutoff from both sides
p=0.125;

% get image labels (12 labels | 13 my labels)
labels=cell2mat(data(2:105,12));

%for each data column (2-10) construct value array (each image has 1x8 datapoints)
jaccard_row=cell(1,13);
jaccard_row{1}='Jaccard';
for col=2:10
jaccards=zeros(1,8);
column=cell2mat(data(2:105,col));
%construct the class boundaries for each option (which version of the image)
    for k=1:8
        data_col=column(:,k);
        %Class 1 -> values expected to be smaller
        class1=data_col(labels<0.5);
        % Class 2-> values expected to be bigger
        class2=data_col(labels>=0.5);
        
        % get mean and standard deviation
        mean1=mean(class1);
        std1=std(class1);
        mean2=mean(class2);
        std2=std(class2);
        %calculate z scores
        z_low=norminv(p);
        z_high=norminv(1-p);
        x1_low=z_low*std1 + mean1;
        x2_low=z_low*std2 + mean2;
        x1_high=z_high*std1 + mean1;
        x2_high=z_high*std2 + mean2;
        % cut classes at those z scores
        class1_cut=class1(class1<=x1_high);
        class1_cut=class1_cut(class1_cut>=x1_low);

        class2_cut=class2(class2<=x2_high);
        class2_cut=class2_cut(class2_cut>=x2_low);
        %calculate jaccard metric
        dist=MyJaccard(class1_cut,class2_cut);
        
        jaccards(k)=dist;
    end
    %fill the new column of data with the jaccard matrix
    jaccard_row{col}=jaccards;
end
data=[data;jaccard_row];


