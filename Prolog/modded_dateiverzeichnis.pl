
:- dynamic(directory/5).
:- dynamic(file/6).

% directory(DirId,Name,ParentId,DateCreated,DateModified)

directory(1,root,0,date(2007,5,2),date(2007,5,2)).
directory(2,bilder,1,date(2007,5,2),date(2009,11,2)).
directory(3,musik,1,date(2007,5,2),date(2009,10,4)).
directory(4,dokumente,1,date(2007,5,2),date(2009,11,5)).
directory(5,urlaub,2,date(2008,6,22),date(2009,8,15)).
directory(6,hochzeit,2,date(2008,1,27),date(2008,1,31)).
directory(7,kinder,2,date(2007,5,2),date(2009,9,5)).
directory(8,klassik,3,date(2007,5,2),date(2007,5,2)).
directory(9,pop,3,date(2007,5,2),date(2009,11,5)).
directory(10,urlaub,4,date(2008,5,23),date(2008,11,1)).
directory(11,hochzeit,4,date(2007,12,4),date(2008,1,25)).
directory(12,scheidung,4,date(2009,9,2),date(2009,11,5)).

% file(FileId,DirId,Name,Size,DateCreated,DateModified)

file(1,9,in_the_summertime,56,date(2007,5,2),date(2009,11,5)).
file(2,9,i_am_so_romantic_tonight,31,date(2007,5,2),date(2009,11,5)).
file(3,9,ich_und_du_fuer_immer,67,date(2007,5,2),date(2009,11,5)).
file(4,9,paris,267,date(2008,6,3),date(2008,6,3)).
file(7,10,quartieranfrage,1,date(2007,5,2),date(2009,11,5)).
file(13,5,paris,251,date(2008,6,22),date(2008,6,17)).
file(14,5,dijon,217,date(2008,6,22),date(2008,6,17)).
file(15,5,die_bruecke_von_avignon,191,date(2008,6,22),date(2008,6,17)).
file(21,6,polterabend,238,date(2008,1,27),date(2008,1,31)).
file(22,6,standesamt,244,date(2008,1,27),date(2008,1,31)).
file(23,6,kirche,158,date(2008,1,28),date(2008,1,31)).
file(24,6,festessen,151,date(2008,1,28),date(2008,1,31)).
file(25,11,standesamt,33,date(2007,6,3),date(2007,6,3)).
file(34,12,scheidungsklage,48,date(2009,9,2),date(2009,11,5)).


% rechnet filename in fileID um.
%
name_zu_id(N,ID) :- file(ID,_,N,_,_,_).

% rechnet dirName in dirID um.
%
dir_name_zu_id(N,ID) :- directory(ID,N,_,_,_).

% errechnet mit Dateinamen den Namen und ID des zugehörigen directory
%
liegt_in_dir(N,DIR,ID) :- file(FID,ID,N,_,_,_),name_zu_id(N,FID),directory(ID,DIR,_,_,_).

% errechnet das directory welches direkt übergeordnet ist.
%
parent_dir_von(P,PID,DIR) :- dir_name_zu_id(DIR,ID),directory(ID,DIR,PID,_,_),dir_name_zu_id(P,PID).

%Sammelt alle files aus einem Directory in einer Liste.
%
von_files_in(LISTE,DID) :- findall(FILE,liegt_in_dir(FILE,_,DID),LISTE).

%Sammelt alle unterverzeichnisse eines spezifizierten directory.
%
von_child_dir(LISTE,DID) :- findall(DIR,parent_dir_von(_,DID,DIR),LISTE).

%berechnet die Anzahl der files in angegebenen directory
%
anzahl_von_files_in_dir(N,DID) :-  von_files_in(LIST,DID),length(LIST,N).

%Setzt Änderungsdatum auf aktuelles Datum.
%
set_date(DID) :- date(D),directory(DID,DIR,PID,DC,_),
                        retract(directory(DID,DIR,PID,DC,_)),
                        assertz(directory(DID,DIR,PID,DC,D)).
set_date(DID,ERR) :- directory(DID,_,_,_,_),set_date(DID),ERR='Erfolgreich'.
set_date(DID,ERR) :- not(directory(DID,_,_,_,_)),ERR='Verzeichniss existiert nicht'.

% Erstellt ein neues Verzeichniss als Unterverzeichniss des angegebenen
% directory
%

als_subdir_hinzufuegen(_,P,PID,ERR) :- not(directory(PID,P,_,_,_)),
                                      ERR='Ungültiges Grundverzeichniss'.

als_subdir_hinzufuegen(DIR,P,PID,ERR) :- directory(PID,P,_,_,_),
                                      directory(_,DIR,PID,_,_),
                                      ERR='Verzeichniss existiert bereits'.

als_subdir_hinzufuegen(DIR,P,PID,MSG) :- directory(PID,P,_,_,_),
                                      als_subdir_hinzufuegen(DIR,PID,MSG).

id(KEY,VAL):- set_flag(KEY,VAL).
naechste_id(KEY,X):- flag(KEY,X,X+1).

set_all_dates(START,MSG) :- directory(START,_,PID,_,_),
                             set_date(START,MSG),
                             set_all_dates(PID,MSG).
set_all_dates(START,MSG) :- not(directory(START,_,_,_,_)),
                             MSG='Erfolgreich'.

als_subdir_hinzufuegen(DIR,PID,MSG) :- naechste_id(directories,X),
                                   date(D),
                                   assertz(directory(X,DIR,PID,D,D)),
                                   set_all_dates(PID,MSG).



als_file_hinzufuegen(_,_,DIR,ID,MSG) :- not(directory(ID,DIR,_,_,_)),
                                      MSG='Ungültiges Grundverzeichniss'.

als_file_hinzufuegen(FILE,_,DIR,ID,MSG) :- directory(ID,DIR,_,_,_),
                                      file(_,ID,FILE,_,_,_),
                                      MSG='Datei existiert bereits'.

als_file_hinzufuegen(FILE,SIZE,DIR,ID,MSG) :- directory(ID,DIR,_,_,_),
                                      als_file_hinzufuegen(FILE,SIZE,DIR,MSG).

als_file_hinzufuegen(FILE,SIZE,DIR,MSG) :- naechste_id(files,X),
                                          date(D),
                                          directory(ID,DIR,_,_,_),
                                          assertz(file(X,ID,FILE,SIZE,D,D)),
                                          set_all_dates(DIR,MSG).


file_changed(ID,MSG) :-
    file(ID,DID,NAME,SZ,DC,_),
    date(D),
    directory(DID,_,_,_,_),
    retract(file(ID,DID,NAME,SZ,DC,_)),
    assertz(file(ID,DID,NAME,SZ,DC,D)),
    set_all_dates(DID,MSG).
