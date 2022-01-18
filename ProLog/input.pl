/*
read_move_input(-Move)

Ex:
Input: a1. b3.
Move = [[0, 0], [2, 1]]
*/

read_move_input(game_state(_, TurnNo, Board, Player, _, _), Move):-
    repeat,
    nl,
    write('Turn: '),
    write(TurnNo), nl,
    write('Player: '),
    write(Player), nl,
    write('Input piece position (Ex: a1): '),
    read(StartI),
    atom_chars(StartI, StartPos),
    write('Input piece destination (Ex: b3): '),
    read(EndI),
    atom_chars(EndI, EndPos),
    input_to_move(StartPos, EndPos, Move),
    valid_input(Board, Player, Move),
    !.

valid_input(Board, Player, Move):-
    valid_positions(Board, Player, Move).

valid_input(_, _, _):-
    write('Non valid positions.'),
    nl, nl,
    fail.
    

% Move = [[StartRow, StartCol], [EndRow, EndCol]]
input_to_move(Start, End, [StartPos, EndPos]):-
    change_code(Start, StartPos),
    change_code(End, EndPos).

change_code([C1, C2], [I2, I1]):-
    char_code('a', A),
    char_code('1', Z),
    char_code(C1, CC1),
    char_code(C2, CC2),
    I1 is CC1 - A,
    I2 is CC2 - Z.

change_code([C1, C2, C3], [I2, I1]):-
    char_code('a', A),
    char_code('0', Z),
    char_code(C1, CC1),
    char_code(C2, CC2),
    char_code(C3, CC3),
    I1 is CC1 - A,
    I2 is (CC2-Z)*10 + (CC3-Z) - 1.

/*
read_start_input(-P1, -P2, -Size)
*/

read_start_input(Player1Type, Player2Type, Size):-
    read_game_type(Player1Type, Player2Type),
    read_board_size(Size).

read_game_type(Player1Type, Player2Type):-
    write_game_options(Option),
    option_to_player_types(Option, Player1Type, Player2Type).

write_game_options(Option):-
    repeat,
    write('Choose game type:'), nl,
    write('a - human vs human'), nl,
    write('b - human vs random bot'), nl,
    write('c - random bot vs human'), nl,
    write('d - random bot vs random bot'), nl,
    write('e - human vs greedy bot'), nl,
    write('f - greedy bot vs human'), nl,
    write('g - random bot vs greedy bot'), nl,
    write('h - greedy bot vs random bot'), nl,
    write('i - greedy bot vs greedy bot'), nl,
    write('Type: '),
    read(Option),
    char_code(Option, Char),
    Char >= 97,
    Char =< 105,
    !.

option_to_player_types(a, human, human).
option_to_player_types(b, human, computer-0).
option_to_player_types(c, computer-0, human).
option_to_player_types(d, computer-0, computer-0).
option_to_player_types(e, human, computer-1).
option_to_player_types(f, computer-1, human).
option_to_player_types(g, computer-0, computer-1).
option_to_player_types(h, computer-1, computer-0).
option_to_player_types(i, computer-1, computer-1).


read_board_size(Size):-
    repeat,
    write('Choose Board Size (Size higher or equal than 5 & odd): '),
    read(Size),
    Size >= 5,
    Mod is Size mod 2,
    Mod \= 0,
    !.
    