leibnitz(1,1).
leibnitz(N,PI) :- N>1,
                  N1 is N-1,
                  leibnitz(N1,P1),
                  PI is P1 + ((-1)^(N+1))/(2*N -1).

pi(N,PI) :- leibnitz(N,X),PI is 4*X.

leibnitz_er(N,PI) :- leibnitz_end(N,1,PI).
leibnitz_end(1,X,X).
leibnitz_end(N,AKK,PI) :- N>1,
                          N1 is N-1,
                          AKK1 is AKK + ((-1)^(N+1))/(2*N -1),
                          leibnitz_end(N1,AKK1,PI).

pi_er(N,PI) :- leibnitz_er(N,X),PI is 4*X.


wallisch(1,4/3).
wallisch(N,PI):- N>1,
                  N1 is N-1,
                  wallisch(N1,P1),
                  X is (2*N)/(2*N - 1),
                  Y is (2*N)/(2*N +1),
                  PI is P1*X*Y.

wall_end(1,X,X).

wall_end(N,AKK,PI):- N>1,
                     N1 is N-1,
                     X is (2*N)/(2*N - 1),
                     Y is (2*N)/(2*N +1),
                     AKK1 is AKK*X*Y,
                     wall_end(N1,AKK1,PI).

pi_wall_er(N,PI):- wall_end(N,4/3,X),PI is X*2.


pi_wall(N,PI) :- wallisch(N,X),PI is 2*X.


leib_pi_incr_viertel(1,1).
leib_pi_incr_viertel(N,PI):- leib_pi_incr_viertel(N1,P1),
                     N is N1+1,
                     PI is (P1 + ((-1)^(N+1))/(2*N -1)).

leib_pi_incr(N,PI):- leib_pi_incr_viertel(N,X),PI is 4*X.

wall_pi_incr_halbe(1,4/3).
wall_pi_incr_halbe(N,PI):- wall_pi_incr_halbe(N1,P1),
                           N is N1+1,
                           X is (2*N)/(2*N - 1),
                           Y is (2*N)/(2*N +1),
                           PI is P1*X*Y.

wall_pi_incr(N,PI):- wall_pi_incr_halbe(N,X),PI is 2*X.
