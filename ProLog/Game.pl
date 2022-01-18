:-consult('display.pl').
:-consult('board.pl').
:-consult('moves.pl').
:-consult('input.pl').

/*
play/0
*/

play:-
    read_start_input(P1, P2, Size),
    initial_state(Size, GameState).

/*
initial_state(+Size, -GameState)
game_state(+TurnNo, +Board, +Player, +Size)
*/

initial_state(Size, Size-0-Board-1):-
    create_board(Size, Board).


game_cycle(GameState):-
    game_over(GameState, Winner),
    !,
    write(Winner).

game_cycle(game_state(Size, TurnNo, Board, Player,  Player1Type, Player2Type)):-
    PlayerTypePos is Player + 4,
    arg(PlayerTypePos, game_state(Size, TurnNo, Board, Player,  Player1Type, Player2Type), PlayerType),
    choose_move(game_state(Size, TurnNo, Board, Player,  Player1Type, Player2Type), PlayerType, Move).


