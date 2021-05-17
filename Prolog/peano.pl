peano(0).
peano(s(X)) :- peano(X).

lt(0,s(_)).
lt(s(X),s(Y)):-lt(X,Y).

add(0,X,X).
add(s(X),Y,s(R)):-add(X,Y,R).



peano2int(0,0).
peano2int(s(X),INT) :- peano2int(X,I1),INT is I1 +1.


suc(0,s(0)).
suc(s(X),SUC) :- add(s(X),s(0),SUC).

prev(s(0),0).
prev(s(X),PREV):- add(PREV,s(0),s(X)).

subtract(s(X),s(Y),s(R)):- add(s(R),s(Y),s(X)).


minimum(0,_,0).
minimum(s(X),s(Y),s(R)):-lt(s(X),s(Y)),s(R)=s(X).

min(X,Y,X):- minimum(X,Y,X).
min(X,Y,Y):- minimum(Y,X,Y).

mul(0,_,0).
mul(_,0,0).
mul(s(0),X,X).
mul(X,s(0),X).

mul(s(X),s(Y),s(P)):-add(s(P1),s(Y),s(P)),mul(X,s(Y),s(P1)).



int2peano(0,0).
int2peano(N,s(P)):- N>0,N1 is N - 1, int2peano(N1,P).
