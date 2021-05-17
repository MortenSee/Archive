%gegeben ist eine Binärzahl als Liste.
% Beginnend mit 2**0,trailing 0's nicht erlaubt.
% Bsp: [0,1,0,0,1] = 18

is_odd([1|_]).
umrechner([],X,_,X).
umrechner([H|T],Akk,Count,N):- Akk1 is Akk + (2**Count)*H,
                               Count1 is Count +1,
                               umrechner(T,Akk1,Count1,N).
convert(0,[]).
convert(X,N):- umrechner(X,0,0,N).

convert2(0,[]).
convert2(N,Bin):-   Odd is N mod 2,
                    Divisor is N//2,
                    convert2(Divisor,Tail),
                    Bin=[Odd|Tail].




is_odd2(X):- convert(X,Y), 1 is Y mod 2.

%auch halbieren falls gerade.
double(X,[0|X]).

double2(0,0).
double2(X,Y):- convert(X,A), B is 2*A, convert2(B,Y).


minus_eins([1],[]).
minus_eins([1|T],[0|T]).

is_binary([]).
is_binary([H|T]):- H=1,is_binary(T).
is_binary([H|T]):- H=0,is_binary(T).


%Logic Gates
or(A,B,1):- A+B>0.
or(A,B,0):- not(or(A,B,1)).

and(A,B,1):- A+B=:=2.
and(A,B,0):- not(and(A,B,1)).

xor(A,B,1):- A+B=:= 1.
xor(A,B,0):- not(xor(A,B,1)).

%Halbaddierer
halbaddierer(X,Y,C,S):- and(X,Y,C),xor(X,Y,S).

%Volladdierer
volladdierer(X,Y,Cin,Cout,S):- halbaddierer(X,Y,C1,S1),
                               halbaddierer(Cin,S1,C2,S),
                               or(C1,C2,Cout).

add([],[],0,[]).
add([],[],1,[1]).
add([H1|T1],[H2|T2],Car1,SUM):- volladdierer(H1,H2,Car1,Car2,Out),
                                add(T1,T2,Car2,Out2),
                                SUM=[Out|Out2].


%Addiert zwei Gleich lange binärzahlen.
addiere(X,Y,S):- length(X,N),length(Y,N),add(X,Y,0,S).
addiere(X,Y,S):- length(X,N1),length(Y,N2),
                 N1>N2,
                 Diff is N1-N2,
                 aufstocken(Y,Diff,Yneu),
                 addiere(X,Yneu,S).
addiere(X,Y,S):-length(X,N1),length(Y,N2),N2>N1,addiere(Y,X,S).

aufstocken(X,0,X).
aufstocken(X,N,E):- N>0,
                    N1 is N-1,
                    append(X,[0],X1),
                    aufstocken(X1,N1,E).


rusbaumult(X,[1],X).
rusbaumult(X,Y,E):- convert(Y,N),
                    N>1,
                    is_odd(Y),
                    minus_eins(Y,Yneu),
                    rusbaumult(X,Yneu,E1),
                    addiere(E1,X,E).

rusbaumult(X,Y,E):- convert(Y,N),
                    N>1,
                    not(is_odd(Y)),
                    double(X,Xneu),
                    double(Yneu,Y),
                    rusbaumult(Xneu,Yneu,E).
