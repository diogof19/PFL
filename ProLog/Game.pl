:-use_module(library(lists)).

/*
count_pieces(+Board, +Player, -Count)

Board = [[], [], ...]
Player 1 = k, Player 2 = K
*/

count_pieces(Board, Player, Count):-
    Player =:= 1,
    count_pieces_aux(Board, 'k', 0, Count).

count_pieces(Board, Player, Count):-
    Player =:= 2,
    count_pieces_aux(Board, 'K', 0, Count).

count_pieces_aux([], _, Count, Count).
count_pieces_aux([Row | List], Piece, Acc, Count):-
    count_pieces_row(Row, Piece, RCount),
    NewAcc is Acc + RCount,
    count_pieces_aux(List, Piece, NewAcc, Count).

count_pieces_row(Row, Piece, Count) :-
    include(=(Piece), Row, Pieces), length(Pieces, Count).

/*
initial_state(+Size, -GameState)
game_state(+TurnNo, +Board, +Player, +Size)

*/

/*initial_state(+Size, -GameState):-
    Size >= 5,
    Size mod 2 /= 0.*/

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