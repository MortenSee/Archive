
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
% data=cell(filecount+1,7);
% data(1,:)={'filename','8px 1px-versatz','8px 4px-versatz','16px 1px-versatz','16px 8px-versatz','16px 4px-versatz','Bytesizes'};
more_data=cell(105,1);
for k=1:filecount
   %% gets the filename of the k'th file
   baseFilename=theFiles(k).name;
   %% constructs the full filepath
   filename=fullfile(src,baseFilename);
   %% construct filepath of the AT version of the same file
%    at_file=strcat(baseFilename(1:length(baseFilename)-4),'_AT5_I1000_Q4.at');
%    at_filename=strcat(at_dir,at_file);
   
   %% get filesizes of both files
%    bytesize=theFiles(k).bytes;
%    at_bytesize=dir(at_filename).bytes;
%    size_data=[bytesize,at_bytesize];
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
   %% Performs PCA based image classification | ALS LOOP REFACTOREN
 % 8px 4px 
   [ms11,sc_ms11,~,~,~]=Classifier(img,3,1);
   [ms12,sc_ms12,~,~,~]=Classifier(hc_01_neg01,3,1);
   [ms13,sc_ms13,~,~,~]=Classifier(hc_01_pls01,3,1);
   [ms14,sc_ms14,~,~,~]=Classifier(hc_01_bth01,3,1);
   
   dat1=[ms11,sc_ms11;ms12,sc_ms12; ms13,sc_ms13; ms14,sc_ms14];
%    %8px 8px
%    [ms21,sc_ms21,~,~,~]=Classifier(img,3,0);
%    [ms22,sc_ms22,~,~,~]=Classifier(hc_01_neg01,3,0);
%    [ms23,sc_ms23,~,~,~]=Classifier(hc_01_pls01,3,0);
%    [ms24,sc_ms24,~,~,~]=Classifier(hc_01_bth01,3,0);
%    
%    dat2=[ms21,sc_ms21;ms22,sc_ms22; ms23,sc_ms23; ms24,sc_ms24];
%    %16px 8px
%    [ms31,sc_ms31,~,~,~]=Classifier(img,4,1);
%    [ms32,sc_ms32,~,~,~]=Classifier(hc_01_neg01,4,1);
%    [ms33,sc_ms33,~,~,~]=Classifier(hc_01_pls01,4,1);
%    [ms34,sc_ms34,~,~,~]=Classifier(hc_01_bth01,4,1); 
%    
%    dat3=[ms31,sc_ms31;ms32,sc_ms32; ms33,sc_ms33; ms34,sc_ms34];
%    %16px 16px
%    [ms41,sc_ms41,~,~,~]=Classifier(img,4,0);
%    [ms42,sc_ms42,~,~,~]=Classifier(hc_01_neg01,4,0);
%    [ms43,sc_ms43,~,~,~]=Classifier(hc_01_pls01,4,0);
%    [ms44,sc_ms44,~,~,~]=Classifier(hc_01_bth01,4,0);  
%    
%    dat4=[ms41,sc_ms41;ms42,sc_ms42; ms43,sc_ms43; ms44,sc_ms44];
   
%    more_data(k+1,:)={dat1,dat2,dat3,dat4};
   more_data(k+1,:)={dat1};
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
