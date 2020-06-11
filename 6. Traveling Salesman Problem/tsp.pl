:- set_flag(print_depth, 1000).
:- lib(ic).
:- lib(branch_and_bound).
:- lib(ic_global).

% =============================================================================================
tsp(1, [1], 0) :- !. 
tsp(N, R, C) :-
	costs(TempCostList),	% "Pairnw th lista me ta kosth"
	reverse(TempCostList, RevTempCostList),
	
	creat_costlist(N, RevTempCostList, CostList),	% "Kratw N-1 stoixeia"
	reverse(CostList, FinalCostList),
	flatten(FinalCostList, FlatFinalCostList),

	length(R, N),	% "Orizw lista me tis metavlhtes"
	R #:: 1..N,		% "kai ta pedia tous"
	
	ic_global:alldifferent(R),		% "Orizw tous periorismous"
	constraint(N, R, FlatFinalCostList, Costs),
	
	C #= sum(Costs),		% "Orizw sunarthsh kostous"
	
	bb_min(search(R,0,input_order,indomain,complete,[]),C, _).
	
% =============================================================================================
% ======================= "Stadio proepeksergasias listas kostous" ============================	
% =============================================================================================		
creat_costlist(1, _, []) :- !.
creat_costlist(N, [HR|RevTempCostList], [HR|CostList]) :-
	N1 is N - 1,
	creat_costlist(N1, RevTempCostList, CostList).

% =============================================================================================
% ============================= "Stadio orismou periorismwn" ==================================	
% =============================================================================================
constraint(N, [FirstCity|R], FlatFinalCostList, Costs) :-	
	FirstCity #= 1,	% " X.V.G : Thewrw oti o pwlhths tha ksekinaei panta apo thn 1h polh "
	sub_constraint(N, FirstCity, [FirstCity|R], FlatFinalCostList, Costs).

% ---------------------------------------------------------------------------------------------	
sub_constraint(_, FirstCity, [LastR], FlatFinalCostList, [LastTravelCost]) :- 
	% "Gnwrizoume ek tn proterwn oti h prwth polh exei thesh 1, kai tha'nai mikroterh"
	% "se thesh, apo oles tis alles theseis polewn. Epomenws h diafora teleutaias - prwths"
	% "polhs, mas dinei to kostos taksidiou, sthn prwth grammh tou pinaka"

	Diff #= LastR - FirstCity,
	
	Pos #= Diff,
	
	element(Pos, FlatFinalCostList, LastTravelCost), !.

sub_constraint(N, FirstCity, [R1,R2|R], FlatFinalCostList, [TravelCost|RestCosts]) :-
	
	% "Diakrinw poio einai to elaxisto kai poio to megisto stoixeio"
	Min #= min([R1,R2]),
	Max #= max([R1,R2]),
	
	% "Ypologizw to a8roisma twn stoixeiwn pou leipoun apo ton trigwniko pinaka"
	P #= Min*Min - Min,
	Sum #= P / 2,
	
	% "H diafora Max - Min orizei th sthlh pou vrisketai to zhtoumeno stoixeio"
	% "sto nohto 2d trigwniko pinaka"
	Diff #= Max - Min,
	
	% "H thesh tou zhtoumenou stoixeiou ston 1d pinaka me ta kosth"
	Pos #= (Min - 1) * N - Sum + Diff,
	
	element(Pos, FlatFinalCostList, TravelCost),

	sub_constraint(N, FirstCity, [R2|R], FlatFinalCostList, RestCosts).