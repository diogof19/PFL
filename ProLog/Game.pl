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


