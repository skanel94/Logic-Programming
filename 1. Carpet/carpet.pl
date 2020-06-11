carpet(N) :-
	rewrite(_, First_Carpet), !,
	create_final_carpet(N, First_Carpet, Final_Carpet) ,
	print_carpet(Final_Carpet).


	
create_final_carpet(1, First_Carpet, First_Carpet) :- !.	% N=1 , The initial carpet is printed
create_final_carpet(2, First_Carpet, FinalCarpet) :- !,		% N=2 , one-time recursion
	create_carpet_recursively(First_Carpet, FinalCarpet).
	
create_final_carpet(N, First_Carpet, FinalCarpet) :-		% N>2 , consecutive recursions will calculate
	N1 is N - 1,											% the carpet for N=2 and by backpropagating
	create_final_carpet(N1, First_Carpet, FinalCarpet1),	% the final carpet will be created and printed
	create_carpet_recursively(FinalCarpet1, FinalCarpet).	
	
	
create_carpet_recursively([], []).							% Main predicate to create the final carpet which
create_carpet_recursively([H|T], FinalCarpet) :-			% taked the initial caperpet (2D-list), and each element of the head will be concatenated with the list which results from the rewrite in the final result. 
	append_carpet(H, FinalHead),							% of the head will be concatenated with the
	create_carpet_recursively(T, FinalTail),				% list which results from the rewrite in the
	append(FinalHead, FinalTail, FinalCarpet).     			% final result. The same will happen for the tail as well.
	
	
append_carpet([], []).										% Auxiliary predicate for manipulating the list 
append_carpet([H|T], Final_Carpet) :-						% which contains lists and I will appropriately set
	rewrite(H, L),											% it as a result list that will be returned.
	append_carpet(T, Final_Part_Carpet),			
	append_mini_carpet(L, Final_Part_Carpet, Final_Carpet).

	
append_mini_carpet([], _, []).								% Auxiliary predicate that takes as input a list with lists from the rewrite, and appends each sublist to the final list respectively
append_mini_carpet([H|T], [] , [H|T]) :- !.					% a list with lists from the rewrite,
append_mini_carpet([H|T], [H1|T1] , [Final_H|Final_T]) :-	% and appends each sublist to the final
	append(H, H1 , Final_H),								% list respectively
	append_mini_carpet(T, T1, Final_T).


print_carpet([]) :- !,nl.			% Predicate that prints a list of lists raw-wise
print_carpet([H|T]) :- !,			
	print_carpet(H),
	print_carpet(T).
	
print_carpet(X) :-
	write(X).
