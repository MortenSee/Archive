
src = 'E:\#Orga\Studium\Bachelor\Iske\IMG\pgms';
%exports... their minSVD Matrix to
dir1 = 'E:\#Orga\Studium\Bachelor\Iske\IMG\svmatrix';
%...a local contrast filtered version
dir2 = 'E:\#Orga\Studium\Bachelor\Iske\IMG\highcontrast_pgms';
%...the original image to
dir3 = 'E:\#Orga\Studium\Bachelor\Iske\IMG\testbilder';
%... a montage of all 3 to
dir4 ='E:\#Orga\Studium\Bachelor\Iske\IMG\montage';

at_dir='E:\#Orga\Studium\Bachelor\Iske\IMG\AT-compressed\';

%constructs dir pathname
filePattern= fullfile(src,'*.pgm');
%loads the dir
theFiles= dir(filePattern);
%counts the number of pgm files in it
filecount=size(dir([src '\*.pgm']),1);
%starts a timer
tic

more_data=zeros(104,8);
for k=1:filecount
    
   baseFilename=theFiles(k).name;
   filename=fullfile(src,baseFilename);
   img=imread(filename);

   %% applies local edge-aware contrast filter
   hc_01_neg01 = localcontrast(img,0.1,-0.1);
   hc_01_pls01 = localcontrast(img,0.1,0.1);
   hc_01_bth01 = localcontrast(hc_01_neg01,0.1,0.1);

   
   [ms11,sc_ms11,~,~,~]=Classifier(img,3,3);
   [ms12,sc_ms12,~,~,~]=Classifier(hc_01_neg01,3,3);
   [ms13,sc_ms13,~,~,~]=Classifier(hc_01_pls01,3,3);
   [ms14,sc_ms14,~,~,~]=Classifier(hc_01_bth01,3,3);
   
   dat1=[ms11,sc_ms11,ms12,sc_ms12,ms13,sc_ms13,ms14,sc_ms14];
%     dat1=[ms11,sc_ms11];
    more_data(k,:)=dat1;

   percent=100*k/filecount;
   fprintf("finished with '%s': %2.2f%% done...\n",baseFilename,percent); 
   
end

fprintf("finished proecessing all images!\n");
toc
tpp=toc/k;
fprintf("average time taken per picture: %2.2f seconds! \n ",tpp);


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
