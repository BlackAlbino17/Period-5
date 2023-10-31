% Step 1: Predicate to generate valid moves for a player.
valid_moves(Board, Player, ValidMoves) :-
    findall([Row, Column, NewRow, NewColumn], (
        is_player_piece(Board, Player, Row, Column, Piece),
        valid_piece_move(Board, Row, Column, NewRow, NewColumn, Piece)
    ), ValidMoves).

% Step 2: Predicate for the easy level AI to choose a random move.
easy_level_ai(Board, Player, Row, Column, NewRow, NewColumn) :-
    valid_moves(Board, Player, ValidMoves),
    length(ValidMoves, NumValidMoves),
    random(0, NumValidMoves, RandomIndex),
    nth0(RandomIndex, ValidMoves, [Row, Column, NewRow, NewColumn]).

% Step 3: In the game loop, for the AI's turn (easy level).
% Assuming the AI player is 'AIPlayer', you can call:
easy_level_ai(Board, 'AIPlayer', Row, Column, NewRow, NewColumn),
make_move(Board, Row, Column, NewRow, NewColumn, NewBoard, 'AIPlayer').
