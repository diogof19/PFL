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
    include(=(Piece), Row, Pieces),
    length(Pieces, Count).


/*
initial_state(+Size, -GameState)
game_state(+TurnNo, +Board, +Player, +Size)

*/

/*initial_state(Size, Size-0-Board-1):-
    Size >= 5,
    Size mod 2 /= 0,
    create_board(Size, []).*/

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

/*
move(+GameState, +Move, -NewGameState)
*/

move(Size-TurnNo-Board-Player, Move, Size-NewTurnNo-NewBoard-NewPlayer):-
    valid_positions(Board, Player, Move),
    execute_move(Board, Player, Move, NewBoard),
    NewTurnNo is TurnNo + 1,
    NewPlayer is (Player mod 2) + 1.

execute_move(Board, Player, [Start, End], NewBoard):-
    Player =:= 1,
    replace_piece(Board, Start, ' ', TempBoard),
    replace_piece(TempBoard, End, 'W', NewBoard).

replace_piece(Board, Position, Piece, NewBoard):-
    change_code(Position, [Letter, Number]),
    nth0(Number, Board, Row),
    replace_element(Row, Letter, Piece, NewRow),
    replace_element(Board, Number, NewRow, NewBoard).
    

replace_element(List, Index, Element, NewList):-
    nth0(Index, List, _, Temp),
    nth0(Index, NewList, Element, Temp).

valid_positions(Board, Player, [Start, End]):-
    Player =:= 1,
    valid_Move(Start, End),
    check_piece(Board, 'W', Start),
    \+(check_piece(Board, 'W', End)).

valid_positions(Board, Player, [Start, End]):-
    Player =:= 2,
    valid_Move(Start, End),
    check_piece(Board, 'B', Start),
    \+(check_piece(Board, 'B', End)).

check_piece(Board, Piece, Start):-
    change_code(Start, [Letter, Number]),
    nth0(Number, Board, Row),
    nth0(Letter, Row, Piece).

change_code([C1, C2], [I1, I2]):-
    char_code('a', A),
    char_code('1', Z),
    I1 is C1 - A,
    I2 is C2 - Z.

change_code([C1, C2, C3], [I1, I2]):-
    char_code('a', A),
    char_code('0', Z),
    I1 is C1 - A,
    I2 is (C2-Z)*10 + (C3-Z) - 1.


equal_1(V):- V =:= 1.
equal_1(V):- V =:= -1.
equal_2(V):- V =:= 2.
equal_2(V):- V =:= -2.

valid_Move(Start, End):-
    change_code(Start, [S1, S2]),
    change_code(End, [E1, E2]),
    C2 is E2-S2,
    C1 is E1-S1,
    equal_2(C2),
    equal_1(C1).

valid_Move(Start, End):-
    change_code(Start, [S1, S2]),
    change_code(End, [E1, E2]),
    C2 is E2-S2,
    C1 is E1-S1,
    equal_2(C1),
    equal_1(C2).

