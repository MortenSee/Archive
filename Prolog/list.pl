my_numlist(L,L,[L]).
my_numlist(L,H,List):- L<H,
                       L1 is L+1,
                       List=[L|X],
                       my_numlist(L1,H,X).


% Is true when Elem is the Index'th element of List.
% Counting starts at 1

my_nth1(1,[H|_],H).
my_nth1(Index,[_|T],Element):-Index>1,
                              I1 is Index-1,
                              my_nth1(I1,T,Element).

%
my_ord_union(List1,[],List1).

my_ord_union(List1, [H|T], [H|Out]):-my_ord_union(List1,T,Out).

