:- dynamic mutter_von/2, vater_von/2.        % ermoeglicht dynamische Veraenderung
% :- multifile mutter_von/2, vater_von/2.      % ermoeglicht verteilte Definition in mehreren Files

% mutter_von( Mutter , Kind ).
% 'Mutter' und 'Kind' sind Argumentpositionen,
% so dass 'Mutter' die Mutter von 'Kind' ist.

mutter_von( marie , hans ).
mutter_von( marie , helga ).
mutter_von( julia , otto ).
mutter_von( barbara , klaus ).
mutter_von( barbara , andrea ).
mutter_von( charlotte , barbara ).
mutter_von( charlotte , magdalena ).
mutter_von( ursula, julia).
mutter_von( ursula, charlotte).
mutter_von(annelore, walter).
mutter_von(annelore, marie).


% vater_von( Vater , Kind ).
% 'Vater' und 'Kind' sind Argumentpositionen,
% so dass 'Vater' die Vater von 'Kind' ist.

vater_von( otto , hans ).
vater_von( otto , helga ).
vater_von( gerd , otto ).
vater_von( johannes , klaus ).
vater_von( johannes , andrea).
vater_von( walter , barbara ).
vater_von( walter , magdalena ).
vater_von( peter, walter).
vater_von( peter, marie).
vater_von( dieter, charlotte).
vater_von( heinrich, julia).

kind_von(K,E) :- vater_von(E,K);mutter_von(E,K).

enkel_von(K,GE) :- kind_von(E,GE),kind_von(K,E),K\=E.

vorfahre_von(VF,NF) :- kind_von(NF,VF).
vorfahre_von(VF,NF) :- kind_von(NF,X),vorfahre_von(VF,X).

gemeinsamer_vorfahre(P1,P2,GV) :- vorfahre_von(GV,P1),vorfahre_von(GV,P2).


erster_gemeinsamer_vorfahre(P1,P2,EGV) :- gemeinsamer_vorfahre(P1,P2,EGV),
                                          not((vorfahre_von(EGV,AGV),
                                              gemeinsamer_vorfahre(P1,P2,AGV))).
