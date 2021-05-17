
%Skigebiet
%
% eine Strecke ist ein Stück einer Skipiste, die sich zwischen 2
% Knotenpunkten befindet
%
% Start- und Endpunkte:
% kn: Streckenkreuzung
% bg: bergstation eines Liftes
% tl: talstation eines Liftes
%
% Pistennummer:
% Die Nummer der Piste, zu dem der Abschnitt gehört
%
% Länge:
% Länge in Metern
%
%
%strecke(Streckennummer,Startpunkt,Endpunkt,Pistennummer,Laenge)
strecke(1,bgrootmoos,kn1,1,1000).
strecke(2,kn1,kn2,1,900).
strecke(3,kn2,kn3,1,600).
strecke(4,kn3,kn4,1,400).
strecke(5,kn4,bggondel,1,500).
strecke(6,bgpanorama,kn5,1,600).
strecke(7,kn5,kn2,1,400).
strecke(8,kn1,kn6,1,500).
strecke(9,kn6,kn3,1,500).
strecke(10,bggondel,tlrootmoos,1,300).
strecke(11,tlrootmoos,tlzollberg,1,400).

strecke(12,tlrootmoos,tlpanorama,1,1000).
strecke(13,tlpanorama,tlgondel,1,2500).

strecke(14,kn6,kn7,2,500).
strecke(15,kn7,bggondel,2,1000).
strecke(16,bggondel,tlpanorama,2,1000).
strecke(17,tlpanorama,tlgondel,2,1500).

strecke(18,bgrootmoos,kn7,3,800).
strecke(19,kn7,bggondel,3,900).
strecke(20,kn1,kn7,3,300).

strecke(21,bgrootmoos,kn8,4,2000).

strecke(22,bgrootmoos,bgzollberg,5,1500).

strecke(23,bgzollberg,kn8,6,1200).
strecke(24,kn8,bggondel,6,500).
strecke(25,kn8,tlzollberg,6,300).

strecke(26,bgpanorama,kn9,7,1000).
strecke(27,kn9,kn4,7,700).

strecke(28,bgpanorama,kn10,8,400).
strecke(29,kn10,kn9,8,900).
strecke(30,kn9,kn11,8,300).

strecke(31,kn5,kn4,9,900).
strecke(32,kn4,tlpanorama,9,1600).

strecke(33,bgzirben,kn12,10,3500).
strecke(34,tlzirben,tlpanorama,10,2500).

strecke(35,bgzirben,kn10,11,800).
strecke(36,kn10,kn11,11,1000).
strecke(37,kn11,kn13,11,1400).
strecke(38,kn13,kn12,11,400).
strecke(39,kn12,tlzirben,11,400).

strecke(40,bgzirben,kn13,12,1700).
strecke(41,kn13,tlzirben,12,300).


%Skipisten
%
%piste(Nummer,Name,Schwierigkeit)
piste(1,familienabfahrt,blau).
piste(2,fis-abfahrt,rot).
piste(3,benni-raich-abfahrt,schwarz).
piste(4,rootmoos-abfahrt,schwarz).
piste(5,kanonenrohr,schwarz).
piste(6,zollberg-abfahrt,rot).
piste(7,sechszeiger-abfahrt,rot).
piste(8,kalbenalmabfahrt,rot).
piste(9,niederjoechl-abfahrt,rot).
piste(10,panorama-abfahrt,rot).
piste(11,zirben-abfahrt,rot).
piste(12,zirbenfall-abfahrt,schwarz).

%Lifte
%
%lift(Name,Startpunkt,Endpunkt,Fahrtzeit).
lift(hochzeigerbahn,tlgondel,bggondel,15).
lift(rootmoos,tlrootmoos,bgrootmoos,12).
lift(sechszeigerbahn,bggondel,bgpanorama,14).
lift(panoramabahn,tlpanorama,bgpanorama,10).
lift(zollberglift,tlzollberg,bgzollberg,9).
lift(zirbenbahn,tlzirben,bgzirben,10).


ist_erreichbar(S,Z) :- strecke(_,S,Z,_,_).
ist_erreichbar(S,Z) :- strecke(_,S,X,_,_),ist_erreichbar(X,Z).

moeglicher_ort(O) :- ist_erreichbar(O,tlgondel).
alle_moegl_orte(L) :- findall(O,moeglicher_ort(O),L).
ohne_duplikate(X):- alle_moegl_orte(L),sort(L,X).
ort(O) :- member(O,L),ohne_duplikate(L).
