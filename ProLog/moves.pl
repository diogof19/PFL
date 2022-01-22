:-use_module(library(lists)).
:-use_module(library(between)).
:-use_module(library(random)).

/*
move(+GameState, +Move, -NewGameState)
*/


move(game_state(Size, TurnNo, Board, Player, Player1Type, Player2Type), Move, game_state(Size, NewTurnNo, NewBoard, Player, Player1Type, Player2Type)):-
    valid_positions(Board, Player, Move),
    center_board(Size, Center),
    execute_move(Board, Player, Move, NewBoard, Center),
    NewTurnNo is TurnNo + 1.

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
    player_to_piece(Player, Piece),
    replace_piece(Board, Start, ' ', TempBoard),
    replace_piece(TempBoard, End, Piece, NewBoard).

replace_piece(Board, [RowPos, ColPos], Piece, NewBoard):-
    nth0(RowPos, Board, Row),
    replace_element(Row, ColPos, Piece, NewRow),
    replace_element(Board, RowPos, NewRow, NewBoard).
    
replace_element(List, Index, Element, NewList):-
    nth0(Index, List, _, Temp),
    nth0(Index, NewList, Element, Temp).

valid_positions(Board, Player, [Start, End]):-
    player_to_piece(Player, Piece),
    valid_move(Start, End),
    check_piece(Board, Piece, Start),
    \+(check_piece(Board, Piece, End)).

check_piece(Board, Piece, [RowPos, ColPos]):-
    nth0(RowPos, Board, Row),
    nth0(ColPos, Row, Piece).

equal_1(V):- V =:= 1.
equal_1(V):- V =:= -1.
equal_2(V):- V =:= 2.
equal_2(V):- V =:= -2.

moves(game_state(Size, TurnNo, Board, Player, Player1Type, Player2Type), Moves):-
    Limit is Size-1,
    findall([[X0, Y0], [X, Y]], (between(0, Limit, X0),
    between(0, Limit, Y0),
    between(0, Limit, X),
    between(0, Limit, Y), move(game_state(Size, TurnNo, Board, Player, Player1Type, Player2Type), [[X0, Y0], [X, Y]], _)), Moves).

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

choose_move(game_state(Size, TurnNo, Board, Player, Player1Type, Player2Type), computer-0, Move):-
    moves(game_state(Size, TurnNo, Board, Player, Player1Type, Player2Type), Moves),
    random_member(Move, Moves),
    write_computer(game_state(Size, TurnNo, Board, Player, Player1Type, Player2Type), Move).

choose_move(GameState, computer-1, Move):-
    moves(GameState, Moves),
    setof(Value-Move, NewGameState^( member(Move, Moves),  move(GameState, Move, NewGameState), value(NewGameState, Value)), [_-Move|_]),
    write_computer(GameState, Move).

write_computer(game_state(_, TurnNo, _, _, _, _), [Start, End]):-
    nl,
    write('Turn: '),
    write(TurnNo), nl,
    write('Computer: '),
    change_code_sim(Start, [SLetter, SNumber]),
    change_code_sim(End, [ELetter, ENumber]),
    write(SLetter), write(SNumber),
    write(' -> '), 
    write(ELetter), write(ENumber), 
    nl.

value(GameState, -1000.0):-
    game_over(GameState, _),
    !.

value(GameState, Value):-
    value_number(GameState, V1),
    value_piece_center(GameState, V2),
    value_pointing_center(GameState, V3),
    value_piece_difference(GameState, V4),
    value_center(GameState, V5),
    Value is V1 + V2 + V3 + V4 + V5.


value_piece_center(game_state(Size, _, Board, Player, _, _), -0.25):-
    center_board(Size, Center),
    player_to_piece(Player, Piece),
    check_piece(Board, Piece, Center),
    !.

value_piece_center(_, 0).

value_number(game_state(Size, _, Board, Player, _, _), V):-
    player_to_piece(Player, Piece),
    count_pieces(Board, Piece, C),
    V is -0.10 * (C/ Size).


value_pointing_center(game_state(Size, TurnNo, Board, Player, Player1Type, Player2Type), Value):-
    moves(game_state(Size, TurnNo, Board, Player, Player1Type, Player2Type), Moves),
    value_pointing_center_aux(Size, Moves, 0, N),
    player_to_piece(Player, Piece),
    count_pieces(Board, Piece, C),
    Value is -0.2 * (N/C),!.

value_pointing_center_aux(_, [], Number, Number).
value_pointing_center_aux(Size, [[_, End]|T], Acc, Number):-
    center_board(Size, End),
    NewAcc is Acc + 1,
    value_pointing_center_aux(Size, T, NewAcc, Number).
value_pointing_center_aux(Size, [_|T], Acc, Number):-
    value_pointing_center_aux(Size, T, Acc, Number).

value_piece_difference(game_state(_, _, Board, Player, _, _), Value):-
    player_to_piece(Player, CurrPiece),
    count_pieces(Board, CurrPiece, CurrPlayerPieces),
    OtherPlayer is (Player mod 2) + 1,
    player_to_piece(OtherPlayer, OtherPiece),
    count_pieces(Board, OtherPiece, OtherPlayerPieces),
    Value is -0.2 * ((CurrPlayerPieces - OtherPlayerPieces)/CurrPlayerPieces).

value_center(game_state(Size, TurnNo, Board, Player, Player1Type, Player2Type), Value):-
    center_board(Size, Center),
    player_to_piece(Player, Piece),
    get_all_pieces(game_state(Size, TurnNo, Board, Player, Player1Type, Player2Type), Piece, Pieces),
    calculate_dist(Pieces, Center, Sum),
    count_pieces(Board, Piece, Num),
    dist([0, 0], Center, D),
    Value is -0.25 * (Sum/(D * Num)).


/*
 -0.15 * NumberPieces -0.25 * (Ir para o centro) -0.20 *( Uma peça no centro)
 -0.20 * (1 peça que esta a apontar para o centro) + -0.20 * (Diferença de peças entre adversario e jogador) 
*/

calculate_dist([], _, 0).
calculate_dist([P|Positions], Center, Value):-
    dist(P, Center, D1),
    calculate_dist(Positions, Center, D2),
    Value is D1 + D2.

get_all_pieces(game_state(Size, _, Board, _, _, _), Piece, Pieces):-
    my_flatten(Board, B),
    get_all_pieces_aux(Size, B, Piece, 0, Pieces),
    !.

get_all_pieces_aux(_, [], _, _, []).

get_all_pieces_aux(Size, [Piece | T], Piece, Acc, [[I, J] | Pieces]):-
    I is div(Acc, Size),
    J is mod(Acc, Size),
    NewAcc is Acc + 1,
    get_all_pieces_aux(Size, T, Piece, NewAcc, Pieces).

get_all_pieces_aux(Size, [_ | T], Piece, Acc, Pieces):-
    NewAcc is Acc + 1,
    get_all_pieces_aux(Size, T, Piece, NewAcc, Pieces).


my_flatten([], []).
my_flatten([H|T], L):-
    my_flatten(T, LT),
    append(H, LT, L).


player_to_piece(1, 'W').
player_to_piece(2, 'B').

change_code_sim([I1, I2], [C1, I1T]):-
    I2T is I2 + 97,
    char_code(C1, I2T),
    I1T is I1 + 1.

dist([P1X, P1Y], [P2X, P2Y], Result):-
    Aux1 is P1X - P2X,
    Aux2 is P1Y - P2Y,
    Result is sqrt(Aux1 ^ 2 + Aux2 ^ 2).
