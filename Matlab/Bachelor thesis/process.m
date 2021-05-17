
%% processes all images in 
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
data=cell(filecount+1,13);
data(1,:)={'filename','8px--8px','8px--4px','8px--2px','8px--1px','16px--16px','16px--8px','16px--4px','16px--2px','16px--1px','Bytesizes','Labels','MyLabels'};
for k=1:filecount
    
    %construct the row to be filled
    row=cell(1,13);
    
   %% gets the filename of the k'th file
   baseFilename=theFiles(k).name;
   %% constructs the full filepath
   filename=fullfile(src,baseFilename);
   %% construct filepath of the AT version of the same file
   at_file=strcat(baseFilename(1:length(baseFilename)-4),'_AT5_I1000_Q4.at');
   at_filename=strcat(at_dir,at_file);
   
   % get filesizes of both files
   bytesize=theFiles(k).bytes;
   at_bytesize=dir(at_filename).bytes;
   size_data=[bytesize,at_bytesize];
   
   row{1,1}=filename;
   row{1,11}=size_data;
   %% reads image
   img=imread(filename);
   %% change filetype to png
%    id=length(baseFilename);
%    id1=id-1;
%    baseFilename(id1)='n';
%    baseFilename(id)='g';
   %% constructs export filepaths
%    fn1=fullfile(dir1,baseFilename);
%    fn2=fullfile(dir2,baseFilename);
%    fn3=fullfile(dir3,baseFilename);
%    fn4=fullfile(dir4,baseFilename);
   
   %% applies local edge-aware contrast filter
   hc_01_neg01 = localcontrast(img,0.1,-0.1);
   
   hc_01_pls01 = localcontrast(img,0.1,0.1);
   
   hc_01_bth01 = localcontrast(hc_01_neg01,0.1,0.1);
   %writes high contrast version to disk
%    imwrite(hc_img,fn2,'pgm');
   %% Performs PCA feature extraction
   %8px window loop
   for r=0:3
       [ms11,sc_ms11,~,~,~,~]=Classifier(img,3,r);
       [ms12,sc_ms12,~,~,~,~]=Classifier(hc_01_neg01,3,r);
       [ms13,sc_ms13,~,~,~,~]=Classifier(hc_01_pls01,3,r);
       [ms14,sc_ms14,~,~,~,~]=Classifier(hc_01_bth01,3,r);
       
       row{1,r+2}=[ms11,sc_ms11,ms12,sc_ms12,ms13,sc_ms13,ms14,sc_ms14];
   end
   
   %16px window loop
   for r=0:4
       [ms11,sc_ms11,~,~,~,~]=Classifier(img,4,r);
       [ms12,sc_ms12,~,~,~,~]=Classifier(hc_01_neg01,4,r);
       [ms13,sc_ms13,~,~,~,~]=Classifier(hc_01_pls01,4,r);
       [ms14,sc_ms14,~,~,~,~]=Classifier(hc_01_bth01,4,r);
       
       row{1,r+6}=[ms11,sc_ms11,ms12,sc_ms12,ms13,sc_ms13,ms14,sc_ms14];
   end
   
   data(k+1,:)=row;
   
   %% save the images to the directories
%    imwrite(sv_matrix,fn1,'png');
%    imwrite(thinned,fn2,'png');
%    imwrite(img,fn3,'png');

   %% construct montage
%    fuse=imfuse(sv_matrix,hc_sv_matrix,'montage','Scaling','none');
%    fuse2=imfuse(img,hc_img,'montage','Scaling','none');
%    montage=imfuse(fuse,fuse2,'montage','Scaling','none');
   %% save montage
   %montage should be png
%    fn4(length(fn4))='g';
%    fn4(length(fn4)-1)='n';
%    imwrite(montage,fn4,'png');
   
%% outputs completion 
   percent=100*k/filecount;
   fprintf("finished with '%s': %2.2f%% done...\n",baseFilename,percent); 
   
end
fprintf("finished proecessing all images!\n");
toc
tpp=toc/k;
fprintf("average time taken per picture: %2.2f seconds! \n ",tpp);
