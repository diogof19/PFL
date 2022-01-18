:-use_module(library(lists)).
:-use_module(library(between)).
:-use_module(library(random)).

/*
move(+GameState, +Move, -NewGameState)
*/


move(game_state(Size, TurnNo, Board, Player, Player1Type, Player2Type), Move, game_state(Size,NewTurnNo,NewBoard,NewPlayer, Player1Type, Player2Type)):-
    valid_positions(Board, Player, Move),
    center_board(Size, Center),
    execute_move(Board, Player, Move, NewBoard, Center),
    NewTurnNo is TurnNo + 1,
    NewPlayer is (Player mod 2) + 1.

execute_move(Board, Player, [Start, End], NewBoard, Center):-
    Player =:= 1,
    same_position(Start, Center),
    replace_piece(Board, Start, ' ', TempBoard),
    replace_piece(TempBoard, End, 'w', NewBoard).

execute_move(Board, Player, [Start, End], NewBoard, Center):-
    Player =:= 2,
    same_position(Start, Center),
    replace_piece(Board, Start, ' ', TempBoard),
    replace_piece(TempBoard, End, 'b', NewBoard).

execute_move(Board, Player, [Start, End], NewBoard, _):-
    Player =:= 1,
    replace_piece(Board, Start, ' ', TempBoard),
    replace_piece(TempBoard, End, 'W', NewBoard).

execute_move(Board, Player, [Start, End], NewBoard, _):-
    Player =:= 2,
    replace_piece(Board, Start, ' ', TempBoard),
    replace_piece(TempBoard, End, 'B', NewBoard).



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

moves(game_state(Size, TurnNo, Board, Player,  Player1Type, Player2Type), Moves):-
    Limit is Size-1,
    findall([[X0, Y0], [X, Y]], (between(0, Limit, X0),
    between(0, Limit, Y0),
    between(0, Limit, X),
    between(0, Limit, Y), move(game_state(Size, TurnNo, Board, Player,  Player1Type, Player2Type), [[X0, Y0], [X, Y]], _)), Moves).

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


same_position([H1, L1], [H1 , L1]).

game_over(game_state(_, _, Board, _,  _, _), Winner):-
    count_pieces(Board, 'w', C),
    C >= 1,
    Winner is 1.

game_over(game_state(_, _, Board, _,  _, _), Winner):-
    count_pieces(Board, 'b', C),
    C >= 1,
    Winner is 2.

game_over(game_state(_, _, Board, _,  _, _), Winner):-
    count_pieces(Board, 'W', C),
    C =:= 0,
    Winner is 2.

game_over(game_state(_, _, Board, _,  _, _), Winner):-
    count_pieces(Board, 'B', C),
    C =:= 0,
    Winner is 1.

game_over(_, _) :- fail.

choose_move(GameState, human, Move):-
    read_move_input(GameState, Move).

choose_move(GameState, computer-0, Move):-
    moves(GameState, Moves),
    random_member(Move, Moves).
