:-use_module(library(lists)).

/*
create_board(+Size, -Board)
*/

create_board(Size, Board):-
    create_white_row(Size, WRow),
    append([], [WRow], SBoard),
    S is Size - 2,
    create_empty_rows(S, Size, ERows),
    append(SBoard, ERows, MBoard),
    create_black_row(Size, BRow),
    append(MBoard, [BRow], Board).

create_white_row(Size, Row):-
    create_row('W', Size, Row).

create_black_row(Size, Row):-
    create_row('B', Size, Row).

create_empty_rows(0, _, []).
create_empty_rows(Ammount, Size, [Row | T]):-
    Ammount > 0,
    A1 is Ammount - 1,
    create_empty_row(Size, Row),
    create_empty_rows(A1, Size, T).

create_empty_row(Size, Row):-
    create_row(' ', Size, Row).

create_row(_, 0, []).
create_row(P, Size, [P | T]):-
    Size > 0, 
    S1 is Size - 1,
    create_row(P, S1, T).

/*
count_pieces(+Board, +Player, -Count)

Board = [[], [], ...]
Player 1 = W
Player 2 = B
*/

count_pieces(Board, Piece, Count):-
    count_pieces_aux(Board, Piece, 0, Count).

count_pieces_aux([], _, Count, Count).
count_pieces_aux([Row | List], Piece, Acc, Count):-
    count_pieces_row(Row, Piece, RCount),
    NewAcc is Acc + RCount,
    count_pieces_aux(List, Piece, NewAcc, Count).

count_pieces_row(Row, Piece, Count) :-
    include(=(Piece), Row, Pieces),
    length(Pieces, Count).

center_board(Size, [Center1, Center2]):-
    Center1 is div(Size, 2),
    Center2 is div(Size, 2).
