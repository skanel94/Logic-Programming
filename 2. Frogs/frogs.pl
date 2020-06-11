frogs(N, M, Solution) :-
	depth_first_search(N, M, Solution).

% ==================================================================================================== %
% Implementation of DFS search algorithm as given in lecture slides

depth_first_search(N, M, Solution) :-
	initial_state(N, M, Initial_FrogList),
	depth_first_search(N, M, Initial_FrogList, [], Solution).


depth_first_search(N, M, FrogList, FinalMoves, FinalMoves) :-
	final_state(N, M, FrogList).

depth_first_search(N, M, FrogList1, SoFarMoves, FinalMoves) :-
	move(FrogList1, FrogList2, Move),
	append(SoFarMoves, [Move], NewSoFarMoves),
	depth_first_search(N, M, FrogList2, NewSoFarMoves, FinalMoves).
	
% ==================================================================================================== %
% Creation of 'initial state' according to N, M parameters given as input 
% e.g.: For N=4, M=3 a list will produced that looks like -> FrogList = ['G', 'G', 'G', 'G', '_', 'B', 'B', 'B']
	
initial_state(N, M, FrogList) :-
	create_G_froglist(N, [], G_FrogList),					% Creation of a list with 'G'reen frogs
	create_B_froglist(M, [], B_Froglist),					% Creation of a list with 'B'rown frogs
	append(G_FrogList, ['_' | B_Froglist], FrogList).

create_G_froglist(0, G_FrogList, G_FrogList) :- !.
create_G_froglist(N, TempList, G_FrogList) :- 
	append(TempList, ['G'], TempList1),
	N1 is N - 1,
	create_G_froglist(N1, TempList1, G_FrogList).
	
create_B_froglist(0, G_FrogList, G_FrogList) :- !.
create_B_froglist(M, TempList, G_FrogList) :- 
	append(TempList, ['B'], TempList1),
	M1 is M - 1,
	create_B_froglist(M1, TempList1, G_FrogList).

% ---------------------------------------------------------------------------------------------------- %
$ Creation of 'final state' and comparison with a current given state
% e.g.: For N=4, M=3 a list will produced that looks like -> R_FrogList = ['B', 'B', 'B', '_', 'G', 'G', 'G', 'G']

final_state(N, M, R_FrogList) :-
	initial_state(N, M, FrogList),
	reverse(FrogList, R_FrogList).
	
% ---------------------------------------------------------------------------------------------------- %
% Definition of acceptable moves and creation of new lists that transition to new states, while
% the newly produced states are returned 
% e.g.: For N=4, M=3, from State1 = ['G', 'G', 'G', 'G', '_', 'B', 'B', 'B'] one possible transition is:
%                          State2 = ['G', 'G', 'G', '_', 'G', 'B', 'B', 'B'] with Move = g1  etc.

move([X1,X2], [Y1,Y2], Move) :-
	(X1 = 'G', X2 = '_' ,Move = g1, Y1 = '_' , Y2 = 'G') ;
	(X1 = '_', X2 = 'B' ,Move = b1, Y1 = 'B' , Y2 = '_') .
	
move([X1,X2,X3|RestFrogList1], [Y1,Y2,Y3|RestFrogList2], Move) :-
	(X1 = 'G', X2 = '_', Move = g1,  Y1 = '_' , Y2 = 'G', X3 = Y3, RestFrogList1 = RestFrogList2) ;
	(X1 = 'G', X2 = 'B', X3 = '_', Move = g2,  Y1 = '_' , Y2 = 'B', Y3 = 'G', RestFrogList1 = RestFrogList2) ;
	(X1 = '_', X2 = 'B', Move = b1,  Y1 = 'B' , Y2 = '_', X3 = Y3, RestFrogList1 = RestFrogList2) ;
	(X1 = '_', X2 = 'G', X3 = 'B', Move = b2,  Y1 = 'B' , Y2 = 'G', Y3 = '_', RestFrogList1 = RestFrogList2) ;

	( X1 = Y1, move( [X2,X3|RestFrogList1], [Y2,Y3|RestFrogList2], Move)).