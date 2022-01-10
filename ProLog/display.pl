:-use_module(library(lists)).

/*
display(+Board, +Size)

Example = [['K', 'k', ' ', 'k', 'k', 'K', 'k', ' ', 'K'], ['K', 'k', ' ', 'k', 'k', 'K', 'k', ' ', 'K'], ['K', 'k', ' ', 'k', 'k', 'K', 'k', ' ', 'K'], ['K', 'k', ' ', 'k', 'k', 'K', 'k', ' ', 'K'], ['K', 'k', ' ', 'k', 'k', 'K', 'k', ' ', 'K'], ['K', 'k', ' ', 'k', 'k', 'K', 'k', ' ', 'K'], ['K', 'k', ' ', 'k', 'k', 'K', 'k', ' ', 'K'], ['K', 'k', ' ', 'k', 'k', 'K', 'k', ' ', 'K'], ['K', 'k', ' ', 'k', 'k', 'K', 'k', ' ', 'K']]
Example = display([['W', 'B', ' '], ['B', 'W', ' '], ['B', 'B', ' ']], 3).

*/

display([], Size):-
    display_between(0, Size).
display([H|T], Size):-
    display_between(0, Size),
    row_display(H),
    display(T, Size).

display_between(Size, Size):-
    write('#'),
    nl.
display_between(Acc, Size):-
    write('#---'),
    NewAcc is Acc + 1,
    display_between(NewAcc, Size).

row_display([]):-
    write('|'),
    nl.
row_display([H|T]):-
    write('| '),
    write(H),
    write(' '),
    row_display(T).