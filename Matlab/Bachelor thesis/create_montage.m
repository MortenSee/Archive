%% processes all images in 
src = 'E:\#Orga\Studium\Bachelor\Iske\IMG\sample';

dir4 ='E:\#Orga\Studium\Bachelor\Iske\IMG\montage';

%constructs dir pathname
filePattern= fullfile(src,'*.pgm');
%loads the dir
theFiles= dir(filePattern);
%counts the number of pgm files in it
filecount=size(dir([src '\*.pgm']),1);

for k=1:filecount
   %% gets the filename of the k'th file
   baseFilename=theFiles(k).name;
   %% constructs the full filepath
   filename=fullfile(src,baseFilename);

   %% reads image
   img=imread(filename);
   %% change filetype to png
   id=length(baseFilename);
   id1=id-1;
   baseFilename(id1)='n';
   baseFilename(id)='g';
   %% constructs export filepaths
%    fn1=fullfile(dir1,baseFilename);
%    fn2=fullfile(dir2,baseFilename);
%    fn3=fullfile(dir3,baseFilename);
   fn4=fullfile(dir4,baseFilename);
   
   %% applies local edge-aware contrast filter
   hc_01_neg01 = localcontrast(img,0.1,-0.1);
   
   hc_01_pls01 = localcontrast(img,0.1,1);
   
   hc_01_bth01 = localcontrast(img,0.1,-0.1);
   hc_01_bth01 = localcontrast(hc_01_bth01,0.1,1);
   %writes high contrast version to disk
%    imwrite(hc_img,fn2,'pgm');
   %% Performs PCA based image classification
   % 8px 1px 
   [ms11,sc_ms11,mat1,~,~]=Classifier(img,3,3);
   [ms12,sc_ms12,mat2,~,~]=Classifier(hc_01_neg01,3,3);
   [ms13,sc_ms13,mat3,~,~]=Classifier(hc_01_pls01,3,3);
   [ms14,sc_ms14,mat4,~,~]=Classifier(hc_01_bth01,3,3);
   
   %% save the images to the directories
%    imwrite(sv_matrix,fn1,'png');
%    imwrite(thinned,fn2,'png');
%    imwrite(img,fn3,'png');

   %% construct montage
   fs1=imfuse(img,hc_01_neg01,'montage','Scaling','none');
   fs2=imfuse(hc_01_pls01,hc_01_bth01,'montage','Scaling','none');
   
   matfs1=imfuse(mat1,mat2,'montage','Scaling','none');
   matfs2=imfuse(mat3,mat4,'montage','Scaling','none');
   
   fs3=imfuse(fs1,fs2,'montage','Scaling','none');
   matfs3=imfuse(matfs1,matfs2,'montage','Scaling','none');

   %% save montage
   %montage should be png
%    fn4(length(fn4))='g';
%    fn4(length(fn4)-1)='n';
   imwrite(fs3,fn4,'png');
   fn4_2=strcat(fn4(1:length(fn4)-4),'_svmat','.png');
   imwrite(matfs3,fn4_2,'png');
   
%% outputs completion 
   percent=100*k/filecount;
   fprintf("finished with '%s': %2.2f%% done...\n",baseFilename,percent); 
   
end