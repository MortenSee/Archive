%Baum
%
%
% s( a, s( s(a,b), c)).

s(X,Y):- atom(X),atom(Y).
s(X,s(Y,Z)):- atom(X),s(Y,Z).
s(s(X,Y),Z):- s(X,Y),atom(Z).
s(s(X,Y),s(V,W)):- s(X,Y),s(V,W).


tiefe(X,0):- atom(X).
tiefe(s(X,_),N):- tiefe(X,N1),N is 1+N1.
tiefe(s(_,Y),N):- tiefe(Y,N1),N is 1+N1.

tiefe_er(X,N,N):-atom(X).

tiefe_er(s(X,_),AKK,N):- AKK1 is AKK+1,
                         tiefe_er(X,AKK1,N).
tiefe_er(s(_,Y),AKK,N):- AKK1 is AKK+1,
                         tiefe_er(Y,AKK1,N).
tiefe2(X,N):- tiefe_er(X,0,N).

max_tiefe(X,Max):- findall(N,tiefe(X,N),L),max_list(L,Max).





