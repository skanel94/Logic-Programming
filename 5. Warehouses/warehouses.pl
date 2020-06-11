:- set_flag(print_depth, 1000).
:- lib(ic).
:- lib(branch_and_bound).

% ====================================================================================
warehouses(N1, M1, YesNoLocs, CustServs, Cost) :-
	fixedcosts(FixedCostsList),
	retrieve_fixedcosts(FixedCostsList, N1, PartFixedCostsList),

	varcosts(VarCostsList),
	retrieve_varcosts(VarCostsList, M1, N1, PartVarCostsList),
	
	((N1 =:= 0) -> (N11 = 20) ; N11 = N1),	% "Gia thn periptwsh pou N1 = 0"
	length(YesNoLocs, N11),					% "Lista me 0-1 gia to an ekei uparxei apothhkh"
	YesNoLocs #:: 0..1,

	length(CostListGar, N11),				% "Lista kostous gia tis apothhkes"
	constraint1(YesNoLocs, PartFixedCostsList, CostListGar),
	
	((M1 =:= 0) -> (M11 = 40) ; M11 = M1),  % "Gia thn periptwsh pou M1 = 0"
	length(CostListCust, M11),				% "Lista kostous eksuphrethshs pelatwn"
	constraint2(YesNoLocs, PartVarCostsList, CostListCust),
	
	% "MinCostListCust: lista me elaxista (uparkta, \=0) kosth eksuphrethshs pelatwn"
	constraint3(YesNoLocs, CostListCust, MinCostListCust),
	
	Cost1 #= sum(CostListGar),		% "Kostos apothhkwn pou tha xtistoun"
	Cost1 #> 0,
	Cost2 #= sum(MinCostListCust),	% "Kostos eksuphrethshs twn pelatwn"	
	Cost #= Cost1 + Cost2,

	bb_min(search(YesNoLocs,0,input_order,indomain,complete,[]),Cost, _),
	
	length(CustServs, M11),
	CustServs #:: 1..N11,			% "Lista pelatwn pou deixnei to apo pou eksuphreththhkan"	
	constraint4(CostListCust, CustServs),

	search(CustServs,0,input_order,indomain,complete,[]).
	
% =============================================================================================
% ============================ "Stadio dhmiourgias periorismwn" ===============================	
% =============================================================================================
% "Stis theseis ths YesNoLocs opou oi apothhkes exoun timh =1, stis antistoixes theseis ths"
% "CostListGar tha mpainei to kostos kataskeuhs ts apothhkhs, alliws tha exei timh 0"
constraint1([], [], []) :- !.
constraint1([Node|YesNoLocs], [HP|PartFixedCostsList], [HC|CostListGar]) :-
	HC #:: [0, HP],
	HC #= HP * Node,
	constraint1(YesNoLocs, PartFixedCostsList, CostListGar).
	
% =============================================================================================
% "Omoia me ton periorismo 1, edw tha ftiaksoume mia lista pelatwn pou mesa h kathe lista tha"
% "exei kostoi eksuphrethshs apo apothhkes pou 'uparxoun' , dld: Node = 1 apo thn YesNoLocs"
constraint2(_, [], []) :- !.
constraint2(YesNoLocs, [HP|PartVarCostsList], [HC|CostListCust]) :-		
	calculate_cust_cost(YesNoLocs, HP, HC),
	constraint2(YesNoLocs, PartVarCostsList, CostListCust).
% ---------------------------------------------------------------------------------------------	
calculate_cust_cost([], [], []) :- !.
calculate_cust_cost([Node|YesNoLocs], [HPHead|HPTail], [HCHead|HcTail]) :-		
	% "An uparxei sauth th thesh apothhkh (Node=1) tote h metavlhth 8a parei to kostos"
	% "eksuphrethshs autou tou pelath giauthn thn apothhkh"
%	HCHead #:: [0.. HPHead],
	HCHead #= HPHead * Node,
	calculate_cust_cost(YesNoLocs, HPTail, HcTail).	

% =============================================================================================	
% " Sunarthsh pou tha mou ferei to elaxisto kostos eksuphrethshs (>0) gia kathe pelath "
constraint3(_, [], []) :- !.
constraint3(YesNoLocs, [HC|CostListCust], [HS|SumCostListCust]) :-	
	% "Ypologizw to max kostos eksuphrethshs gi'auto ton pelath"
	MaxHc = max(HC),
	calculate_cust_cost1(YesNoLocs, HC, MaxHc, HS1),

	HS #= min(HS1),
	constraint3(YesNoLocs, CostListCust, SumCostListCust).
