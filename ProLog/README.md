GameState(+Size, +TurnNo, +Board, +Player).

-- Funçao que conta o numero de peças

CountPieces(+Board, +Player, -Count).

-- Funçao de jogar

move(+GameState, +Move, -NewGameState).

Move->[e3, c1]

display_game(+GameState)
valid_moves(+GameState, -ListOfMoves)
initial_state(+Size, -GameState) -> Size vai ser igual = 9 ?????????????? Perguntar ao stor
game_over(+GameState, -Winner)

value(+GameState, +Player, -Value)
choose_move(+GameState, +Level, -Move)