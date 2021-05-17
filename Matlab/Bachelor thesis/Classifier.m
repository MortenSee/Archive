%Klassifizieren eines Bildes als Geometrie- oder Texturlastig mittels
%lokaler PCA auf Patches der größe 2^r

%FILENAME - Das zu klassifizierende Bild
%Patchsize - die größe der patches

%Bisher nur (2^n)x(2^n) Bilder
function [mean_score,scaled_mean_score,sv_matrix,sv_vektor,scaled_vec,features] = Classifier(file,r,r2)

% Einlesen des Bildes
% FIXEN WENN MAN DATEINAMEN ANGIBT
if isstring(file)
    img = imread(file);
else
    img=file;
end
% Größe des Bildes (als exponent der 2er Potenz)
n=log2(size(img));
n=n(1,1);

% Patches
% Patchgröße
psize=2^r;
faktor=2^r2;
% Offset der patches.
offsetsize = psize/faktor;

% Berechnung der Anzahl der Patches abhängig von derer Größe und Bildgröße
m = (faktor)*(2^(n-r))-(faktor-1);

% Initialisieren von variablen für loop

i=1;
j=1;
% data
sv_matrix=zeros(m,m);

%% Füllen von sv_matrix(i,j) mit den kleinsten SV aus dem i-j-Patch 

% Zeilen loop
for a=1:m
% Spalten loop
for k=1:m
    % Patch is ein (psize)x(psize) block aus img mit oberer linker Ecke
    % an position (i,j) in img
    Patch = img(i:i+psize-1 ,j:j+psize-1);
    
    % SVD des Patch solange dieser nicht die 0 Matrix
    
    % konvertierung in double für mehr präzision
    Patch = double(Patch);
    [~,S,~]=svd(Patch);
    svs=S*S';
    % Bestimmen des minimalen SV
    min_sv = min(max(svs));
    % Eintragen in die Daten Matrix
    sv_matrix(a,k)= min_sv;
    % offset addieren für die nächste itteration
    j = 1+k*offsetsize;
end
% Sobald eine Zeile fertig ist muss zu der Zeile ebenfalls der offset
% addiert werden
 i = 1+a*offsetsize;
% In der neuen Zeile fangen wir von Vorne an
 j = 1;
end


%%% --Klassifiziereung--

%% Berechnen von allerlei werten der sv_matrix
% SV matrix als vektor
sv_vektor=reshape(sv_matrix,m^2,1);
scaled_vec=sv_vektor;

% Berchnen des mean des Bilds
sv_mean=mean(sv_vektor);

% Berechnen der stddev des Bilds
sv_std=std(sv_vektor);

%min und max einträge der Matrix
sv_min=min(sv_vektor);
sv_max=max(sv_vektor);
sv_range=sv_max-sv_min;
features=[sv_min,sv_max,sv_range,sv_mean,sv_std];
%% Verwerfen der bottom p% der Werte 
% %Berechnen des z-score für p
% sv_zscore=norminv(p);
% cutoff= sv_zscore*sv_std + sv_mean;
 
% test_img(test_img<cutoff)=0;


%% Metrik 1 -- "Naiv" -- "Weiße" Pixel / Alle Pixel
% schlechter Ansatz da fast alle Pixel nicht-schwarz sind

%% Metrix 2 -- "Mean" -- Mean / 255 
scaled_vec(scaled_vec<=0.1)=0;
scaled_vec(scaled_vec>=sv_mean+sv_std)=sv_mean+sv_std;
scaled_vec=rescale(scaled_vec,0,255);

% score berechnen
mean_score = mean(sv_vektor);
scaled_mean_score = mean(scaled_vec);
% bild anzeigen
% imshow(reshape(mean_vektor,m,m));




%% Metrix 3 -- ??? -- ???
%




end

