:- set_flag(print_depth, 1000).
:- lib(ic).
:- lib(branch_and_bound).

% =================================================================================
grpart(N, D, P1, P2, Cost) :-
	create_graph(N, D, Graph),  		% Creation of random Graph
	def_vars(N, SubGraph),
	
	length(Graph, N1),
	def_vars(N1, ArcList),				% A list is created and it is assigned with 1 if
										% the corresponding edge intersect, otherwise 0
	
	sum(SubGraph) #= N div 2,			% Constraint for the size of the sub-graph
	constraints(N, Graph, SubGraph, ArcList),

	Cost #= sum(ArcList),
	bb_min(search(SubGraph,0,input_order,indomain,complete,[]),Cost, _),

	visualize_the_results(SubGraph, 1, P1, P2).
	
% =================================================================================
% Variable and field definition
def_vars(N, SubGraph) :-
	length(SubGraph, N),
	SubGraph #:: 0..1.
	
% =================================================================================	
% Function that defines the constraints of the problem
constraints(_, [], _, []) :- ! .
constraints(N, [N1 - N2|Graph], SubGraph, [H|ArcList]) :-
	
	n_th(N1, SubGraph, Node1),
	n_th(N2, SubGraph, Node2),

	H #= (Node1 #\=  Node2),

	constraints(N, Graph, SubGraph, ArcList).

% ---------------------------------------------------------------------------------
% Function that finds the n-th element of a list
n_th(1, [Node| _], Node).
n_th(N, [_| Nodes], Node) :-
	N \= 1,
	N1 is N - 1,
	n_th(N1, Nodes, Node).

% ---------------------------------------------------------------------------------
% Function tha visualises the results
visualize_the_results([], _, [], []):- !.
visualize_the_results([Head|SubGrTail], N, [N|TP1], TP2) :-
	Head = 0,
	N1 is N + 1,
	visualize_the_results(SubGrTail, N1, TP1, TP2),!.
	
visualize_the_results([_|SubGrTail], N, TP1, [N|TP2]) :-
	N1 is N + 1,
	visualize_the_results(SubGrTail, N1, TP1, TP2).