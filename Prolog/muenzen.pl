muenze(X):-member(X,[1,2,5,10,20,50,100,200]).

wechselgeld(X,[X]):-muenze(X).

wechselgeld(Sum,[H|T]):- Sum>1,
                         muenze(H),
                         S2 is Sum-H,
                         wechselgeld(S2,T).

%msort ist sort ohne das entfernen von duplikaten.
sortiertes_wechselgeld(S,L):- wechselgeld(S,A),msort(A,L).

% Wenn alle moeglichen sortierten Listen gefunden werden müssen gleiche
% Listen jedoch wieder entfernt werden.
moegliches_wechselgeld(S,L):- findall(K,sortiertes_wechselgeld(S,K),L1),sort(L1,L).


allgemeine_muenze(M,Menge):- member((M,X),Menge),X>0.

max_kandidat(S,K,M):- allgemeine_muenze(K,M),S1 is S-K,not(S1<0),
                    not((allgemeine_muenze(K1,M),K1>K,S2 is S-K1,not(S2<0),S2<S1)).


wechselgeld2(X,[X],M):-max_kandidat(X,X,M).
wechselgeld2(Sum,[H|T],M):- Sum>1,
                          max_kandidat(Sum,H,M),
                          S2 is Sum-H,
                          wechselgeld2(S2,T,M).


% V = [(1,5),(2,3),(5,0),(10,1),(20,6),(50,1),(100,12),(200,0)].

automat(L,L,[]).
automat([],L,L).
automat([H|T],V,Vneu):- member((H,X),V),
                        X>0,
                        subtract(V,[(H,X)],V1),
                        X1 is X-1,
                        append(V1,[(H,X1)],V2),
                        automat(T,V2,Vneu).

%get_muenzen(Vorat,Muenzeinheiten)
get_muenzen([],[]).
get_muenzen(Vorat,[H|T]):- member((H,X),Vorat),X>0,subtract(Vorat,[(H,X)],V1),get_muenzen(V1,T).

muenzgroessen(Vorat,L):-get_muenzen(Vorat,L),!.

automat_wechselgeld(S,L,V,Vneu):- wechselgeld2(S,L,V),automat(L,V,Vneu).



bonus(Preis,Gegeben,Wechsel,Vorat,VoratNeu)
                              :- Rueckgeld is Gegeben-Preis,
                                 automat_wechselgeld(Rueckgeld,Wechsel,Vorat,VoratNeu).
