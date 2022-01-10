/*
read_move_input(-Move)

Ex:
Input: a1. b3.
Move = [[0, 0], [2, 1]]
*/

read_move_input(Move):-
    write('Input piece position (Ex: a1): '),
    read(StartI),
    atom_chars(StartI, StartPos),
    write('Input piece destination (Ex: b3): '),
    read(EndI),
    atom_chars(EndI, EndPos),
    input_to_move(StartPos, EndPos, Move).

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

read_start_input(P1, P2, Size):-
    read_player_type(1, P1),
    read_player_type(2, P2),
    read_board_size(Size).

read_player_type(Number, Type):-
    repeat,
    write('Choose Player '),
    write(Number),
    write(' type (h or pc): '),
    read(Type),
    player_type(Type),
    !.

player_type(h).
player_type(pc).

read_board_size(Size):-
    repeat,
    write('Choose Board Size (Size higher or equal than 5 & odd): '),
    read(Size),
    Size >= 5,
    Mod is Size mod 2,
    Mod \= 0,
    !.
    