% ---------------------------------------------------------------------------------------------
calculate_cust_cost1([], [], _, []) :- !.
calculate_cust_cost1([Node|YesNoLocs], [HCHead|HCTail], MaxHc, [HSHead|HSTail]) :-
	% "To HSHead eite tha parei th max timh ths listas an node=0 eite thn pragmatikh timh"
	% "eksuphrethshs tou pelath giauth th thesh an node=1 ( dld uparxei apothhkh sauth th thesh"
	HSHead #= MaxHc*(Node #= 0) + HCHead,

 	calculate_cust_cost1(YesNoLocs, HCTail, MaxHc, HSTail).

% =============================================================================================
% ======================= "Stadio proepeksergasias dosmenwn listwn" ===========================	
% =============================================================================================	
% "Sunarthsh pou epistrefei apo to 'fixedcosts', mia lista me upops. theseis megethous N1"
retrieve_fixedcosts(FixedCostsList, 0, FixedCostsList) :- !.
retrieve_fixedcosts(FixedCostsList, 20, FixedCostsList) :- !.

retrieve_fixedcosts([H|_], 1, [H]) :- !.

retrieve_fixedcosts([H|RestFixedCostsList], N1, [H|PartFixedCostsList]) :-
	N1 < 20,
	NewN1 is N1 - 1,
	retrieve_fixedcosts(RestFixedCostsList, NewN1, PartFixedCostsList).
		
% =============================================================================================	
% "Sunarthsh pou epistrefei apo to 'varcosts', mia lista-listwn, megethous M1, me pelates"
retrieve_varcosts(VarCostsList, 0, N1, NewVarCostsList) :-
	retrieve_fixedcosts2(VarCostsList, N1, NewVarCostsList), !.	
retrieve_varcosts(VarCostsList, 40, N1, NewVarCostsList) :-
	retrieve_fixedcosts2(VarCostsList, N1, NewVarCostsList), !.
	
retrieve_varcosts([H|_], 1, N1, [H1]) :-
	retrieve_fixedcosts(H, N1, H1), !.

retrieve_varcosts([H|RestVarCostsList], M1, N1, [H1|PartVarCostsList]) :-
	M1 < 40,
	NewM1 is M1 - 1,
	retrieve_fixedcosts(H, N1, H1),	% "filtrarw ton kathe pelath na exei N1 epiloges apothhkwn"
	retrieve_varcosts(RestVarCostsList, NewM1, N1, PartVarCostsList).

% ---------------------------------------------------------------------------------------------	
% "Vothhtikh sunarthsh pou xreiazetai gia thn periptwsh pou dwsoume M1 = 0 wste gia ton kathe "
% "pelath na epistrefei akrivws N1 theseis upopshfiwn apothhkwn"
retrieve_fixedcosts2(VarCostsList, 0, VarCostsList) :- !.
retrieve_fixedcosts2(VarCostsList, 20, VarCostsList) :- !.

retrieve_fixedcosts2([], _, []) :- !.
retrieve_fixedcosts2([H|RestVarCostsList], 1, [H1|PartVarCostsList]) :-
	retrieve_fixedcosts(H, 1, H1),
	retrieve_fixedcosts2(RestVarCostsList, 1, PartVarCostsList), !.

retrieve_fixedcosts2([H|RestVarCostsList], N1, [H1|PartVarCostsList]) :-
	N1 < 20,
	retrieve_fixedcosts(H, N1, H1),
	retrieve_fixedcosts2(RestVarCostsList, N1, PartVarCostsList).

% =============================================================================================
% ========================== "Stadio optikopoihshs apotelesmatwn" =============================	
% =============================================================================================
% "Gia na optikopoihsw ta apotelesmata mou, afou exw pleon san dedomeno gia kathe pelath tis"
% "uparktes apothhkes gia eksuphrethsh, tha dialeksw thn pio mikrh (kai mh mhdenikh) timh apo"
% "th lista mou ws apanthsh gia thn eksuphrethsh tou"
constraint4([], []) :- !.
constraint4([HCo|CostListCust], [HCu|CustServs]) :-
	Max #= max(HCo),		% "Psaxnw thn pio megalh timh sth listam me ta kosth eksuphrethshs"

	sub_constraint4(HCo, Max, NewHco),
	
	Min #= min(NewHco),		% "Dialegw apo th nea lista mou to pio mikro kostos eksuphrethshs"
							% "mias kai pleon kserw pws den uparxoun mhdenika"
	element(Nth, HCo, Min),
	HCu #= Nth,

	constraint4(CostListCust, CustServs).

sub_constraint4([], _, []) :- !.
sub_constraint4([H|HCo], Max, [NH|NewHCo]) :-
	((H =:= 0) -> (NH = Max) ; NH = H),	% "opou uparxei mhdeniko kostos eksuphrethshs, thetw"
	sub_constraint4(HCo, Max, NewHCo).  % "san kostos eksuphrethshs to max kostos eksuphreths"
										% "giauto to pelath, apo auth thn apothhkh"
% =============================================================================================