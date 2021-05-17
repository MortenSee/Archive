metric1d(X,Y,Dist):- Dist is (X-Y)**2.

metric([],[],0).
metric([H|T],[H2|T2],Dist):- metric1d(H,H2,D1),
                             metric(T,T2,D2),
                             Dist is D1+D2.

all_possibilities(TarVec,List):-  findall((Dist,Class),
                                   (data(DataVec,Class),
                                    metric(DataVec,TarVec,Dist)),
                                   List).

nearest(TarVec,Best_Match):-  all_possibilities(TarVec,List),
                         sort(1,@=<,List,[Best_Match|_]).

k_nearest(K,TarVec,List_of_Matches):- all_possibilities(TarVec,List),
                                    sort(1,@=<,List,Sorted),
                                    length(List_of_Matches,K),
                                    append(List_of_Matches,_,Sorted).


voted_setosa((_,iris-setosa)).
voted_veri((_,iris-versicolor)).
voted_virgin((_,iris-virginica)).


majority([K1,K2,K3],iris-setosa):-max_list([K1,K2,K3],K1),not((K1=K2;K1=K3)).
majority([K1,K2,K3],iris-versicolor):-max_list([K1,K2,K3],K2),not((K2=K1;K2=K3)).
majority([K1,K2,K3],iris-virginica):-max_list([K1,K2,K3],K3),not((K3=K1;K3=K2)).
majority([K1,K1,K2],X):- K1\=K2,random(1,100,R1),random(1,100,R2),
                         majority([R1,R2,0],X).
majority([K1,K2,K1],X):- K1\=K2,random(1,100,R1),random(1,100,R2),
                         majority([R1,0,R2],X).
majority([K2,K1,K1],X):- K1\=K2,random(1,100,R1),random(1,100,R2),
                         majority([0,R1,R2],X).
majority([K1,K1,K1],X):- random(1,100,R1),random(1,100,R2),random(1,100,R3),
                         majority([R1,R2,R3],X).



vote(List,[K1,K2,K3],Majority):- partition(voted_setosa,List,Votes1,Rest),
                        partition(voted_veri,Rest,Votes2,Votes3),
                        length(Votes1,K1),
                        length(Votes2,K2),
                        length(Votes3,K3),
                        majority([K1,K2,K3],Majority).



mean(List,Mean):- length(List,N),
                  sum_list(List,Sum),
                  Mean is Sum/N.

metric2([],_,0).
metric2([H|T],X,Dist):- metric1d(H,X,D1),
                        metric2(T,X,D2),
                        Dist is D1+D2.


dev(List,Dev):- length(List,N),
                mean(List,Mean),
                metric2(List,Mean,Sum),
                Dev is Sum/N.


z_trafo_calc([H|T],[NewX|NewTail],Mean,Dev):- NewX is (H - Mean)/Dev,
                                              z_trafo_calc(T,NewTail,Mean,Dev).



z_trafo(L,NewL):- mean(L,Mean),
                  dev(L,Dev),
                  z_trafo_calc(L,NewL,Mean,Dev).







