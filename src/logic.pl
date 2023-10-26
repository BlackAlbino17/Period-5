
% Predicate to make a move.
make_move(Board, Row, Column, Row1, Column1, NewBoard) :-
    nl,
    write('Which piece do you want to move?'), nl,
    write('Row: '), nl, read(Row),
    write('Column: '), nl, read(Column),
    write('Where do you want to place it?'), nl,
    write('Row: '), nl, read(Row1),
    write('Column: '), nl, read(Column1),
    valid_piece_move(Board, Row, Column, Row1, Column1, Piece),
    placePieceAndRemove(Board, Row, Column, Row1, Column1, NewBoard).

% Predicado para mover a peça e remover a peça na posição original.
placePieceAndRemove(Board, Row, Column, Row1, Column1, NewBoard) :-
    % Get the piece from the original cell.
    nth1(Row, Board, Line),
    nth1(Column, Line, Piece),

    % Remove the piece from the original cell.
    removePiece(Board, Row, Column, TempBoard),

    % Place the piece in the new cell.
    placePiece(TempBoard, Piece, Row1, Column1, NewBoard),
    header,
    display_board(NewBoard, 1, 1),
    nl,
    display_color_board.


% Implement the update_board predicate to update the game board based on the move.

replace([_|T], 1, X, [X|T]) :- !.
replace([H|T], I, X, [H|R]) :- I > 1,
                    NI is I-1,
                    replace(T, NI, X, R).

placePiece(Board, Piece, X, Y, NewBoard) :- 

                        nth1(X, Board, Line),
                        replace(Line, Y, Piece, NewLine),
                        replace(Board, X, NewLine, NewBoard).


removePiece(Board, X, Y, NewBoard) :- 
                        nth1(X, Board, Line),
                        replace(Line, Y, '------', NewLine),
                        replace(Board, X, NewLine, NewBoard).


landing_on_occupied_square(Board, Row1, Column1, Piece) :-
    nth1(Row1, Board, Line),
    nth1(Column1, Line, Occupied),
    Occupied \== '------',
    Occupied \== Piece.


piece_jumps_over(Board, Row, Column, Row1, Column1) :-
    \+ is_empty_path(Board, Row, Column, Row1, Column1),
    \+ is_empty_path(Board, Row1, Column1, Row, Column).

is_empty_path(Board, Row, Column, Row1, Column1) :-
    Row < Row1, is_empty_between_rows(Board, Row, Row1, Column).
is_empty_path(Board, Row, Column, Row1, Column1) :-
    Row > Row1, is_empty_between_rows(Board, Row1, Row, Column).
is_empty_path(Board, Row, Column, Row1, Column1) :-
    Column < Column1, is_empty_between_columns(Board, Row, Column, Column1).
is_empty_path(Board, Row, Column, Row1, Column1) :-
    Column > Column1, is_empty_between_columns(Board, Row, Column1, Column).

is_empty_between_rows(Board, Row, Row1, Column) :-
    Row2 is Row + 1,
    (Row2 == Row1; (nth1(Row2, Board, Line), nth1(Column, Line, '------'), is_empty_between_rows(Board, Row2, Row1, Column))).
is_empty_between_columns(Board, Row, Column, Column1) :-
    Column2 is Column + 1,
    (Column2 == Column1; (nth1(Row, Board, Line), nth1(Column2, Line, '------'), is_empty_between_columns(Board, Row, Column2, Column1))).

orthogonally_moved(Row, Column, Row1, Column1) :-
    (Row == Row1, abs(Column - Column1) >= 1; Column == Column1, abs(Row - Row1) >= 1).

valid_piece_move(Board, Row, Column, Row1, Column1, Piece) :-
    orthogonally_moved(Row, Column, Row1, Column1),
    \+ piece_jumps_over(Board, Row, Column, Row1, Column1),
    \+ landing_on_occupied_square(Board, Row1, Column1, Piece).

    
/* ------------------------------------------------------------------------------------------------------------------------------------------------- */
/*
% A move is valid if it follows the rules.
valid_move(Board, Row, Column, Row1, Column1, Player) :-
    is_player_piece(Piece, Player), % Check if it's the player's piece.
    valid_piece_move(Board, Row, Column, Row1, Column1, Piece), % Check valid piece moves.
    \+ cube_repeated_move(Board, Row, Column, Row1, Column1), % Cube cannot return immediately.
    \+ opponent_winning_next_move(Board, Row1, Column1, Piece, Player). % Opponent shouldn't win next move.





cube_repeated_move(Board, Row, Column, Row1, Column1) :-
    nth1(Row, Board, Line),
    nth1(Column, Line, 'cube'),
    Row == Row1,
    Column == Column1.


opponent_winning_next_move(Board, Row, Column, Piece, Player) :-
    switch_player(Player, Opponent),
    valid_move(Board, Row, Column, _, _, Opponent), % Check if the opponent can win.
    % Implement your win condition checking here.
    % You need to check if the opponent's move would lead to a win in the next turn.
    % Add your specific win condition logic.
*/

