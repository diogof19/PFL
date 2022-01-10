/*
Antes de mudar a forma do 'Move'
*/

:-use_module(library(lists)).

/*
move(+GameState, +Move, -NewGameState)
*/

/*moves(Size-TurnNo-Board-Player, Moves):-
    findall(Move, move(Size-TurnNo-Board-Player, Move, NewGameState), Moves).*/

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