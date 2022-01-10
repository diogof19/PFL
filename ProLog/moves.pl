:-use_module(library(lists)).

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

replace_piece(Board, [RowPos, ColPos], Piece, NewBoard):-
    nth0(RowPos, Board, Row),
    replace_element(Row, ColPos, Piece, NewRow),
    replace_element(Board, RowPos, NewRow, NewBoard).
    
replace_element(List, Index, Element, NewList):-
    nth0(Index, List, _, Temp),
    nth0(Index, NewList, Element, Temp).

valid_positions(Board, Player, [Start, End]):-
    Player =:= 1,
    valid_move(Start, End),
    check_piece(Board, 'W', Start),
    \+(check_piece(Board, 'W', End)).

valid_positions(Board, Player, [Start, End]):-
    Player =:= 2,
    valid_move(Start, End),
    check_piece(Board, 'B', Start),
    \+(check_piece(Board, 'B', End)).

check_piece(Board, Piece, [RowPos, ColPos]):-
    nth0(RowPos, Board, Row),
    nth0(ColPos, Row, Piece).

equal_1(V):- V =:= 1.
equal_1(V):- V =:= -1.
equal_2(V):- V =:= 2.
equal_2(V):- V =:= -2.

valid_move([S1, S2], [E1, E2]):-
    C2 is E2-S2,
    C1 is E1-S1,
    equal_2(C2),
    equal_1(C1).

valid_move([S1, S2], [E1, E2]):-
    C2 is E2-S2,
    C1 is E1-S1,
    equal_2(C1),
    equal_1(C2).