%-----------------------------------------------------
%Database
%Merkmals Vektor
% sepal length, sepal width, petal length, petal width.
% Klassen :  Iris Setosa
%            Iris Versicolor
%            Iris Virginica
%
% data (Merkmalsvektor,Klasse)
% test(...) identisch, zum testen des klassifikators.
data([5.1,3.5,1.4,0.2],iris-setosa).
data([4.9,3.0,1.4,0.2],iris-setosa).
data([4.7,3.2,1.3,0.2],iris-setosa).
data([4.6,3.1,1.5,0.2],iris-setosa).
data([5.0,3.6,1.4,0.2],iris-setosa).
data([5.4,3.9,1.7,0.4],iris-setosa).
data([4.6,3.4,1.4,0.3],iris-setosa).
data([5.0,3.4,1.5,0.2],iris-setosa).
data([4.4,2.9,1.4,0.2],iris-setosa).
data([4.9,3.1,1.5,0.1],iris-setosa).
data([5.4,3.7,1.5,0.2],iris-setosa).
data([4.8,3.4,1.6,0.2],iris-setosa).
data([4.8,3.0,1.4,0.1],iris-setosa).
data([4.3,3.0,1.1,0.1],iris-setosa).
data([5.8,4.0,1.2,0.2],iris-setosa).
data([5.7,4.4,1.5,0.4],iris-setosa).
data([5.4,3.9,1.3,0.4],iris-setosa).
data([5.1,3.5,1.4,0.3],iris-setosa).
data([5.7,3.8,1.7,0.3],iris-setosa).
data([5.1,3.8,1.5,0.3],iris-setosa).
data([5.4,3.4,1.7,0.2],iris-setosa).
data([5.1,3.7,1.5,0.4],iris-setosa).
data([4.6,3.6,1.0,0.2],iris-setosa).
data([5.1,3.3,1.7,0.5],iris-setosa).
data([4.8,3.4,1.9,0.2],iris-setosa).
data([5.0,3.0,1.6,0.2],iris-setosa).
data([5.0,3.4,1.6,0.4],iris-setosa).
data([5.2,3.5,1.5,0.2],iris-setosa).
data([5.2,3.4,1.4,0.2],iris-setosa).
data([4.7,3.2,1.6,0.2],iris-setosa).
data([4.8,3.1,1.6,0.2],iris-setosa).
data([5.4,3.4,1.5,0.4],iris-setosa).
data([5.2,4.1,1.5,0.1],iris-setosa).
data([5.5,4.2,1.4,0.2],iris-setosa).
data([4.9,3.1,1.5,0.1],iris-setosa).
data([5.0,3.2,1.2,0.2],iris-setosa).
data([5.5,3.5,1.3,0.2],iris-setosa).
data([4.9,3.1,1.5,0.1],iris-setosa).
data([4.4,3.0,1.3,0.2],iris-setosa).
data([5.1,3.4,1.5,0.2],iris-setosa).
data([5.0,3.5,1.3,0.3],iris-setosa).
data([4.5,2.3,1.3,0.3],iris-setosa).
data([4.4,3.2,1.3,0.2],iris-setosa).
data([5.0,3.5,1.6,0.6],iris-setosa).
data([5.1,3.8,1.9,0.4],iris-setosa).
data([7.0,3.2,4.7,1.4],iris-versicolor).
data([6.4,3.2,4.5,1.5],iris-versicolor).
data([6.9,3.1,4.9,1.5],iris-versicolor).
data([5.5,2.3,4.0,1.3],iris-versicolor).
data([6.5,2.8,4.6,1.5],iris-versicolor).
data([5.7,2.8,4.5,1.3],iris-versicolor).
data([6.3,3.3,4.7,1.6],iris-versicolor).
data([4.9,2.4,3.3,1.0],iris-versicolor).
data([6.6,2.9,4.6,1.3],iris-versicolor).
data([5.2,2.7,3.9,1.4],iris-versicolor).
data([5.0,2.0,3.5,1.0],iris-versicolor).
data([5.9,3.0,4.2,1.5],iris-versicolor).
data([6.0,2.2,4.0,1.0],iris-versicolor).
data([6.1,2.9,4.7,1.4],iris-versicolor).
data([5.6,2.9,3.6,1.3],iris-versicolor).
data([6.7,3.1,4.4,1.4],iris-versicolor).
data([5.6,3.0,4.5,1.5],iris-versicolor).
data([5.8,2.7,4.1,1.0],iris-versicolor).
data([6.2,2.2,4.5,1.5],iris-versicolor).
data([5.6,2.5,3.9,1.1],iris-versicolor).
data([5.9,3.2,4.8,1.8],iris-versicolor).
data([6.1,2.8,4.0,1.3],iris-versicolor).
data([6.3,2.5,4.9,1.5],iris-versicolor).
data([6.1,2.8,4.7,1.2],iris-versicolor).
data([6.4,2.9,4.3,1.3],iris-versicolor).
data([6.6,3.0,4.4,1.4],iris-versicolor).
data([6.8,2.8,4.8,1.4],iris-versicolor).
data([6.7,3.0,5.0,1.7],iris-versicolor).
data([6.0,2.9,4.5,1.5],iris-versicolor).
data([5.7,2.6,3.5,1.0],iris-versicolor).
data([5.5,2.4,3.8,1.1],iris-versicolor).
data([5.5,2.4,3.7,1.0],iris-versicolor).
data([5.8,2.7,3.9,1.2],iris-versicolor).
data([6.0,2.7,5.1,1.6],iris-versicolor).
data([5.4,3.0,4.5,1.5],iris-versicolor).
data([6.0,3.4,4.5,1.6],iris-versicolor).
data([6.7,3.1,4.7,1.5],iris-versicolor).
data([6.3,2.3,4.4,1.3],iris-versicolor).
data([5.6,3.0,4.1,1.3],iris-versicolor).
data([5.5,2.5,4.0,1.3],iris-versicolor).
data([5.5,2.6,4.4,1.2],iris-versicolor).
data([6.1,3.0,4.6,1.4],iris-versicolor).
data([5.8,2.6,4.0,1.2],iris-versicolor).
data([5.0,2.3,3.3,1.0],iris-versicolor).
data([5.6,2.7,4.2,1.3],iris-versicolor).
data([6.3,3.3,6.0,2.5],iris-virginica).
data([5.8,2.7,5.1,1.9],iris-virginica).
data([7.1,3.0,5.9,2.1],iris-virginica).
data([6.3,2.9,5.6,1.8],iris-virginica).
data([6.5,3.0,5.8,2.2],iris-virginica).
data([7.6,3.0,6.6,2.1],iris-virginica).
data([4.9,2.5,4.5,1.7],iris-virginica).
data([7.3,2.9,6.3,1.8],iris-virginica).
data([6.7,2.5,5.8,1.8],iris-virginica).
data([7.2,3.6,6.1,2.5],iris-virginica).
data([6.5,3.2,5.1,2.0],iris-virginica).
data([6.4,2.7,5.3,1.9],iris-virginica).
data([6.8,3.0,5.5,2.1],iris-virginica).
data([5.7,2.5,5.0,2.0],iris-virginica).
data([5.8,2.8,5.1,2.4],iris-virginica).
data([6.4,3.2,5.3,2.3],iris-virginica).
data([6.5,3.0,5.5,1.8],iris-virginica).
data([7.7,3.8,6.7,2.2],iris-virginica).
data([7.7,2.6,6.9,2.3],iris-virginica).
data([6.0,2.2,5.0,1.5],iris-virginica).
data([6.9,3.2,5.7,2.3],iris-virginica).
data([5.6,2.8,4.9,2.0],iris-virginica).
data([7.7,2.8,6.7,2.0],iris-virginica).
data([6.3,2.7,4.9,1.8],iris-virginica).
data([6.7,3.3,5.7,2.1],iris-virginica).
data([7.2,3.2,6.0,1.8],iris-virginica).
data([6.2,2.8,4.8,1.8],iris-virginica).
data([6.1,3.0,4.9,1.8],iris-virginica).
data([6.4,2.8,5.6,2.1],iris-virginica).
data([7.2,3.0,5.8,1.6],iris-virginica).
data([7.4,2.8,6.1,1.9],iris-virginica).
data([7.9,3.8,6.4,2.0],iris-virginica).
data([6.4,2.8,5.6,2.2],iris-virginica).
data([6.3,2.8,5.1,1.5],iris-virginica).
data([6.1,2.6,5.6,1.4],iris-virginica).
data([7.7,3.0,6.1,2.3],iris-virginica).
data([6.3,3.4,5.6,2.4],iris-virginica).
data([6.4,3.1,5.5,1.8],iris-virginica).
data([6.0,3.0,4.8,1.8],iris-virginica).
data([6.9,3.1,5.4,2.1],iris-virginica).
data([6.7,3.1,5.6,2.4],iris-virginica).
data([6.9,3.1,5.1,2.3],iris-virginica).
data([5.8,2.7,5.1,1.9],iris-virginica).
data([6.8,3.2,5.9,2.3],iris-virginica).
data([6.7,3.3,5.7,2.5],iris-virginica).

%Test cases
%
test([4.8,3.0,1.4,0.3],iris-setosa).
test([5.1,3.8,1.6,0.2],iris-setosa).
test([4.6,3.2,1.4,0.2],iris-setosa).
test([5.3,3.7,1.5,0.2],iris-setosa).
test([5.0,3.3,1.4,0.2],iris-setosa).
test([5.7,3.0,4.2,1.2],iris-versicolor).
test([5.7,2.9,4.2,1.3],iris-versicolor).
test([6.2,2.9,4.3,1.3],iris-versicolor).
test([5.1,2.5,3.0,1.1],iris-versicolor).
test([5.7,2.8,4.1,1.3],iris-versicolor).
test([6.7,3.0,5.2,2.3],iris-virginica).
test([6.3,2.5,5.0,1.9],iris-virginica).
test([6.5,3.0,5.2,2.0],iris-virginica).
test([6.2,3.4,5.4,2.3],iris-virginica).
test([5.9,3.0,5.1,1.8],iris-virginica).
