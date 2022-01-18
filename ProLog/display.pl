:-use_module(library(lists)).

/*
display_game(+GameState)

Example = [['K', 'k', ' ', 'k', 'k', 'K', 'k', ' ', 'K'], ['K', 'k', ' ', 'k', 'k', 'K', 'k', ' ', 'K'], ['K', 'k', ' ', 'k', 'k', 'K', 'k', ' ', 'K'], ['K', 'k', ' ', 'k', 'k', 'K', 'k', ' ', 'K'], ['K', 'k', ' ', 'k', 'k', 'K', 'k', ' ', 'K'], ['K', 'k', ' ', 'k', 'k', 'K', 'k', ' ', 'K'], ['K', 'k', ' ', 'k', 'k', 'K', 'k', ' ', 'K'], ['K', 'k', ' ', 'k', 'k', 'K', 'k', ' ', 'K'], ['K', 'k', ' ', 'k', 'k', 'K', 'k', ' ', 'K']]
Example = display([['W', 'B', ' '], ['B', 'W', ' '], ['B', 'B', ' ']], 3).

*/

display_game(game_state(Size, TurnNo, Board, Player, Player1Type, Player2Type)):-
    LSize is Size - 1,
    display_between(0, LSize),
    letter_display(0, Size),
    display_game_aux(game_state(Size, TurnNo, Board, Player, Player1Type, Player2Type), 1).

display_game_aux(game_state(Size, _, [], _, _, _), _):-
    display_between(0, Size).

display_game_aux(game_state(Size, _, [H|T], _, _, _), Line):-
    display_between(0, Size),
    row_display(H, Line),
    NewLine is Line + 1,
    display_game_aux(game_state(Size, _, T, _, _, _), NewLine).

display_between(Size, Size):-
    write('#---#'),
    nl.
display_between(Acc, Size):-
    write('#---'),
    NewAcc is Acc + 1,
    display_between(NewAcc, Size).

row_display([], Line):-
    write('| '),
    write(Line),
    write(' |'),
    nl.
row_display([H|T], Line):-
    write('| '),
    write(H),
    write(' '),
    row_display(T, Line).

letter_display(Size, Size):-
    write('|'),
    nl.
letter_display(Acc, Size):-
    Code is Acc + 97,
    char_code(Letter, Code),
    write('| '),
    write(Letter),
    write(' '),
    NewAcc is Acc + 1,
    letter_display(NewAcc, Size).
