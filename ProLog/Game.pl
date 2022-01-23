:-consult('display.pl').
:-consult('board.pl').
:-consult('moves.pl').
:-consult('input.pl').

/*
play/0
*/
play:-
    read_board_size(Size),
    initial_state(Size, GameState),
    display_game(GameState),
    game_cycle(GameState).

/*
initial_state(+Size, -GameState)
game_state(+TurnNo, +Board, +Player, +Size)
*/

initial_state(Size, game_state(Size, 1, Board, 1, Player1Type, Player2Type)):-
    read_game_type(Player1Type, Player2Type),
    create_board(Size, Board).

game_cycle(GameState):-
    game_over(GameState, Winner),
    !,
    congratulations(Winner).

game_cycle(game_state(Size, TurnNo, Board, Player, Player1Type, Player2Type)):-
    PlayerTypePos is Player + 4,
    arg(PlayerTypePos, game_state(Size, TurnNo, Board, Player, Player1Type, Player2Type), PlayerType),
    choose_move(game_state(Size, TurnNo, Board, Player, Player1Type, Player2Type), PlayerType, Move),
    move(game_state(Size, TurnNo, Board, Player, Player1Type, Player2Type), Move, TempGameState),
    next_player(TempGameState, NewGameState),
    display_game(NewGameState),
    !,
    game_cycle(NewGameState).

/*
value(GameState, Value):-
    value_number(GameState, V1),
    value_initial_move(GameState, V2),
    value_poiting_center(GameState, V3),
    value_piece_difference(GameState, V4),
    value_center(GameState, V5),
    Value is V1 + V2 + V3 + V4 + V5.
*/
congratulations(Winner):-
    nl,
    write('Congratulations!'), nl,
    write('Player '),
    write(Winner),
    write(' wins!').

next_player(game_state(Size, TurnNo, Board, Player, Player1Type, Player2Type), game_state(Size, TurnNo, Board, NewPlayer, Player1Type, Player2Type)):-
    NewPlayer is (Player mod 2) + 1.