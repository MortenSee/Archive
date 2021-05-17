
%
filename='E:\#Orga\Studium\Bachelor\Iske\IMG\pgms\Baer512.pgm';
img=imread(filename);
r=3;
r2=3;
%Ein aufruf von classifier
 hc_01_neg01 = localcontrast(img,0.1,-0.1);
 hc_01_pls01 = localcontrast(img,0.1,0.1);
 hc_01_bth01 = localcontrast(hc_01_neg01,0.1,0.1);

   
 [ms11,sc_ms11,~,~,orig]=Classifier(img,3,3);
 [ms12,sc_ms12,~,~,neg]=Classifier(hc_01_neg01,3,3);
 [ms13,sc_ms13,~,~,pos]=Classifier(hc_01_pls01,3,3);
 [ms14,sc_ms14,~,~,bot]=Classifier(hc_01_bth01,3,3);
 
% [mean_score,scaled_mean_score,sv_matrix,mvec,sc_vec] = Classifier(img,r,r2);


% imshow(sv_matrix);

% meanval=mean(mvec);
% leq1=sum(mvec<=1);
% leq01=sum(mvec<=0.1);
% leqmean=sum(mvec<=meanval);
% maxval=max(mvec);
% gtmean=mvec(mvec>meanval);
% bigmean=mean(gtmean);
% gtbigmean=sum(gtmean>=bigmean);
