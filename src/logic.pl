




% Predicate to make a move.
make_move(Board, Row, Column, Row1, Column1, NewBoard, Player) :-
    validate_move(Board, Player, Row, Column, Row1, Column1),
    placePieceAndRemove(Board, Row, Column, Row1, Column1, NewBoard).

/*------------------------------------------------------------------------------------------------------------------------------------------------- */
placePieceAndRemove(Board, Row, Column, Row1, Column1, NewBoard) :-
    % Get the piece from the original cell.
    nth1(Row, Board, Line),
    nth1(Column, Line, Piece),

    % Remove the piece from the original cell.
    removePiece(Board, Row, Column, TempBoard),

    % Place the piece in the new cell.
    placePiece(TempBoard, Piece, Row1, Column1, NewBoard).

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
winning_next_move(Board, Player) :-

    get_all_player_moves(Board, Player, ValidMoves),
    member((Row, Column, Row1, Column1), ValidMoves),
    simulate_move(Board, Row, Column, Row1, Column1, SimulatedBoard, Player).


simulate_move(Board, Row, Column, Row1, Column1, NewBoard, Player) :-
    copy_term(Board, NewBoard),
    placePieceAndRemove(NewBoard, Row, Column, Row1, Column1, Recent),
    one_piece_per_column_check(Recent, Player),
    color_check(Recent, Player).






/*------------------------------------------------------------------------------------------------------------------------------------------------- */

% Predicado para lista de cores de um jogador

get_player_colors(Board, Player, PlayerColors, BoardColors) :-
    initialBoardColor(BoardColors),
    findall(Color, (
        nth1(Row, Board, Line), 
        nth1(Column, Line, Piece),
        is_player_piece(Piece, Player),
        nth1(Row, BoardColors, RowColors),
        nth1(Column, RowColors, Color)
    ), RawPlayerColors),
    list_to_set(RawPlayerColors, PlayerColors).




    % (length(UniquePlayerColors, 4) -> Flag = true ; Flag = false). May Not Be Needed Because i can just do
    % Later -> one_piece_per_column_check 


/*------------------------------------------------------------------------------------------------------------------------------------------------- */
% Predicate to make a list of all possible valid moves a player can make


get_moves([], _, _, ValidMoves, ValidMoves).
get_moves([(Row, Column) | Rest], Player, Board, Acc, ValidMoves) :-
    findall((Row, Column, Row1, Column1), (
        between(1, 5, Row1),
        between(1, 5, Column1),
        valid_piece_move(Board, Row, Column, Row1, Column1, Piece),
        get_piece(Board, Player, Row, Column, Piece)
    ), Moves),
    append(Acc, Moves, NewAcc),
    get_moves(Rest, Player, Board, NewAcc, ValidMoves).










/*------------------------------------------------------------------------------------------------------------------------------------------------- */


/*------------------------------------------------------------------------------------------------------------------------------------------------- */
% Predicado Para Player has 5 Colors
color_check(Board, Player) :-
    get_player_colors(Board, Player, PlayerColors, _),
    length(PlayerColors, 5).  

/*------------------------------------------------------------------------------------------------------------------------------------------------- */
% Predicado Para Player1 or 2 has 1 Piece In Each Column
 
 one_piece_per_column_check(Board, Player) :-
    findall(Column,
    (
        between(1, 5, Column),
        member(Row, [1, 2, 3, 4, 5]),
        get_piece(Board, Player, Row, Column,Piece)

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
    \+ Player_winning_next_move(Board, Row1, Column1, Piece, Player). % Player shouldn't win next move.





cube_repeated_move(Board, Row, Column, Row1, Column1) :-
    nth1(Row, Board, Line),
    nth1(Column, Line, 'cube'),
    Row == Row1,
    Column == Column1.


Player_winning_next_move(Board, Row, Column, Piece, Player) :-
    switch_player(Player, Player),
    valid_move(Board, Row, Column, _, _, Player), % Check if the Player can win.
    % Implement your win condition checking here.
    % You need to check if the Player's move would lead to a win in the next turn.
    % Add your specific win condition logic.
*/

