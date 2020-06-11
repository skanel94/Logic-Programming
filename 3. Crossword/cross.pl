
crossword(Final_Solution) :-
	dimension(N),
	initialize_grid(N , N, Grid),
	insert_black_boxesX(N, 1, 1, Grid),
	create_list_with_all_cont_cells(Grid, [], Raws_Cont_Cells),
	transpose(Grid,Trnspsd_Grid),
	create_list_with_all_cont_cells(Trnspsd_Grid, [], Cols_Cont_Cells),
	append(Raws_Cont_Cells, Cols_Cont_Cells, Cont_Cells),
	words(Word_List),
	fill_in_crossword(Grid, Word_List, Cont_Cells),
	convert_from_ASCII_to_CHARS(Grid, Final_Grid),
	final_solution_list(Final_Grid, Final_Solution),
	enchance_list(Final_Grid, Enchanced_Filled_Grid),
	print_my_list(Enchanced_Filled_Grid).

% ========================================================================
% Creation of a NxN grid

initialize_grid(_, 0, []):- !.
initialize_grid(N , N1, [Head|Tail]) :-
	N2 is N1 - 1,
	length(Head, N),
	initialize_grid(N, N2, Tail).
	
% ========================================================================	
% The black cells are put down
% X is modified

insert_black_boxesX(N, X, _, _) :- X is N + 1, !.
insert_black_boxesX(N, X, 1, Grid) :- 
	insert_black_boxesY(N, X, 1, Grid), !,
	X1 is X + 1,
	insert_black_boxesX(N, X1, 1, Grid).
insert_black_boxesX(N, X, 1, Grid) :-
	X1 is X + 1,
	insert_black_boxesX(N, X1, 1, Grid).

% Y is modified
insert_black_boxesY(N, _, Y, _) :- Y is N + 1, !.
insert_black_boxesY(N, X, Y, Grid) :-
	black(X, Y),			% An ta paragomena (X,Y) apoteloun gegonota..
	find_and_insert_the_black_box(X, Y, Grid), !,
	Y1 is Y + 1,
	insert_black_boxesY(N, X, Y1, Grid).
insert_black_boxesY(N, X, Y, Grid) :-
	Y1 is Y + 1,
	insert_black_boxesY(N, X, Y1, Grid).	
	
% Auxiliary function that puts a cell down on (X,Y) position
find_and_insert_the_black_box(1, Y, [H|_]) :-
	insert_the_black_box(Y, H).
find_and_insert_the_black_box(X, Y, [_|Old_Grid]) :-
	X1 is X - 1,
	find_and_insert_the_black_box(X1, Y, Old_Grid).
	
insert_the_black_box(1, [H|_]) :- !,
	H = '#'.
insert_the_black_box(Y, [_|Old_Grid]) :-
	Y1 is Y - 1,
	insert_the_black_box(Y1, Old_Grid).
% ========================================================================
% Auxiliary function that creates a list of lists that correspond to the consecutive positions of a raw 

create_list_with_all_cont_cells([], Final_Cont_List, Final_Cont_List).
create_list_with_all_cont_cells([H|T], Temp_Cont_List, Final_Cont_List) :-
	find_continuous_cells(H, [], [], Head_Cont),
	append(Temp_Cont_List, Head_Cont, Cont_List),
	create_list_with_all_cont_cells(T, Cont_List, Final_Cont_List).
	
% ========================================================================
% Auxiliary function that takes an empty grid which contains only '#' and will be filled with words from the Word_list

fill_in_crossword(_, [], _).
fill_in_crossword(Filled_Grid, [Word|Word_List], Cont_Cells) :-
	fill_in_with_words(Filled_Grid, [Word|Word_List], Cont_Cells),   
	fill_in_crossword(Filled_Grid, Word_List, Cont_Cells).		     

% fill_in_crossword(Filled_Grid, [Word|Word_List], Cont_Cells) :-	   
%	transpose(Filled_Grid,Trnspsd_Grid),
%	fill_in_with_words(Trnspsd_Grid, [Word|Word_List]),
%	transpose(Trnspsd_Grid,Filled_Grid),
%	fill_in_crossword(Filled_Grid, Word_List).

% -------------------------------------------------------------------
% Auxiliary function that searches for space to each row to put the word

% fill_in_with_words([], _).

fill_in_with_words([H|_], [Word|_], Cont_Cells) :-
	try_fit_word_in_cross(Cont_Cells, Word).

fill_in_with_words([_|Initial_Grid], [Word|Word_List]) :-
	fill_in_with_words(Initial_Grid, [Word|Word_List]).


% Function that takes a list that contains the consecutive cells of the crossword per row,
% and tries to put the words down

% try_fit_word_in_cross([], _).

try_fit_word_in_cross([H|_], Word) :-
	length(H, N),
	N > 1,
	name(Word, Ascii_Word),
	length(Ascii_Word, N1),
	N = N1,
	H = Ascii_Word.
	
try_fit_word_in_cross([_|Continuous_Cells], Word) :-
	try_fit_word_in_cross(Continuous_Cells, Word).

% ========================================================================
% Auxiliary function for convertion Ascii -> List with characters

