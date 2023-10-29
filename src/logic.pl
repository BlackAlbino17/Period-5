
% Predicate to make a move.
make_move(Board, Row, Column, Row1, Column1, NewBoard, Player) :-
    nl,
    write('Which piece do you want to move?'), nl,
    write('Row: '), nl, read(Row),
    write('Column: '), nl, read(Column),
    get_piece(Board, Player, Row, Column),
    write('Where do you want to place it?'), nl,
    write('Row: '), nl, read(Row1),
    write('Column: '), nl, read(Column1),
    valid_piece_move(Board, Row, Column, Row1, Column1, Piece),
    placePieceAndRemove(Board, Row, Column, Row1, Column1, NewBoard).

/*------------------------------------------------------------------------------------------------------------------------------------------------- */
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

/*------------------------------------------------------------------------------------------------------------------------------------------------- */
landing_on_occupied_square(Board, Row1, Column1, Piece) :-
    nth1(Row1, Board, Line),
    nth1(Column1, Line, Occupied),
    Occupied \== '------',
    Occupied \== Piece.
/*------------------------------------------------------------------------------------------------------------------------------------------------- */

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
/*------------------------------------------------------------------------------------------------------------------------------------------------- */
orthogonally_moved(Row, Column, Row1, Column1) :-
    (Row == Row1, abs(Column - Column1) >= 1; Column == Column1, abs(Row - Row1) >= 1).
/*------------------------------------------------------------------------------------------------------------------------------------------------- */
valid_piece_move(Board, Row, Column, Row1, Column1, Piece) :-
    orthogonally_moved(Row, Column, Row1, Column1),
    \+ piece_jumps_over(Board, Row, Column, Row1, Column1),
    \+ landing_on_occupied_square(Board, Row1, Column1, Piece).
/*------------------------------------------------------------------------------------------------------------------------------------------------- */

opponent_winning_next_move(Board, Player) :-
    switch_player(Player, Opponent),
    get_player_colors(Board, Opponent, PlayerColors, _),
    get_player_moves(Board, Opponent, _),
    final_check(Board, Opponent).
/*------------------------------------------------------------------------------------------------------------------------------------------------- */

% Predicado para lista de cores de um jogador

get_player_colors(Board, Player, PlayerColors, BoardColors) :-
    initialBoardColor(BoardColors),
    findall(Color, (nth1(Row, Board, Line), nth1(Column, Line, Piece),
        is_player_piece(Piece, Player), nth1(Row, BoardColors, Color)),
        PlayerColors),
    list_to_set(PlayerColors, UniquePlayerColors).


    % (length(UniquePlayerColors, 4) -> Flag = true ; Flag = false). May Not Be Needed Because i can just do
    % Later -> one_piece_per_column_check 


/*------------------------------------------------------------------------------------------------------------------------------------------------- */
% Predicado para lista de    moves de um jogador 

get_player_moves(Board, Player, Moves) :-
    findall((Row, Column, Row1, Column1), (
        between(1, 5, Row), 
        between(1, 5, Column),
        get_piece(Board, Player, Row, Column),
        valid_piece_moves(Board, Row, Column, Row1, Column1, Player)
    ), Moves).



/*------------------------------------------------------------------------------------------------------------------------------------------------- */
final_check(Board, Player) :-
    get_player_moves(Board, Player, Moves), 
    final_check_moves(Board, Player, Moves).  

final_check_moves(_, _, []) :- false.
final_check_moves(Board, Player, [(Row, Column, Row1, Column1) | Missing]) :-
    (color_check(Board, Player), one_piece_per_column_check(Board, Player))-> true;
    final_check_moves(Board, Player, Missing).

/*------------------------------------------------------------------------------------------------------------------------------------------------- */
% Predicado Para Player has 5 Colors
color_check(Board, Player) :-
    get_player_colors(Board, Player, PlayerColors, _),
    length(PlayerColors, 5).  

/*------------------------------------------------------------------------------------------------------------------------------------------------- */
% Predicado Para Player has 1 Piece In Each Column
 
 one_piece_per_column_check(Board, Player) :-
    findall(Column,
    (
        between(1, 5, Column),
        member(Row, [1, 2, 3, 4, 5]),
        get_piece(Board, Player, Row, Column)

    ), Columns),
    list_to_set(Columns, UniqueColumns),
    length(UniqueColumns, 5).


/*------------------------------------------------------------------------------------------------------------------------------------------------- */
/*
remove_duplicates([], []).

remove_duplicates([Head | Tail], Result) :-
    member(Head, Tail), !,
    remove_duplicates(Tail, Result).

remove_duplicates([Head | Tail], [Head | Result]) :-
    remove_duplicates(Tail, Result).
*/
/*------------------------------------------------------------------------------------------------------------------------------------------------- */







/*------------------------------------------------------------------------------------------------------------------------------------------------- */
/*winning_state()
if player has 5 colors (no repetitions) in which he has 1 piece in each column then -> Player wins and game stops
Show ("Player_X") won the game,
2 options -> Play again
             Go back to menu.
*/


/* ------------------------------------------------------------------------------------------------------------------------------------------------- */
/*
% A move is valid if it follows the rules.
valid_move(Board, Row, Column, Row1, Column1, Player) :-
    is_player_piece(Piece, Player), % Check if it's the player's piece. %checked
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