convert_from_ASCII_to_CHARS([],[]) :- !.			
convert_from_ASCII_to_CHARS([H|T], [Ascii_H|Ascii_T]) :- !,
	convert_from_ASCII_to_CHARS(H, Ascii_H),
	convert_from_ASCII_to_CHARS(T, Ascii_T).
	
convert_from_ASCII_to_CHARS(Ascii_X, Char_X) :-
	Ascii_X \= '#',
	name(Char_X, [Ascii_X]).

convert_from_ASCII_to_CHARS(Ascii_X, Ascii_X).
	
% ========================================================================
% Main function that returns the final solved crossword that has been asked

final_solution_list(Grid, Final_Solution) :-
	solution_list(Grid, [], Raw_Solution),
	transpose(Grid,Grid1),
	solution_list(Grid1, [], Column_Solution), 
	append(Raw_Solution, Column_Solution, Final_Solution).

% -------------------------------------------------------------------
% Auxiliary function that given as input a list such as this:
% "L = [[a,s,#,p,o],[d,o,#,i,k],[a,#,o,r,e],[m,a,#,u,r],[#,l,i,s,#]]"
% it returns ": [as, po, do, ik, ore, ma, ur, lis]"
% namely the words that are located at each row

solution_list([], Solution, Solution) :- !.
solution_list([H|Grid], Temp, Solution) :- !, 
	find_continuous_cells(H, [], [], Words_as_Lists),
	flat_the_words(Words_as_Lists, Words),
	append(Temp, Words, Temp_Solution),
	solution_list(Grid, Temp_Solution, Solution).

% -------------------------------------------------------------------
% Takes lists of : "[#, #, a, f, e, #, k, #, #, o, l, o, #]" and returns
% lists of lists such as "[[a, f, e], [k], [o, l, o]]"

find_continuous_cells([], Temp_Word, Temp_Words, Final_Words) :- 
	Temp_Word \= [],
	append(Temp_Words, [Temp_Word], Final_Words).
find_continuous_cells([], [], Final_Words, Final_Words). 
	
	
find_continuous_cells([H|T], Temp, Temp_Words, Final_Words) :-
	H \== '#',
	append(Temp, [H], Temp_Word),
	find_continuous_cells(T, Temp_Word, Temp_Words, Final_Words).

find_continuous_cells([H|T], Temp_Word, Temp_Words, Final_Words) :-
	H == '#', Temp_Word \= [],
	append(Temp_Words, [Temp_Word], Words),
	find_continuous_cells(T, [], Words, Final_Words), !.

find_continuous_cells([H|T], Temp_Word, Temp_Words, Final_Words) :-
	H == '#', Temp_Word = [],
	find_continuous_cells(T, [], Temp_Words, Final_Words).	

% -------------------------------------------------------------------
% Takes lists of this form: "[[a, f, e], [k], [o, l, o]]"
% and returns words such as: "[afe, olo]" ignoring words with
% just one letter

flat_the_words([], []) :- !.
flat_the_words([H|T], [X|RestWordList]) :-
	length(H, N),	
	N > 1,
	list_to_word(H, Word), !,
	flatten(Word, FWord),
	name(X,FWord), 
	flat_the_words(T, RestWordList).
flat_the_words([_|T], RestWordList) :-
	flat_the_words(T, RestWordList).

% Coveration of lists into words e.g. "( [a, d, a, m] -> adam )"
list_to_word([], []).
list_to_word([H|T], [X|RestWordList]) :-
	name(H, X),
	list_to_word(T, RestWordList).

% ========================================================================

enchance_list([], []) :- !.
enchance_list([H|T], [Ench_H|Ench_T]) :- !,
	enchance_list(H, Ench_H),
	enchance_list(T, Ench_T).

enchance_list(X, Ench_X) :-
	X \= '#', !,
	name(' ', Space),
	name(X, Ascii_X),
	flatten([Space, Ascii_X, Space], Ench_X_Ascii),
	name(Ench_X, Ench_X_Ascii).

enchance_list(X, Ench_X) :-
	name('#', Hashtag),
	name(X, Ascii_X),
	flatten([Hashtag, Ascii_X, Hashtag], Ench_X_Ascii),
	name(Ench_X, Ench_X_Ascii).

% -------------------------------------------------------------------
% Auxiliary function for printing the lists

print_my_list([]) :- !,nl.			
print_my_list([H|T]) :- !,
	print_my_list(H),
	print_my_list(T).
	
print_my_list(X) :-
	write(X).

% -------------------------------------------------------------------
transpose([], []).
transpose([F|Fs], Ts) :-
    transpose(F, [F|Fs], Ts).

transpose([], _, []).
transpose([_|Rs], Ms, [Ts|Tss]) :-
        lists_firsts_rests(Ms, Ts, Ms1),
        transpose(Rs, Ms1, Tss).

lists_firsts_rests([], [], []).
lists_firsts_rests([[F|Os]|Rest], [F|Fs], [Os|Oss]) :-
        lists_firsts_rests(Rest, Fs, Oss).
		
% -------------------------------------------------------------------